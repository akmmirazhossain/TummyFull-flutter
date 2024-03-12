import 'dart:async';
import 'package:flutter/material.dart';

import '../../components/organism/home_menu.dart';
import '../../screens/notifications.dart';
import '../../screens/profile.dart';

class ContentChangerClass {
  int selectedIndex = 0;
  VoidCallback onStateChangeCallback;

  ContentChangerClass({required this.onStateChangeCallback});

  void onItemTapped(int index) {
    selectedIndex = index;
    onStateChangeCallback.call();
  }

  Widget buildCurrentContent() {
    Widget currentContent = MenuComp();

    switch (selectedIndex) {
      case 0:
        currentContent = MenuComp();
        break;
      case 1:
        currentContent = NotificationsComponent();
        break;
      case 2:
        currentContent = NotificationsComponent();
        break;
      case 3:
        currentContent = ProfileComponent();
        break;
    }

    return currentContent;
  }

  String getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'MenuAppBar';
      case 1:
        return 'My Orders';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return 'Home';
    }
  }
}
