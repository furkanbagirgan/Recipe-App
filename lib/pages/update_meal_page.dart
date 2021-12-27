import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateMealPage extends StatefulWidget {
  static const String routeName = "/update-meal";

  @override
  _UpdateMealPageState createState() => _UpdateMealPageState();
}

class _UpdateMealPageState extends State<UpdateMealPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _meal;
  File _image;
  bool _changeImage = false;
  String _duration;
  String _complexity;
  String _affordability;
  String _title;
  String _ingredients;
  String _steps;
  String _glutenFree;
  String _lactoseFree;
  String _vegan;
  String _vegetarian;
  List<dynamic> _categories = [];
  String _answer1;
  String _answer2;
  String _answer3;
  String _answer4;
  String _answer5;
  bool _c1;
  bool _c2;
  bool _c3;
  bool _c4;
  bool _c5;
  bool _c6;
  bool _c7;
  bool _c8;
  bool _c9;
  bool _c10;
  bool _isStarting = true;

  void _saveMeal() async {
    String _imageUrl;
    if (_changeImage) {
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("mealImages")
            .child(_meal["id"] + ".png");
        await ref.putFile(_image).whenComplete(() => null);
        _imageUrl = await ref.getDownloadURL();
      } else {
        _imageUrl = _meal["image"];
      }
    } else {
      _imageUrl = _meal["image"];
    }
    String title;
    (_title != null && !_title.isEmpty)
        ? title = _title
        : title = _meal["title"];
    int duration;
    (_duration != null && !_duration.isEmpty)
        ? duration = int.parse(_duration)
        : duration = _meal["duration"];
    String complexity;
    (_complexity != null && !_complexity.isEmpty)
        ? complexity = _complexity
        : complexity = _meal["complexity"];
    String affordability;
    (_affordability != null && !_affordability.isEmpty)
        ? affordability = _affordability
        : affordability = _meal["affordability"];
    List<dynamic> ingredients;
    (_ingredients != null && !_ingredients.isEmpty)
        ? ingredients = _ingredients.split(",")
        : ingredients = _meal["ingredients"];
    List<dynamic> steps;
    (_steps != null && !_steps.isEmpty)
        ? steps = _steps.split(",")
        : steps = _meal["steps"];
    bool glutenFree = _glutenFree == "Evet" ? true : false;
    bool lactoseFree = _lactoseFree == "Evet" ? true : false;
    bool vegan = _vegan == "Evet" ? true : false;
    bool vegetarian = _vegetarian == "Evet" ? true : false;
    List<dynamic> categories = [];
    if (_categories != null && _categories.isNotEmpty) {
      categories = _categories;
    } else {
      categories = _meal["categories"];
    }
    String answer1;
    if (_answer1 != null && _answer1.isNotEmpty) {
      answer1 = _answer1;
    } else {
      answer1 = _meal["answers"][0];
    }
    String answer2;
    if (_answer2 != null && _answer2.isNotEmpty) {
      answer2 = _answer2;
    } else {
      answer2 = _meal["answers"][1];
    }
    String answer3;
    if (_answer3 != null && _answer3.isNotEmpty) {
      answer3 = _answer3;
    } else {
      answer3 = _meal["answers"][2];
    }
    String answer4;
    if (_answer4 != null && _answer4.isNotEmpty) {
      answer4 = _answer4;
    } else {
      answer4 = _meal["answers"][3];
    }
    String answer5;
    if (_answer5 != null && _answer5.isNotEmpty) {
      answer5 = _answer5;
    } else {
      answer5 = _meal["answers"][4];
    }
    List<String> answers = [answer1, answer2, answer3, answer4, answer5];
    await FirebaseFirestore.instance
        .collection("meals")
        .doc(_meal["id"])
        .update({
      "image": _imageUrl,
      "title": title,
      "affordability": affordability,
      "duration": duration,
      "complexity": complexity,
      "ingredients": ingredients,
      "steps": steps,
      "categories": categories,
      "answers": answers,
      "isGlutenFree": glutenFree,
      "isLactoseFree": lactoseFree,
      "isVegan": vegan,
      "isVegetarian": vegetarian,
    });
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
    _meal = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final List<dynamic> ingredients = _meal["ingredients"];
    final List<dynamic> steps = _meal["steps"];
    final List<dynamic> categories = _meal["categories"];
    if (_isStarting) {
      _categories = categories;
      _isStarting = false;
    }
    String _ingredients1 = "";
    for (int i = 0; i < ingredients.length; i++) {
      _ingredients1 += ingredients[i];
      if (i != ingredients.length - 1) {
        _ingredients1 += ",";
      }
    }
    String _steps1 = "";
    for (int i = 0; i < steps.length; i++) {
      _steps1 += steps[i];
      if (i != steps.length - 1) {
        _steps1 += ",";
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Yemeği Düzenle"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _formKey.currentState.save();
                _saveMeal();
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
                  child: _changeImage
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          _meal["image"],
                          fit: BoxFit.cover,
                        ),
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
                            Icons.image_search,
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
                                  hintText: "${_meal["title"]}",
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
                                  hintText: "${_meal["duration"]} dk",
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
                              value: _complexity == null
                                  ? _meal["complexity"]
                                  : _complexity,
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
                              value: _affordability == null
                                  ? _meal["affordability"]
                                  : _affordability,
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
                              value: _glutenFree == null
                                  ? (_meal["isGlutenFree"] == true
                                      ? "Evet"
                                      : "Hayır")
                                  : _glutenFree,
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
                              value: _lactoseFree == null
                                  ? (_meal["isLactoseFree"] == true
                                      ? "Evet"
                                      : "Hayır")
                                  : _lactoseFree,
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
                              value: _vegan == null
                                  ? (_meal["isVegan"] == true
                                      ? "Evet"
                                      : "Hayır")
                                  : _vegan,
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
                              value: _vegetarian == null
                                  ? (_meal["isVegetarian"] == true
                                      ? "Evet"
                                      : "Hayır")
                                  : _vegetarian,
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
                            value: _c1 == null
                                ? (categories.contains("7aZlLOxmIpJLoHScBmH8")
                                    ? true
                                    : false)
                                : _c1,
                            onChanged: (deger) {
                              setState(() {
                                _c1 = deger;
                                if (_c1) {
                                  _categories.add("7aZlLOxmIpJLoHScBmH8");
                                } else {
                                  _categories.remove("7aZlLOxmIpJLoHScBmH8");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Makarnalar"),
                            value: _c2 == null
                                ? (categories.contains("AobRo4ulCVnMdUlPX5es")
                                    ? true
                                    : false)
                                : _c2,
                            onChanged: (deger) {
                              setState(() {
                                _c2 = deger;
                                if (_c2) {
                                  _categories.add("AobRo4ulCVnMdUlPX5es");
                                } else {
                                  _categories.remove("AobRo4ulCVnMdUlPX5es");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Sebze Yemekleri"),
                            value: _c3 == null
                                ? (categories.contains("B5f1VzRbdvCHG9G1q6ry")
                                    ? true
                                    : false)
                                : _c3,
                            onChanged: (deger) {
                              setState(() {
                                _c3 = deger;
                                if (_c3) {
                                  _categories.add("B5f1VzRbdvCHG9G1q6ry");
                                } else {
                                  _categories.remove("B5f1VzRbdvCHG9G1q6ry");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Balık&Deniz Ürünleri"),
                            value: _c4 == null
                                ? (categories.contains("g8fFd5WvCiTWzYBJmtom")
                                    ? true
                                    : false)
                                : _c4,
                            onChanged: (deger) {
                              setState(() {
                                _c4 = deger;
                                if (_c4) {
                                  _categories.add("g8fFd5WvCiTWzYBJmtom");
                                } else {
                                  _categories.remove("g8fFd5WvCiTWzYBJmtom");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Unlu Yemekler"),
                            value: _c5 == null
                                ? (categories.contains("kpaQwE3grayaETg5SJJl")
                                    ? true
                                    : false)
                                : _c5,
                            onChanged: (deger) {
                              setState(() {
                                _c5 = deger;
                                if (_c5) {
                                  _categories.add("kpaQwE3grayaETg5SJJl");
                                } else {
                                  _categories.remove("kpaQwE3grayaETg5SJJl");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Çorbalar"),
                            value: _c6 == null
                                ? (categories.contains("mYybQvQi4h9iTH7meuPY")
                                    ? true
                                    : false)
                                : _c6,
                            onChanged: (deger) {
                              setState(() {
                                _c6 = deger;
                                if (_c6) {
                                  _categories.add("mYybQvQi4h9iTH7meuPY");
                                } else {
                                  _categories.remove("mYybQvQi4h9iTH7meuPY");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Salatalar"),
                            value: _c7 == null
                                ? (categories.contains("p8riLs9t6ZHU1hO5wy48")
                                    ? true
                                    : false)
                                : _c7,
                            onChanged: (deger) {
                              setState(() {
                                _c7 = deger;
                                if (_c7) {
                                  _categories.add("p8riLs9t6ZHU1hO5wy48");
                                } else {
                                  _categories.remove("p8riLs9t6ZHU1hO5wy48");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Pratik&Hızlı Yemekler"),
                            value: _c8 == null
                                ? (categories.contains("sQQBRy4QEsKtWVEDE63Q")
                                    ? true
                                    : false)
                                : _c8,
                            onChanged: (deger) {
                              setState(() {
                                _c8 = deger;
                                if (_c8) {
                                  _categories.add("sQQBRy4QEsKtWVEDE63Q");
                                } else {
                                  _categories.remove("sQQBRy4QEsKtWVEDE63Q");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Pasta&Kek"),
                            value: _c9 == null
                                ? (categories.contains("xbzI951cZ0kkFsI7xPz8")
                                    ? true
                                    : false)
                                : _c9,
                            onChanged: (deger) {
                              setState(() {
                                _c9 = deger;
                                if (_c9) {
                                  _categories.add("xbzI951cZ0kkFsI7xPz8");
                                } else {
                                  _categories.remove("xbzI951cZ0kkFsI7xPz8");
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Tatlılar"),
                            value: _c10 == null
                                ? (categories.contains("xv7hfBvwtuuxVtdykUoM")
                                    ? true
                                    : false)
                                : _c10,
                            onChanged: (deger) {
                              setState(() {
                                _c10 = deger;
                                if (_c10) {
                                  _categories.add("xv7hfBvwtuuxVtdykUoM");
                                } else {
                                  _categories.remove("xv7hfBvwtuuxVtdykUoM");
                                }
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
                                  hintText: _meal["answers"][0],
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
                                  hintText: _meal["answers"][1],
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
                                  hintText: _meal["answers"][2],
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
                                  hintText: _meal["answers"][3],
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
                                  hintText: _meal["answers"][4],
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
                          "Kullanılan Malzemeler  ( , ile ayırınız):",
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
                                  hintText: _ingredients1,
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
                                  hintText: _steps1,
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
