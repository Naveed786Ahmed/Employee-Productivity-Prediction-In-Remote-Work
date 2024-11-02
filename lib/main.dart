import "package:dm_final_project/GuideLines.dart";
import "package:dm_final_project/HomeScreen.dart";
import "package:dm_final_project/PredictionForm.dart";
import "package:dm_final_project/SplashScreen.dart";
import "package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/" : (context) => SplashScreen(),
        "/home" : (context) => HomeScreen(),
        "/PredictionForm" : (context) => PredictionFormPage(),
        "/Guidelines" : (context) => AppGuidelinesPage(),
      },
    );
  }
}
