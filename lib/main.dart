import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/add_meal_page.dart';
import 'pages/category_meals_page.dart';
import 'pages/landing_page.dart';
import 'pages/meal_detail_page.dart';
import 'pages/questions_page.dart';
import 'pages/update_meal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recipe App",
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: "Raleway",
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: "RobotoCondensed",
                  fontWeight: FontWeight.bold))),
      initialRoute: "/",
      routes: {
        "/": (context) => LandingPage(),
        CategoryMealsPage.routeName: (context) => CategoryMealsPage(),
        MealDetailPage.routeName: (context) => MealDetailPage(),
        QuestionsPage.routeName: (context) => QuestionsPage(),
        UpdateMealPage.routeName: (context) => UpdateMealPage(),
        AddMealPage.routeName: (context) => AddMealPage(),
      },
    );
  }
}
