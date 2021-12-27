import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/main_drawer.dart';
import 'landing_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback signOut;
  final FirebaseAuth auth;

  ProfilePage(this.user, this.signOut, this.auth);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  bool _changeImage = false;
  String _email = "";
  String _name = "";
  String _surname = "";
  String _imageUrl;

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  void _saveImage() async {
    if (_changeImage) {
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child(widget.user.uid + ".png");
        await ref.putFile(_image).whenComplete(() => null);
        _imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .update({"image": _imageUrl});
      }
    }
  }

  void _deleteAccount(BuildContext ctx) async {
    String sifre = "";
    bool hataVar = false;
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Hesabı Sil"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Size ait tüm veriler silinecektir!\n"
                  " Hesabınızı silmek için hesap şifrenizi giriniz"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Hesap Şifresi",
                    border: OutlineInputBorder()),
                onChanged: (girilenDeger) async {
                  sifre = girilenDeger.trim();
                },
              )
            ]),
            actions: [
              FlatButton(
                  onPressed: hataVar
                      ? () {}
                      : () async {
                          hataVar = false;
                          try {
                            if (_email.contains("@gmail.com")) {
                              GoogleSignIn googleSignIn = new GoogleSignIn();
                              GoogleSignInAccount googleUser =
                                  await googleSignIn.signIn();
                              GoogleSignInAuthentication googleAuth =
                                  await googleUser.authentication;
                              AuthCredential credentials =
                                  GoogleAuthProvider.credential(
                                      idToken: googleAuth.idToken,
                                      accessToken: googleAuth.accessToken);
                              final UserCredential result = await widget.user
                                  .reauthenticateWithCredential(credentials);
                            } else {
                              AuthCredential credentialss =
                                  EmailAuthProvider.credential(
                                      email: _email, password: sifre);
                              UserCredential resultt = await widget.user
                                  .reauthenticateWithCredential(credentialss);
                            }
                          } catch (err) {
                            hataVar = true;
                          }
                          if (!hataVar) {
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child("userImages")
                                .child(widget.user.uid + ".png");
                            await ref.delete();
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.user.uid)
                                .delete();
                            if (_email.contains("@gmail.com")) {
                              GoogleSignIn googleSignIn = new GoogleSignIn();
                              GoogleSignInAccount googleUser =
                                  await googleSignIn.signIn();
                              GoogleSignInAuthentication googleAuth =
                                  await googleUser.authentication;
                              AuthCredential credentials =
                                  GoogleAuthProvider.credential(
                                      idToken: googleAuth.idToken,
                                      accessToken: googleAuth.accessToken);
                              final UserCredential result = await widget.user
                                  .reauthenticateWithCredential(credentials);
                              await result.user
                                  .delete()
                                  .whenComplete(() => null);
                              await googleSignIn.signOut();
                            } else {
                              final AuthCredential credentials =
                                  EmailAuthProvider.credential(
                                      email: _email, password: sifre);
                              final UserCredential result = await widget.user
                                  .reauthenticateWithCredential(credentials);
                              await result.user
                                  .delete()
                                  .whenComplete(() => null);
                              await FirebaseAuth.instance.signOut();
                            }
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LandingPage(),
                              ),
                            );
                          }
                        },
                  child: Text("Sil")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("İptal")),
            ],
          );
        });
  }

  void _pickImage() async {
    _changeImage = true;
    final pickedImage = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  void _deleteImage() {
    setState(() {
      _image = null;
      _imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveImage,
          )
        ],
      ),
      drawer: MainDrawer(widget.user, widget.signOut, widget.auth),
      body: StreamBuilder<QuerySnapshot>(
        stream: buildStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) {
              String userEmail = element.data()["email"];
              if (userEmail == widget.user.email) {
                _email = element.data()["email"];
                _name = element.data()["name"];
                _surname = element.data()["surname"];
                _imageUrl = element.data()["image"];
              }
            });
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.account_circle,
                          size: _changeImage
                              ? (_image == null ? 100 : 0)
                              : ((_imageUrl == null || _imageUrl.isEmpty)
                                  ? 100
                                  : 0),
                        ),
                        backgroundImage: _changeImage
                            ? (_image == null ? null : FileImage(_image))
                            : ((_imageUrl == null || _imageUrl.isEmpty)
                                ? null
                                : NetworkImage(_imageUrl)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton.icon(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _pickImage,
                            label: Text("Resim Değiştir"),
                            icon: Icon(Icons.add_a_photo),
                          ),
                          FlatButton.icon(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _deleteImage,
                            label: Text("Resmi Sil"),
                            icon: Icon(Icons.image_not_supported),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Ad:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Soyad:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _surname,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Email:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _email,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    onPressed: () => _deleteAccount(context),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "Hesabımı Sil",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("Profil Yüklenemedi !"));
          }
        },
      ),
    );
  }
}
