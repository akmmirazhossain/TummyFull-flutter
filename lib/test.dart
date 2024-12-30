// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter WebView Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Page"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text("Open Webpage"),
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (BuildContext context) => MyWebView(
//                 title: "DigitalOcean",
//                 selectedUrl: "https://www.digitalocean.com",
//               ),
//             ));
//           },
//         ),
//       ),
//     );
//   }
// }

// class MyWebView extends StatelessWidget {
//   final String title;
//   final String selectedUrl;

//   MyWebView({
//     required this.title,
//     required this.selectedUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: WebView(
//         initialUrl: selectedUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
