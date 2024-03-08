import 'package:flutter/material.dart';

class messagesComp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Messages Component',
          style: TextStyle(color: const Color.fromARGB(255, 235, 221, 221))),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'DemoComponent.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool isComponentVisible = false;

//   void _toggleComponentVisibility() {
//     setState(() {
//       isComponentVisible = !isComponentVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Button and Component Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _toggleComponentVisibility,
//               child: Text('Toggle Component'),
//             ),
//             SizedBox(height: 20),
//             if (isComponentVisible) CustomComponent(),
//           ],
//         ),
//       ),
//     );
//   }
// }
