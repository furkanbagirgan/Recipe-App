import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersPage extends StatefulWidget {
  final User user;
  final VoidCallback signOut;
  final FirebaseAuth auth;

  FiltersPage(this.user, this.signOut, this.auth);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  Map<String, bool> _filters;
  bool _changed = false;
  bool _glutenFree = false;
  bool _lactoseFree = false;
  bool _vegan = false;
  bool _vegetarian = false;
  bool _isStarting = true;

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  void _saveFilters() async {
    _filters["glutenFree"] = _glutenFree;
    _filters["lactoseFree"] = _lactoseFree;
    _filters["vegan"] = _vegan;
    _filters["vegetarian"] = _vegetarian;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .update({
      "filters": _filters,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtreler"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveFilters)],
      ),
      drawer: MainDrawer(widget.user, widget.signOut, widget.auth),
      body: _isStarting
          ? StreamBuilder<QuerySnapshot>(
              stream: buildStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  snapshot.data.docs.forEach((element) async {
                    String userEmail = element.data()["email"];
                    if (userEmail == widget.user.email) {
                      _filters = Map.from(element.data()["filters"]);
                      await FirebaseFirestore.instance
                          .collection("users")
                          .where("email", isEqualTo: widget.user.email)
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          setState(() {
                            _isStarting = false;
                          });
                        });
                      });
                    }
                  });
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(child: Text("Filtreler Yüklenemedi !"));
                }
              },
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Yemek Seçiminizi Ayarlayın",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                    child: ListView(
                  children: [
                    SwitchListTile(
                      title: Text("Glutensiz"),
                      value: _changed ? _glutenFree : _filters["glutenFree"],
                      subtitle: Text("Sadece glutensiz yemekler gösterilir."),
                      onChanged: (newValue) {
                        setState(() {
                          _glutenFree = newValue;
                          _changed = true;
                        });
                      },
                    ),
                    SwitchListTile(
                        title: Text("Laktozsuz"),
                        value:
                            _changed ? _lactoseFree : _filters["lactoseFree"],
                        subtitle: Text("Sadece laktozsuz yemekler gösterilir."),
                        onChanged: (newValue) {
                          setState(() {
                            _changed = true;
                            _lactoseFree = newValue;
                          });
                        }),
                    SwitchListTile(
                        title: Text("Vejeteryan"),
                        value: _changed ? _vegetarian : _filters["vegetarian"],
                        subtitle: Text(
                            "Sadece vejetaryanlar için olan yemekler gösterilir."),
                        onChanged: (newValue) {
                          setState(() {
                            _changed = true;
                            _vegetarian = newValue;
                          });
                        }),
                    SwitchListTile(
                        title: Text("Vegan"),
                        value: _changed ? _vegan : _filters["vegan"],
                        subtitle: Text(
                            "Sadece veganlar için olan yemekler gösterilir."),
                        onChanged: (newValue) {
                          setState(() {
                            _changed = true;
                            _vegan = newValue;
                          });
                        }),
                  ],
                ))
              ],
            ),
    );
  }
}
