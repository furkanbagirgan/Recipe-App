import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'questions_page.dart';
import 'update_meal_page.dart';

class MealDetailPage extends StatefulWidget {
  static const String routeName = "/meal-detail";

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color _vote1Color = Colors.white;
  Color _vote2Color = Colors.white;
  Color _vote3Color = Colors.white;
  Color _vote4Color = Colors.white;
  Color _vote5Color = Colors.white;
  int _selectedVote = 0;
  String _userId = "";
  Map<String, dynamic> _selectedMeal;
  List<dynamic> _favorites;
  Map<String, dynamic> _votes;
  List<dynamic> _userMeals;
  String _mealId;
  String _isComingFrom;
  bool _isFavorite = false;
  bool _isStarting = true;
  double vote = 0;
  double voteAverage = 0;
  int voteCount = 0;
  String _nameSurname = "";
  String _imageUrl = "";

  void _toggleFavorite(String mealId) async {
    if (_isFavorite) {
      if (_favorites != null) {
        _favorites.add(_mealId);
      } else {
        _favorites = [];
        _favorites.add(_mealId);
      }
    } else {
      if (_favorites != null) {
        _favorites.remove(_mealId);
      } else {
        _favorites = [];
      }
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"favorites": _favorites});
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buildContainer(Widget child, double height) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      height: height,
      child: child,
    );
  }

  Widget _buildRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
        ),
        SizedBox(
          width: 6,
        ),
        Text(title)
      ],
    );
  }

  Widget _buildVote(int vote, Color color) {
    return GestureDetector(
        onTap: () => _voteSelected(vote),
        child: Card(
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.star, size: 25, color: Theme.of(context).accentColor),
              Icon(vote > 1 ? Icons.star : Icons.star_outline,
                  size: 25, color: Theme.of(context).accentColor),
              Icon(vote > 2 ? Icons.star : Icons.star_outline,
                  size: 25, color: Theme.of(context).accentColor),
              Icon(vote > 3 ? Icons.star : Icons.star_outline,
                  size: 25, color: Theme.of(context).accentColor),
              Icon(vote > 4 ? Icons.star : Icons.star_outline,
                  size: 25, color: Theme.of(context).accentColor),
            ],
          ),
        ));
  }

  void _useVote(BuildContext ctx) async {
    if (_selectedVote != 0) {
      if (_votes != null) {
        _votes[_mealId] = _selectedVote;
      } else {
        _votes = Map<String, dynamic>();
        _votes[_mealId] = _selectedVote;
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({"votes": _votes});
      vote = double.parse("${_selectedMeal["vote"]}");
      voteAverage = double.parse("${_selectedMeal["voteAverage"]}");
      voteCount = _selectedMeal["voteCount"];
      voteAverage += _selectedVote;
      voteCount++;
      vote = double.parse((voteAverage / voteCount).toStringAsFixed(1));
      await FirebaseFirestore.instance.collection("meals").doc(_mealId).update(
          {"vote": vote, "voteAverage": voteAverage, "voteCount": voteCount});
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Oy kullanmak için yıldız seçilmelidir!"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  void _deleteVote(BuildContext ctx) async {
    if (_selectedVote != 0) {
      if (_votes != null) {
        if (_votes.containsKey(_mealId)) {
          _votes.remove(_mealId);
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .update({"votes": _votes});
          vote = double.parse("${_selectedMeal["vote"]}");
          voteAverage = double.parse("${_selectedMeal["voteAverage"]}");
          voteCount = _selectedMeal["voteCount"];
          voteAverage -= _selectedVote;
          voteCount -= 1;
          vote = double.parse((voteAverage / voteCount).toStringAsFixed(1));
          await FirebaseFirestore.instance
              .collection("meals")
              .doc(_mealId)
              .update({
            "vote": vote,
            "voteAverage": voteAverage,
            "voteCount": voteCount
          });
        }
      }
      _selectedVote = 0;
      setState(() {
        _vote1Color = Colors.white;
        _vote2Color = Colors.white;
        _vote3Color = Colors.white;
        _vote4Color = Colors.white;
        _vote5Color = Colors.white;
      });
    }
  }

  void _voteSelected(int card) {
    _selectedVote = card;
    switch (card) {
      case 1:
        setState(() {
          _vote1Color = Colors.black12;
          _vote2Color = Colors.white;
          _vote3Color = Colors.white;
          _vote4Color = Colors.white;
          _vote5Color = Colors.white;
        });
        break;
      case 2:
        setState(() {
          _vote1Color = Colors.white;
          _vote2Color = Colors.black12;
          _vote3Color = Colors.white;
          _vote4Color = Colors.white;
          _vote5Color = Colors.white;
        });
        break;
      case 3:
        setState(() {
          _vote1Color = Colors.white;
          _vote2Color = Colors.white;
          _vote3Color = Colors.black12;
          _vote4Color = Colors.white;
          _vote5Color = Colors.white;
        });
        break;
      case 4:
        setState(() {
          _vote1Color = Colors.white;
          _vote2Color = Colors.white;
          _vote3Color = Colors.white;
          _vote4Color = Colors.black12;
          _vote5Color = Colors.white;
        });
        break;
      case 5:
        setState(() {
          _vote1Color = Colors.white;
          _vote2Color = Colors.white;
          _vote3Color = Colors.white;
          _vote4Color = Colors.white;
          _vote5Color = Colors.black12;
        });
        break;
    }
  }

  void _deleteMeal(String mealId) async {
    _userMeals.remove(mealId);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"userMeals": _userMeals});
    await FirebaseFirestore.instance.collection("meals").doc(mealId).delete();
    final ref = FirebaseStorage.instance
        .ref()
        .child("mealImages")
        .child(mealId + ".png");
    await ref.delete();
    Navigator.of(context).pop();
  }

  void _duzenle(BuildContext ctx) {
    refreshState() {
      setState(() {
        _isStarting = true;
      });
    }

    Navigator.of(ctx)
        .pushNamed(UpdateMealPage.routeName, arguments: _selectedMeal)
        .then((res) => refreshState());
  }

  void _soruSor(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(QuestionsPage.routeName, arguments: _selectedMeal);
  }

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("meals").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> args =
        ModalRoute.of(context).settings.arguments as List<String>;
    _mealId = args[0];
    _isComingFrom = args[1];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Yemek Detayı"),
        actions: [
          ((_isComingFrom != "userMeals") &&
                  (_userId != FirebaseAuth.instance.currentUser.uid))
              ? TextButton(
                  onPressed: () => _soruSor(context),
                  child: Text(
                    "Soru Sor",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () => _duzenle(context),
                  child: Text(
                    "Düzenle",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
        ],
      ),
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
                    if (element.id == _mealId) {
                      _selectedMeal = element.data();
                      _selectedMeal["id"] = element.id;
                      _userId = _selectedMeal["addingUser"];
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_userId)
                          .get()
                          .then((value) {
                        _imageUrl = value.data()["image"];
                        _nameSurname = value.data()["name"] +
                            " " +
                            value.data()["surname"];
                      });
                      await FirebaseFirestore.instance
                          .collection("users")
                          .where("email",
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser.email)
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          _favorites = element.data()["favorites"];
                          _votes = element.data()["votes"];
                          _userMeals = element.data()["userMeals"];
                          if (_isFavorite != null &&
                              _favorites.contains(_mealId)) {
                            if (_votes != null && _votes.containsKey(_mealId)) {
                              _selectedVote = _votes[_mealId];
                              switch (_selectedVote) {
                                case 1:
                                  _vote1Color = Colors.black12;
                                  break;
                                case 2:
                                  _vote2Color = Colors.black12;
                                  break;
                                case 3:
                                  _vote3Color = Colors.black12;
                                  break;
                                case 4:
                                  _vote4Color = Colors.black12;
                                  break;
                                case 5:
                                  _vote5Color = Colors.black12;
                                  break;
                              }
                            }
                            setState(() {
                              _isFavorite = true;
                              _isStarting = false;
                            });
                          } else {
                            if (_votes != null && _votes.containsKey(_mealId)) {
                              _selectedVote = _votes[_mealId];
                              switch (_selectedVote) {
                                case 1:
                                  _vote1Color = Colors.black12;
                                  break;
                                case 2:
                                  _vote2Color = Colors.black12;
                                  break;
                                case 3:
                                  _vote3Color = Colors.black12;
                                  break;
                                case 4:
                                  _vote4Color = Colors.black12;
                                  break;
                                case 5:
                                  _vote5Color = Colors.black12;
                                  break;
                              }
                            }
                            setState(() {
                              _isFavorite = false;
                              _isStarting = false;
                            });
                          }
                        });
                      });
                    }
                  });
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(child: Text("Yemek Yüklenemedi !"));
                }
              },
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.network(
                          _selectedMeal["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          right: 10,
                          child: Container(
                            color: Colors.black54,
                            width: 350,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              _selectedMeal["title"],
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Icon(
                            Icons.account_circle,
                            size: ((_imageUrl == null || _imageUrl.isEmpty)
                                ? 37
                                : 0),
                          ),
                          backgroundImage:
                              ((_imageUrl == null || _imageUrl.isEmpty)
                                  ? null
                                  : NetworkImage(_imageUrl)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_nameSurname),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRow(
                            Icons.schedule, "${_selectedMeal["duration"]} dk"),
                        _buildRow(
                            Icons.work_outline, _selectedMeal["complexity"]),
                        _buildRow(Icons.account_balance_wallet_outlined,
                            _selectedMeal["affordability"]),
                        _buildRow(Icons.star_outline,
                            "${_selectedMeal["vote"].toStringAsFixed(1)}"),
                      ],
                    ),
                  ),
                  _buildSectionTitle(context, "Kullanılacak Malzemeler"),
                  _buildContainer(
                      ListView.builder(
                          itemCount: _selectedMeal["ingredients"].length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              color: Theme.of(context).accentColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child:
                                    Text(_selectedMeal["ingredients"][index]),
                              ),
                            );
                          }),
                      150),
                  _buildSectionTitle(context, "Yapılış Adımları"),
                  _buildContainer(
                      ListView.builder(
                          itemCount: _selectedMeal["steps"].length,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    child: Text("${(index + 1)}"),
                                  ),
                                  title: Text(_selectedMeal["steps"][index]),
                                ),
                                if (index !=
                                    (_selectedMeal["steps"].length - 1))
                                  Divider(
                                    height: 10,
                                    thickness: 1,
                                    color: Colors.black38,
                                  ),
                              ],
                            );
                          }),
                      300),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ((_isComingFrom != "userMeals") &&
                                (_userId !=
                                    FirebaseAuth.instance.currentUser.uid))
                            ? 30
                            : 10),
                    height: 165,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          ((_isComingFrom != "userMeals") &&
                                  (_userId !=
                                      FirebaseAuth.instance.currentUser.uid))
                              ? Padding(
                                  padding: EdgeInsets.only(left: 20, bottom: 5),
                                  child: Text("Değerlendir :",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6))
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          Icon(Icons.star,
                              size: 100, color: Theme.of(context).accentColor),
                          Text("${_selectedMeal["vote"].toStringAsFixed(1)}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).accentColor))
                        ]),
                        SizedBox(
                          height: 0,
                          width: ((_isComingFrom != "userMeals") &&
                                  (_userId !=
                                      FirebaseAuth.instance.currentUser.uid))
                              ? 30
                              : 0,
                        ),
                        ((_isComingFrom != "userMeals") &&
                                (_userId !=
                                    FirebaseAuth.instance.currentUser.uid))
                            ? Container(
                                width: 150,
                                height: 165,
                                child: Column(children: [
                                  _buildVote(5, _vote5Color),
                                  _buildVote(4, _vote4Color),
                                  _buildVote(3, _vote3Color),
                                  _buildVote(2, _vote2Color),
                                  _buildVote(1, _vote1Color),
                                ]))
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                  ((_isComingFrom != "userMeals") &&
                          (_userId != FirebaseAuth.instance.currentUser.uid))
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () => _useVote(context),
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Oyla",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                onPressed: () => _deleteVote(context),
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Oyu Sil",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )))
                      : SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
      floatingActionButton: ((_isComingFrom != "userMeals") &&
              (_userId != FirebaseAuth.instance.currentUser.uid))
          ? FloatingActionButton(
              child: Icon(
                  _isFavorite ? Icons.assistant : Icons.assistant_outlined),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                  _toggleFavorite(_mealId);
                });
              },
            )
          : ((_isComingFrom == "userMeals") &&
                  (_userId == FirebaseAuth.instance.currentUser.uid))
              ? FloatingActionButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    _deleteMeal(_mealId);
                  },
                )
              : null,
    );
  }
}
