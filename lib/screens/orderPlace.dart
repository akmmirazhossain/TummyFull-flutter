import 'package:flutter/material.dart';
import '../../utils/content_changer.dart';

import '../../widgets/bottomNav.dart';
import '../../widgets/appBar.dart';
import '../../components/organism/home_menu.dart'; // Assuming this is your menu component

class OrderPlace extends StatefulWidget {
  final String dataToSend;

  const OrderPlace({Key? key, required this.dataToSend}) : super(key: key);

  @override
  _OrderPlaceState createState() => _OrderPlaceState();
}

class _OrderPlaceState extends State<OrderPlace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ContentChangerClass contentChangerState;
  late String appBarTitle;

  @override
  void initState() {
    super.initState();
    contentChangerState = ContentChangerClass(onStateChangeCallback: () {
      setState(() {
        // Empty setState callback, just to trigger a rebuild
      });
    });
    appBarTitle = 'ORDPLACE'; // Set initial title
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarMain(
        // contentChangerInst: contentChangerState,
        title: "Place Order",
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Ordering Tomorrow's Lunch",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Order Data: ${widget.dataToSend}'),
                  // Add specific content for OrderPlace if needed
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // Add spacing between the column and the button
          ElevatedButton(
            onPressed: () {
              // Navigate back to home screen
              Navigator.pushNamed(context, '/screens/home');
            },
            child: Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
