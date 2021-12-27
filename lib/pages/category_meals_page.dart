import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/meal_item.dart';

class CategoryMealsPage extends StatefulWidget {
  static const String routeName = "/category-meals";

  @override
  _CategoryMealsPageState createState() => _CategoryMealsPageState();
}

class _CategoryMealsPageState extends State<CategoryMealsPage> {
  String _categoryTitle;
  Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance
        .collection("meals")
        .orderBy("vote", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final String _categoryId = args["id"];
    _categoryTitle = args["title"];
    _filters = args["filters"];

    return Scaffold(
        appBar: AppBar(
          title: Text(_categoryTitle),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: buildStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<Map<String, dynamic>> datas = [];
              List<String> ids = [];
              snapshot.data.docs.forEach((element) {
                List<String> categories =
                    List.from(element.data()["categories"]);
                if (categories.contains(_categoryId)) {
                  if (!_filters["glutenFree"] ||
                      element.data()["isGlutenFree"]) {
                    if (!_filters["lactoseFree"] ||
                        element.data()["isLactoseFree"]) {
                      if (!_filters["vegan"] || element.data()["isVegan"]) {
                        if (!_filters["vegetarian"] ||
                            element.data()["isVegetarian"]) {
                          ids.add(element.id);
                          datas.add(element.data());
                        }
                      }
                    }
                  }
                }
              });
              return ListView.builder(
                itemBuilder: (context, index) {
                  return MealItem(
                      ids[index],
                      datas[index]["title"],
                      datas[index]["image"],
                      datas[index]["duration"],
                      datas[index]["complexity"],
                      datas[index]["affordability"],
                      double.parse("${datas[index]["vote"]}"),
                      "categories");
                },
                itemCount: datas.length,
              );
            } else {
              return Center(child: Text("Yemekler Yüklenemedi !"));
            }
          },
        ));
  }
}
