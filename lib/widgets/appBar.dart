import 'package:flutter/material.dart';
import '../../screens/messages.dart';
import '../../components/organism/home_menu.dart';
import '../../screens/live.dart';
import '../../screens/group.dart';
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

  void onMessagesIconPressed(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) {
          return messagesComp();
        },
      ),
    );
  }

  Widget buildCurrentContent() {
    Widget currentContent = MenuComp();

    switch (selectedIndex) {
      case 0:
        currentContent = MenuComp();
        break;
      case 1:
        currentContent = MyHomePage();
        break;
      case 2:
        currentContent = MyGroupComponent();
        break;
      case 3:
        currentContent = NotificationsComponent();
        break;
      case 4:
        currentContent = ProfileComponent();
        break;
    }

    return currentContent;
  }
}

class AppBarMain extends StatelessWidget implements PreferredSizeWidget {
  final ContentChangerClass contentChangerInst;
  final String title;

  const AppBarMain(
      {Key? key, required this.contentChangerInst, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            contentChangerInst.onMessagesIconPressed(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
