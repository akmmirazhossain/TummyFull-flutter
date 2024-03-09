import 'package:flutter/material.dart';
import '../../widgets/appBar.dart';
import '../../widgets/bottomNav.dart';
import '../../utils/appTheme.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    // Set your default title or get it from some variable

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarMain(
        contentChangerInst: ContentChangerState,
        title: "Home",
      ),
      body: Container(
        color: background,
        child: ContentChangerState.buildCurrentContent(),
      ),
      bottomNavigationBar:
          BottomNav(onTabTapped: ContentChangerState.onItemTapped),
    );
  }
}
