import 'package:flutter/material.dart';
import '../../widgets/bottomNav.dart';
import '../../widgets/appBar.dart';

class OrderPlace extends StatefulWidget {
  final String dataToSend;

  const OrderPlace({Key? key, required this.dataToSend}) : super(key: key);

  @override
  _OrderPlaceState createState() => _OrderPlaceState();
}

class _OrderPlaceState extends State<OrderPlace> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ContentChangerClass ContentChangerState;

  @override
  void initState() {
    super.initState();
    ContentChangerState = ContentChangerClass(onStateChangeCallback: () {
      setState(() {
        // Empty setState callback, just to trigger a rebuild
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarMain(
        contentChangerInst: ContentChangerState,
        title: " ORDPLACE",
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Ordering Tomorrow's Lunch", // Add your title here
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
        ],
      ),
      bottomNavigationBar:
          BottomNav(onTabTapped: ContentChangerState.onItemTapped),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // Handle navigation or content change based on the selected index
    });
  }
}
