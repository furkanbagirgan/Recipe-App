import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/category_item.dart';

class CategoryPage extends StatelessWidget {
  final Map<String, dynamic> filters;

  CategoryPage(this.filters);

  Stream<QuerySnapshot> buildStream() {
    return FirebaseFirestore.instance.collection("categories").snapshots();
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
          List<Color> colors = [
            Colors.orange,
            Colors.cyan,
            Colors.purple,
            Colors.green,
            Colors.red,
            Colors.brown,
            Colors.indigo,
            Colors.yellow,
            Colors.pink,
            Colors.teal,
          ];
          snapshot.data.docs.forEach((element) {
            ids.add(element.id);
            datas.add(element.data());
          });
          List<CategoryItem> categories = [];
          for (int i = 0; i < datas.length; i++) {
            categories.add(
                CategoryItem(ids[i], datas[i]["title"], colors[i], filters));
          }
          return GridView(
            padding: const EdgeInsets.all(15),
            children: categories,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
