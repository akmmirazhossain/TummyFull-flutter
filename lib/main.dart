// main.dart

import 'package:flutter/material.dart';
import '../../utils/appTheme.dart';
import '../../widgets/stepperMain.dart';
import '../../screens/home.dart';
import '../../screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/screens/home': (context) => HomePage(),
        '/screens/login': (context) => Login(),
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
