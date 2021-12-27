import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/meal_item.dart';

class MealsPage extends StatefulWidget {
  final User user;
  final List<dynamic> userMeals;

  MealsPage(this.user, this.userMeals);

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("meals").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: buildStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          List<Map<String, dynamic>> datas = [];
          List<String> ids = [];
          snapshot.data.docs.forEach((element) {
            if (widget.userMeals.contains(element.id)) {
              ids.add(element.id);
              datas.add(element.data());
            }
          });
          if (datas.length == 0) {
            return Center(child: Text("Henüz bir yemek eklemediniz..."));
          } else {
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
                    "userMeals");
              },
              itemCount: datas.length,
            );
          }
        } else {
          return Center(child: Text("Henüz bir yemek eklemediniz..."));
        }
      },
    );
  }
}
