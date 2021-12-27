import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = "/signin";
  final Function(User) onSignIn;
  final FirebaseAuth auth;

  SigninPage(this.onSignIn, this.auth);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  List<String> ids = [];
  bool _isLoading = false;

  void addUser(User user, String email, String name, String surname) {
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
    FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "email": email,
      "image": image,
      "favorites": favorites,
      "filters": filters,
      "name": name,
      "surname": surname,
      "userMeals": userMeals,
      "votes": votes
    });
  }

  void signInGoogle() async {
    setState(() {
      _isLoading = true;
    });
    GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        UserCredential result = await widget.auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        bool userVar = false;
        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: googleUser.email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            userVar = true;
          });
        });
        if (!userVar) {
          List<String> nameSurname = googleUser.displayName.split(" ");
          String name = "";
          if (nameSurname.length > 2) {
            name = nameSurname[0] + " " + nameSurname[1];
          } else {
            name = nameSurname[0];
          }
          addUser(result.user, googleUser.email, name, nameSurname.last);
        }
        widget.onSignIn(result.user);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void signInEmail(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginPage(widget.onSignIn, widget.auth),
        fullscreenDialog: true));
  }

  Widget buildRaisedButton(Color butonColor, Color titleColor, String title,
      Widget widget, Function onPress) {
    return RaisedButton(
      onPressed: onPress,
      color: butonColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget,
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: TextStyle(color: titleColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              buildRaisedButton(
                  Colors.white,
                  Colors.black54,
                  "Google ile Giriş Yap",
                  Image.asset("images/googleIcon.png"),
                  () => signInGoogle()),
            if (!_isLoading)
              buildRaisedButton(
                  Colors.white,
                  Colors.black54,
                  "Email ve Şifre ile Giriş Yap",
                  Icon(
                    Icons.mail,
                    size: 35,
                    color: Colors.indigo,
                  ),
                  () => signInEmail(context))
          ],
        ),
      ),
    );
  }
}
