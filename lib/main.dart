import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2website/customBoard.dart';
import 'package:project2website/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: routing,
      home: const MyHomePage(),
    );
  }
}

Route routing(RouteSettings settings) {
  switch (settings.name) {
    case '/homePage':
      return PageTransition(
          child: MyHomePage(
            puzzle: settings.arguments,
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;

    case '/userInput':
      return PageTransition(
          child: SudokuBoard(), type: PageTransitionType.rightToLeftWithFade);
      break;
  }
}
