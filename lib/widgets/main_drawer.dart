import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app/pages/landing_page.dart';
import 'package:recipe_app/pages/tabs_page.dart';

import '../pages/filters_page.dart';
import '../pages/profile_page.dart';

class MainDrawer extends StatelessWidget {
  final User user;
  final VoidCallback signOut;
  final FirebaseAuth auth;

  MainDrawer(this.user, this.signOut, this.auth);

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "RobotoCondensed"),
      ),
      onTap: tapHandler,
    );
  }

  Widget buildListTile2(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "RobotoCondensed"),
      ),
      onTap: tapHandler,
    );
  }

  Widget buildListTile3(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "RobotoCondensed"),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              "Recipe App",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile2("Profil", Icons.account_circle, () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(user, signOut, auth),
              ),
            );
          }),
          buildListTile("Yemekler", Icons.restaurant, () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TabsPage(user, signOut, auth),
              ),
            );
          }),
          buildListTile2("Filtreler", Icons.settings, () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => FiltersPage(user, signOut, auth),
              ),
            );
          }),
          buildListTile3("Çıkış Yap", Icons.assistant_direction, () async {
            final googleUser = GoogleSignIn();
            await googleUser.signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
