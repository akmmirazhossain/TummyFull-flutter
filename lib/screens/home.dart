import 'package:flutter/material.dart';
// import '../../widgets/appBar.dart';
import '../../widgets/bottomNav.dart';
import '../../utils/appTheme.dart';
import '../../utils/content_changer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ContentChangerClass _contentChangerState;
  late String _appBarTitle;

  @override
  void initState() {
    super.initState();
    _contentChangerState = ContentChangerClass(onStateChangeCallback: () {
      setState(() {
        // Empty setState callback, just to trigger a rebuild
      });
    });
    _appBarTitle = 'Menu Initial title'; // Set initial title
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBarMain(
      //   contentChangerInst: _contentChangerState,
      //   title: _appBarTitle,
      // ),
      body: Container(
        color: background,
        child: _contentChangerState.buildCurrentContent(),
      ),
      bottomNavigationBar: BottomNav(
        onTabTapped: (index) {
          setState(() {
            _contentChangerState.onItemTapped(index);
          });
        },
      ),
    );
  }
}
