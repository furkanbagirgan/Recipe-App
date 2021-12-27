import 'package:flutter/material.dart';

import '../pages/meal_detail_page.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final String complexity;
  final String affordability;
  final double vote;
  final String isComingFrom;

  MealItem(this.id, this.title, this.imageUrl, this.duration, this.complexity,
      this.affordability, this.vote, this.isComingFrom);

  void selectMeal(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(MealDetailPage.routeName, arguments: [id, isComingFrom]);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: FadeInImage.assetNetwork(
                    placeholder: "images/loading.gif",
                    image: imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      color: Colors.black54,
                      width: 330,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("$duration dk")
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(complexity)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(affordability)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("${vote.toStringAsFixed(1)}")
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
