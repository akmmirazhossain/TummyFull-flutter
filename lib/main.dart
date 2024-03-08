// main.dart

import 'package:flutter/material.dart';
import 'package:mealready/utils/appTheme.dart';
import 'package:mealready/widgets/stepperMain.dart';
import 'package:mealready/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/screens/home': (context) => HomePage(),
        // ... other routes
      },
      title: 'TummyFull',
      theme: appTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: MainAppBar(),
      body: Center(
        child: MyStepperWidget(), // Display the horizontal stepper directly
      ),
    );
  }
}
