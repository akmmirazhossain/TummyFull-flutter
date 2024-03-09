// import 'package:flutter/material.dart';
// import 'package:tummyfull/screens/messages.dart';
// import 'package:tummyfull/components/organism/menu.dart';
// import 'package:tummyfull/screens/live.dart';
// import 'package:tummyfull/screens/group.dart';
// import 'package:tummyfull/screens/notifications.dart';
// import 'package:tummyfull/screens/profile.dart';

// class AppBarFunctions {
//   int selectedIndex = 0;
//   VoidCallback onItemTappedCallback;

//   AppBarFunctions({required this.onItemTappedCallback});

//   void onItemTapped(int index) {
//     selectedIndex = index;
//     onItemTappedCallback.call();
//   }

//   void onMessagesIconPressed(BuildContext context) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         transitionDuration: Duration.zero,
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return messagesComp();
//         },
//       ),
//     );
//   }

//   Widget buildCurrentContent() {
//     Widget currentContent = MenuComp();

//     switch (selectedIndex) {
//       case 0:
//         currentContent = SingleChildScrollView(child: MenuComp());
//         break;
//       case 1:
//         currentContent = SingleChildScrollView(child: LiveComponent());
//         break;
//       case 2:
//         currentContent = SingleChildScrollView(child: MyGroupComponent());
//         break;
//       case 3:
//         currentContent = SingleChildScrollView(child: NotificationsComponent());
//         break;
//       case 4:
//         currentContent = SingleChildScrollView(child: ProfileComponent());
//         break;
//     }

//     return currentContent;
//   }
// }
