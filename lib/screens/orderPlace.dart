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
        title: "ORDPLACE",
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
      bottomNavigationBar: BottomNav(
        onTabTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // Navigate to the corresponding screen based on the selected index
      switch (selectedIndex) {
        case 0:
          // Navigate to Menu screen
          // Replace 'MenuScreen()' with your actual menu screen class
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
          );
          break;
        case 1:
          // Navigate to My Orders screen
          // Replace 'MyOrdersScreen()' with your actual my orders screen class
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyOrdersScreen()),
          );
          break;
        case 2:
          // Navigate to Notifications screen
          // Replace 'NotificationsScreen()' with your actual notifications screen class
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
          break;
        case 3:
          // Navigate to Profile screen
          // Replace 'ProfileScreen()' with your actual profile screen class
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
          break;
        default:
          break;
      }
    });
  }
}
