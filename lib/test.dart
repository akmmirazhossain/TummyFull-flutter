// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tummyfull/utils/appTheme.dart';
// import 'package:tummyfull/screens/orderPlace.dart';

// class MenuComp extends StatefulWidget {
//   @override
//   _MenuCompState createState() => _MenuCompState();
// }

// class _MenuCompState extends State<MenuComp> {
//   // Initialize with the current date and time
//   DateTime _dateTime = DateTime.now();

//   // Set the desired refresh hour and minutes
//   int desiredHour = 7;
//   int desiredMinute = 30;

//   // Timer for automatic refresh at the desired time every day
//   late Timer _timer;

//   // Variable to store day of the week and day of the month
//   late String dataToSend;

//   @override
//   void initState() {
//     super.initState();

//     // Calculate the time until the next desired time
//     Duration durationUntilDesiredTime =
//         _nextRefreshTime().difference(_dateTime);

//     // If it's already past the desired time, schedule the next refresh for the next day
//     if (durationUntilDesiredTime.isNegative) {
//       durationUntilDesiredTime += Duration(days: 1);
//     }

//     // Start the timer to refresh at the desired time every day
//     _timer = Timer(durationUntilDesiredTime, () {
//       // Rebuild the widget to refresh the page
//       if (mounted) {
//         setState(() {
//           _dateTime = DateTime.now();
//         });
//       }

//       // Update dataToSend with the new values
//       _updateDataToSend();

//       // Schedule the next refresh for the next day at the desired time
//       _timer = Timer.periodic(Duration(days: 1), (timer) {
//         if (mounted) {
//           setState(() {
//             _dateTime = DateTime.now();
//           });
//         }

//         // Update dataToSend with the new values
//         _updateDataToSend();
//       });
//     });

//     // Initial update of dataToSend
//     _updateDataToSend();
//   }

//   // Update dataToSend with the current values
//   void _updateDataToSend() {
//     // Get the current date and time
//     DateTime now = DateTime.now();

//     // Send "Sun" and "19th" using dataToSend
//     dataToSend = DateFormat('E').format(now); // Day of the week (e.g., "Sun")
//     dataToSend += " " +
//         DateFormat('d').format(now) +
//         getOrdinal(
//             now.day); // Day of the month with ordinal suffix (e.g., "19th")
//   }

//   // Calculate the next refresh time at the desired time
//   DateTime _nextRefreshTime() {
//     DateTime now = DateTime.now();
//     DateTime nextRefresh =
//         DateTime(now.year, now.month, now.day, desiredHour, desiredMinute, 0);

//     // If it's already past the desired time, schedule the next refresh for the next day
//     if (now.isAfter(nextRefresh)) {
//       nextRefresh = nextRefresh.add(Duration(days: 1));
//     }

//     return nextRefresh;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get the current date and time
//     DateTime now = DateTime.now();

//     // Check if the current time is after the desired time
//     bool isAfterDesiredTime = now.hour > desiredHour ||
//         (now.hour == desiredHour && now.minute >= desiredMinute);

//     // If it's after the desired time, add a day to get tomorrow's date
//     if (isAfterDesiredTime) {
//       now = now.add(Duration(days: 1));
//     }

//     // Format the date and add the ordinal suffix to the day
//     String formattedDate = DateFormat('E, d').format(now);
//     formattedDate += getOrdinal(now.day);

//     // Determine the menu text based on the time
//     String menuText = isAfterDesiredTime ? "Tomorrow's Menu" : "Today's Menu";

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           color: surface,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 16.0,
//                 horizontal: 10.0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     menuText,
//                     style: TextStyle(color: onSurface, fontSize: textXl),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(left: 8.0),
//                     padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                     decoration: BoxDecoration(
//                       color: onSurface,
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: Text(
//                       formattedDate,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: textSm,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         Container(
//           width: double.infinity,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     color: surface,
//                     borderRadius: BorderRadius.circular(10.0),
//                     border: Border.all(color: borderColor),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 1,
//                         blurRadius: 7,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Row(
//                           children: [
//                             Flexible(
//                               flex: 42,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 8.0,
//                                   left: 8.0,
//                                   bottom: 8.0,
//                                 ),
//                                 child: Container(
//                                   child: Column(
//                                     children: [
//                                       Image.network(
//                                         'https://i.postimg.cc/HnHKrDW5/rui-1.png',
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       Image.network(
//                                         'https://i.postimg.cc/2ys1QwJ4/pui-bhaji.png',
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Flexible(
//                               flex: 58,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 8.0,
//                                   right: 8.0,
//                                   bottom: 8.0,
//                                 ),
//                                 child: Container(
//                                   child: Image.network(
//                                     'https://i.postimg.cc/vTb8LZtZ/shada-bhaath.png',
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(
//                           top: 2.0,
//                           bottom: 10.0,
//                           left: 10.0,
//                           right: 10.0,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     bottom: 0.0,
//                                   ),
//                                   child: Text(
//                                     'Lunch',
//                                     style: TextStyle(
//                                       color: onSurface,
//                                       fontSize: textLg,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Icon(Icons.delivery_dining,
//                                         size: 17, color: onSurface),
//                                     SizedBox(width: 2),
//                                     Text(
//                                       '1pm - 2:30pm',
//                                       style: TextStyle(
//                                         color: Color.fromARGB(255, 0, 0, 0),
//                                         fontSize: textXs,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 5.0),
//                               child: Text(
//                                 'Rui curry, pui shak, shada bhaath',
//                                 style: TextStyle(
//                                   color: onSurface,
//                                   fontSize: textSm,
//                                 ),
//                               ),
//                             ),
//                             const Text(
//                               '৳90',
//                               style: TextStyle(
//                                 color: onSurface,
//                                 fontSize: textXl,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Center(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Navigate to the OrderPlace and pass the data
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           OrderPlace(dataToSend: dataToSend),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: const Size(120, 40),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                 ),
//                                 child: const Text('Proceed to order'),
//                               ),
//                             ),
//                             const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   '(Accepting order till 6 am)',
//                                   style: TextStyle(
//                                     color: onSurface,
//                                     fontSize: textXs,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // ...
//       ],
//     );
//   }

//   // Function to get the ordinal suffix for the day
//   String getOrdinal(int day) {
//     if (day >= 11 && day <= 13) {
//       return 'th';
//     }
//     switch (day % 10) {
//       case 1:
//         return 'st';
//       case 2:
//         return 'nd';
//       case 3:
//         return 'rd';
//       default:
//         return 'th';
//     }
//   }

//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed
//     _timer.cancel();
//     super.dispose();
//   }
// }
