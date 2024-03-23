import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkbox Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CheckboxPage(), // Use 'const' keyword here
    );
  }
}

class CheckboxPage extends StatefulWidget {
  const CheckboxPage(); // Use 'const' keyword here

  @override
  _CheckboxPageState createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkbox Example'),
      ),
      body: Center(
        child: CheckboxListTile(
          title: Text('Check me'),
          value: isChecked,
          onChanged: (value) {
            // Remove the explicit type annotation to match the expected signature
            setState(() {
              isChecked =
                  value ?? false; // Ensure to handle the null case if needed
            });
            print('Checkbox is now $value');
          },
        ),
      ),
    );
  }
}
