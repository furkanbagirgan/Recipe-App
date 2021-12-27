import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum FormType { Register, Login }

class LoginPage extends StatefulWidget {
  final Function(User) onSignIn;
  final FirebaseAuth auth;
  LoginPage(this.onSignIn, this.auth);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _sifre;
  String _name = "", _surname = "";
  String _buttonText, _linkText;
  var _formType = FormType.Login;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;

  void addUser(User user, String email, String name, String surname) async {
    String image = "";
    List<String> favorites = [];
    List<String> userMeals = [];
    Map<String, int> votes = {};
    Map<String, bool> filters = {
      "glutenFree": false,
      "lactoseFree": false,
      "vegan": false,
      "vegetarian": false
    };

    if (_image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child(user.uid + ".png");
      await ref.putFile(_image).whenComplete(() => null);
      image = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "email": email,
      "favorites": favorites,
      "filters": filters,
      "name": name,
      "surname": surname,
      "userMeals": userMeals,
      "votes": votes,
      "image": image
    });
  }

  void signInEmail(BuildContext ctx) async {
    if (_email.contains("@")) {
      if (_sifre.length >= 6) {
        bool userVar = false;
        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: _email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            userVar = true;
          });
        });
        if (!userVar) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Bu Mail Adresine Sahip Bir Hesap Bulunmamakta!"),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        } else {
          try {
            UserCredential result = await widget.auth
                .signInWithEmailAndPassword(email: _email, password: _sifre);
            widget.onSignIn(result.user);
            Navigator.of(context).pop();
          } catch (err) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Girilen Şifre Hatalı!"),
              backgroundColor: Theme.of(ctx).errorColor,
            ));
          }
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Şifre En Az 6 Karakter Uzunluğunda Olmalıdır!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Email Adresi Uygun Formatta Değil!"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  void createEmail(BuildContext ctx) async {
    if (_email != "") {
      if (_sifre != "") {
        if (_name != "") {
          if (_surname != "") {
            if (_email.contains("@")) {
              if (_sifre.length >= 6) {
                bool userVar = false;
                await FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: _email)
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    userVar = true;
                  });
                });
                if (!userVar) {
                  UserCredential result = await widget.auth
                      .createUserWithEmailAndPassword(
                          email: _email, password: _sifre);
                  addUser(result.user, _email, _name, _surname);
                  widget.onSignIn(result.user);
                  Navigator.of(context).pop();
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                        "Bu Mail Adresine Sahip Bir Hesap Zaten Bulunmakta!"),
                    backgroundColor: Theme.of(ctx).errorColor,
                  ));
                }
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content:
                      Text("Şifre En Az 6 Karakter Uzunluğunda Olmalıdır!"),
                  backgroundColor: Theme.of(ctx).errorColor,
                ));
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Email Adresi Uygun Formatta Değil!"),
                backgroundColor: Theme.of(ctx).errorColor,
              ));
            }
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Soyad Boş Bırakılamaz!"),
              backgroundColor: Theme.of(ctx).errorColor,
            ));
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Ad Boş Bırakılamaz!"),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Şifre Boş Bırakılamaz!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Email Boş Bırakılamaz!"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login
        ? "Hesabınız Yok mu? - Hemen Kayıt Olun"
        : "Hesabınız Var mı? - Hemen Giriş Yapın";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Giriş / Kayıt"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _formType == FormType.Register
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.account_circle,
                              size: _image == null ? 100 : 0,
                            ),
                            backgroundImage:
                                _image == null ? null : FileImage(_image),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton.icon(
                                textColor: Theme.of(context).primaryColor,
                                onPressed: _pickImage,
                                label: Text("Resim Ekle"),
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
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _formType == FormType.Register
                    ? TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_box),
                            hintText: "Ad",
                            labelText: "Ad",
                            border: OutlineInputBorder()),
                        onSaved: (girilenDeger) {
                          _name = girilenDeger;
                        },
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _formType == FormType.Register
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _formType == FormType.Register
                    ? TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_box),
                            hintText: "Soyad",
                            labelText: "Soyad",
                            border: OutlineInputBorder()),
                        onSaved: (girilenDeger) {
                          _surname = girilenDeger;
                        },
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _formType == FormType.Register
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: "Email",
                      labelText: "Email",
                      border: OutlineInputBorder()),
                  onSaved: (girilenDeger) {
                    _email = girilenDeger.trim();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Şifre",
                      labelText: "Şifre",
                      border: OutlineInputBorder()),
                  onSaved: (girilenDeger) {
                    _sifre = girilenDeger.trim();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    if (_formType == FormType.Login) {
                      signInEmail(context);
                    } else {
                      createEmail(context);
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      _buttonText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _degistir(),
                  child: Text(
                    _linkText,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
