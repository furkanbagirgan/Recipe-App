import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMealPage extends StatefulWidget {
  static const String routeName = "/add-meal";

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  bool _changeImage = false;
  String _duration;
  String _complexity = "Basit";
  String _affordability = "Uygun Fiyatlı";
  String _title;
  String _ingredients;
  String _steps;
  String _glutenFree = "Hayır";
  String _lactoseFree = "Hayır";
  String _vegan = "Hayır";
  String _vegetarian = "Hayır";
  List<String> _categories = [];
  String _answer1;
  String _answer2;
  String _answer3;
  String _answer4;
  String _answer5;
  bool _c1 = false;
  bool _c2 = false;
  bool _c3 = false;
  bool _c4 = false;
  bool _c5 = false;
  bool _c6 = false;
  bool _c7 = false;
  bool _c8 = false;
  bool _c9 = false;
  bool _c10 = false;
  Map<String, dynamic> _datas;

  void _saveMeal(BuildContext ctx) async {
    bool hataVar = false;
    bool glutenFree = _glutenFree == "Evet" ? true : false;
    bool lactoseFree = _lactoseFree == "Evet" ? true : false;
    bool vegan = _vegan == "Evet" ? true : false;
    bool vegetarian = _vegetarian == "Evet" ? true : false;

    List<dynamic> categories = [];
    if (_categories != null && _categories.isNotEmpty) {
      categories = _categories;
    } else {
      hataVar = true;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Yemek için en az bir kategori seçilmeli!"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
    String answer1;
    if (!hataVar) {
      if (_answer1 != null && !_answer1.isEmpty) {
        answer1 = _answer1;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("1.sorunun cevabı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String answer2;
    if (!hataVar) {
      if (_answer2 != null && !_answer2.isEmpty) {
        answer2 = _answer2;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("2.sorunun cevabı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String answer3;
    if (!hataVar) {
      if (_answer3 != null && !_answer3.isEmpty) {
        answer3 = _answer3;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("3.sorunun cevabı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String answer4;
    if (!hataVar) {
      if (_answer4 != null && !_answer4.isEmpty) {
        answer4 = _answer4;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("4.sorunun cevabı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String answer5;
    if (!hataVar) {
      if (_answer5 != null && !_answer5.isEmpty) {
        answer5 = _answer5;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("5.sorunun cevabı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String title;
    if (!hataVar) {
      if (_title != null && !_title.isEmpty) {
        title = _title;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yemek adı girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    int duration;
    if (!hataVar) {
      if (_duration != null && _duration.isNotEmpty) {
        duration = int.parse(_duration);
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yemek süresi girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String complexity;
    if (!hataVar) {
      if (_complexity != null && _complexity.isNotEmpty) {
        complexity = _complexity;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yemek zorluğu girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    String affordability;
    if (!hataVar) {
      if (_affordability != null && _affordability.isNotEmpty) {
        affordability = _affordability;
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yemek maliyeti girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    List<dynamic> ingredients = [];
    if (!hataVar) {
      if (_ingredients != null && _ingredients.isNotEmpty) {
        ingredients = _ingredients.split(",");
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Kullanılan malzemeler girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    List<dynamic> steps = [];
    if (!hataVar) {
      if (_steps != null && _steps.isNotEmpty) {
        steps = _steps.split(",");
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yapılış adımları girilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    if (!hataVar) {
      if (_changeImage) {
        if (_image == null) {
          hataVar = true;
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Yemek için resim seçilmedi!"),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        }
      } else {
        hataVar = true;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Yemek için resim seçilmedi!"),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
    if (!hataVar) {
      List<String> answers = [answer1, answer2, answer3, answer4, answer5];
      DocumentReference df =
          await FirebaseFirestore.instance.collection("meals").add({
        "image": "",
        "title": title,
        "affordability": affordability,
        "duration": duration,
        "complexity": complexity,
        "ingredients": ingredients,
        "steps": steps,
        "addingUser": _datas["id"],
        "isGlutenFree": glutenFree,
        "isLactoseFree": lactoseFree,
        "isVegan": vegan,
        "isVegetarian": vegetarian,
        "vote": 0,
        "voteCount": 0,
        "voteAverage": 0,
        "categories": categories,
        "answers": answers
      });
      String mealId = df.id;
      List<dynamic> meals = _datas["userMeals"];
      meals.add(mealId);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_datas["id"])
          .update({"userMeals": meals});
      String _imageUrl;
      final ref = FirebaseStorage.instance
          .ref()
          .child("mealImages")
          .child(mealId + ".png");
      await ref.putFile(_image).whenComplete(() => null);
      _imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("meals")
          .doc(mealId)
          .update({"image": _imageUrl});
      Navigator.of(ctx).pop();
    }
  }

  void _imagePick() async {
    _changeImage = true;
    final pickedImage = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, maxWidth: 360);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    _datas = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Yemek Ekle"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _formKey.currentState.save();
                _saveMeal(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey,
                  child: _changeImage
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                Container(
                    child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 25,
                        child: GestureDetector(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 36,
                          ),
                          onTap: _imagePick,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Yemek Adı:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            width: 225,
                            height: 50,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 18, left: 10),
                                  hintText: "Yemek Adı",
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _title = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Yemek Süresi (dk):",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 18),
                                  prefixIcon: Icon(Icons.schedule),
                                  hintText: "dk",
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _duration = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Yemek Zorluğu:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Basit"),
                                  value: "Basit",
                                ),
                                DropdownMenuItem(
                                  child: Text("Orta"),
                                  value: "Orta",
                                ),
                                DropdownMenuItem(
                                  child: Text("Zor"),
                                  value: "Zor",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _complexity = secilenDeger;
                                });
                              },
                              value: _complexity,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Yemek Maliyeti:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 120,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Uygun Fiyatlı"),
                                  value: "Uygun Fiyatlı",
                                ),
                                DropdownMenuItem(
                                  child: Text("Pahalı"),
                                  value: "Pahalı",
                                ),
                                DropdownMenuItem(
                                  child: Text("Lüks"),
                                  value: "Lüks",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _affordability = secilenDeger;
                                });
                              },
                              value: _affordability,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Glutensiz mi ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Evet"),
                                  value: "Evet",
                                ),
                                DropdownMenuItem(
                                  child: Text("Hayır"),
                                  value: "Hayır",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _glutenFree = secilenDeger;
                                });
                              },
                              value: _glutenFree,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Laktozsuz mu ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Evet"),
                                  value: "Evet",
                                ),
                                DropdownMenuItem(
                                  child: Text("Hayır"),
                                  value: "Hayır",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _lactoseFree = secilenDeger;
                                });
                              },
                              value: _lactoseFree,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Veganlara Yönelik mi ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Evet"),
                                  value: "Evet",
                                ),
                                DropdownMenuItem(
                                  child: Text("Hayır"),
                                  value: "Hayır",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _vegan = secilenDeger;
                                });
                              },
                              value: _vegan,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Vejeteryanlara Yönelik mi ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 93,
                            height: 50,
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text("Evet"),
                                  value: "Evet",
                                ),
                                DropdownMenuItem(
                                  child: Text("Hayır"),
                                  value: "Hayır",
                                ),
                              ],
                              onChanged: (secilenDeger) {
                                setState(() {
                                  _vegetarian = secilenDeger;
                                });
                              },
                              value: _vegetarian,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          "Kategoriler",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(children: [
                          CheckboxListTile(
                            title: Text("Etli Yemekler"),
                            value: _c1 == null ? false : _c1,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("7aZlLOxmIpJLoHScBmH8");
                                } else {
                                  _categories.remove("7aZlLOxmIpJLoHScBmH8");
                                }
                                _c1 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Makarnalar"),
                            value: _c2 == null ? false : _c2,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("AobRo4ulCVnMdUlPX5es");
                                } else {
                                  _categories.remove("AobRo4ulCVnMdUlPX5es");
                                }
                                _c2 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Sebze Yemekleri"),
                            value: _c3 == null ? false : _c3,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("B5f1VzRbdvCHG9G1q6ry");
                                } else {
                                  _categories.remove("B5f1VzRbdvCHG9G1q6ry");
                                }
                                _c3 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Balık&Deniz Ürünleri"),
                            value: _c4 == null ? false : _c4,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("g8fFd5WvCiTWzYBJmtom");
                                } else {
                                  _categories.remove("g8fFd5WvCiTWzYBJmtom");
                                }
                                _c4 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Unlu Yemekler"),
                            value: _c5 == null ? false : _c5,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("kpaQwE3grayaETg5SJJl");
                                } else {
                                  _categories.remove("kpaQwE3grayaETg5SJJl");
                                }
                                _c5 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Çorbalar"),
                            value: _c6 == null ? false : _c6,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("mYybQvQi4h9iTH7meuPY");
                                } else {
                                  _categories.remove("mYybQvQi4h9iTH7meuPY");
                                }
                                _c6 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Salatalar"),
                            value: _c7 == null ? false : _c7,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("p8riLs9t6ZHU1hO5wy48");
                                } else {
                                  _categories.remove("p8riLs9t6ZHU1hO5wy48");
                                }
                                _c7 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Pratik&Hızlı Yemekler"),
                            value: _c8 == null ? false : _c8,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("sQQBRy4QEsKtWVEDE63Q");
                                } else {
                                  _categories.remove("sQQBRy4QEsKtWVEDE63Q");
                                }
                                _c8 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Pasta&Kek"),
                            value: _c9 == null ? false : _c9,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("xbzI951cZ0kkFsI7xPz8");
                                } else {
                                  _categories.remove("xbzI951cZ0kkFsI7xPz8");
                                }
                                _c9 = deger;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Tatlılar"),
                            value: _c10 == null ? false : _c10,
                            onChanged: (deger) {
                              setState(() {
                                if (deger) {
                                  _categories.add("xv7hfBvwtuuxVtdykUoM");
                                } else {
                                  _categories.remove("xv7hfBvwtuuxVtdykUoM");
                                }
                                _c10 = deger;
                              });
                            },
                          ),
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          "Kullanılan malzemeler yerine farklı malzemeler kullanabilirmiyim ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Cevap",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _answer1 = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Ek olarak ekleyebileceğim malzemeler varmı ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Cevap",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _answer2 = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Farklı sıcaklık seçeneklerini kullanabilirmiyim ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Cevap",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _answer3 = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Kullanılan malzemelerin miktarları değişebilirmi ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Cevap",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _answer4 = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Yemeği yaparken hangi mutfak aletlerini kullanabilirim ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Cevap",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _answer5 = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Kullanılan Malzemeler ( , ile ayırınız):",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 120,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10),
                                  hintText: "Kullanılan Malzemeler  ( , ile ayırınız)",
                                  hintMaxLines: 20,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _ingredients = girilenDeger;
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          "Yapılış Adımları ( , ile ayırınız):",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 320,
                            height: 200,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 28, left: 10),
                                  hintText: "Yapılış Adımları  ( , ile ayırınız)",
                                  hintMaxLines: 50,
                                  border: OutlineInputBorder()),
                              onSaved: (girilenDeger) {
                                _steps = girilenDeger;
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
