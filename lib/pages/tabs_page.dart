import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/add_meal_page.dart';

import '../widgets/main_drawer.dart';
import 'category_page.dart';
import 'favorites_page.dart';
import 'meals_page.dart';

class TabsPage extends StatefulWidget {
  final User user;
  final VoidCallback signOut;
  final FirebaseAuth auth;

  TabsPage(this.user, this.signOut, this.auth);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  Map<String, dynamic> _datas;
  bool _isStart = false;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _isStart = false;
    super.initState();
  }

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (_isStart) {
      title = _pages[_selectedPageIndex]["title"];
    } else {
      title = "Kategoriler";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(widget.user, widget.signOut, widget.auth),
      body: StreamBuilder<QuerySnapshot>(
        stream: buildStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) {
              String userEmail = element.data()["email"];
              if (userEmail == widget.user.email) {
                _datas = element.data();
                _datas["id"] = element.id;
              }
            });
            _isStart = true;
            _pages = [
              {"page": CategoryPage(_datas["filters"]), "title": "Kategoriler"},
              {
                "page": FavoritesPage(widget.user, _datas["favorites"]),
                "title": "Favorilerim"
              },
              {
                "page": MealsPage(widget.user, _datas["userMeals"]),
                "title": "Yemeklerim"
              }
            ];
            return _pages[_selectedPageIndex]["page"];
          } else {
            return Center(child: Text("Ana Ekran Yüklenemedi !"));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Kategoriler"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assistant), label: "Favorilerim"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_motion), label: "Yemeklerim"),
        ],
      ),
      floatingActionButton: _selectedPageIndex == 2
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  Navigator.of(context)
                      .pushNamed(AddMealPage.routeName, arguments: _datas);
                });
              },
            )
          : null,
    );
  }
}
