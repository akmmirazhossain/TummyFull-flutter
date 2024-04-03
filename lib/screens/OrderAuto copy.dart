import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderAuto extends StatefulWidget {
  @override
  _OrderAutoState createState() => _OrderAutoState();
}

class _OrderAutoState extends State<OrderAuto> {
  int orderMaxDays = 0;
  String serverDateStr = '';
  String serverTime24h = '';
  String serverDateOrderAuto = '';
  String timeLimitLunch24h = '';
  String timeLimitDinner24h = '';
  bool isLunchCheckboxEnabled = true;

  Map<String, bool> lunchCheckboxes = {};
  Map<String, bool> dinnerCheckboxes = {};
  Map<String, int> lunchQuantities = {};
  Map<String, int> dinnerQuantities = {};
  int quantityMin = 1;
  int quantityMax = 9;

  bool _isFirstDate(String date) {
    // Get the first date from the generated date list
    String firstDate = _generateDateList().first['days'].first['date'];

    // Print statements for debugging
    print('FIRST DATE: $firstDate');
    print('JUST DATE: $date');

    // Check if the given date matches the first date
    return date == firstDate;
  }

  // bool _isToday(String dateString) {
  //   // Get the current date
  //   DateTime currentDate = DateTime.now();

  //   // Parse the date string from the API
  //   DateTime dateFromAPI = DateFormat('dd-MMM-yyyy').parse(dateString);

  //   print('_isToday: $dateFromAPI');
  //   // Check if the parsed date is the same as the current date
  //   return dateFromAPI.year == currentDate.year &&
  //       dateFromAPI.month == currentDate.month &&
  //       dateFromAPI.day == currentDate.day;
  // }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.216:8000/api/setting'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orderMaxDays = data['order_max_days'];
        serverDateStr = data['server_date'];
        serverTime24h = data['server_time_24h'];
        serverDateOrderAuto = data['serverDateOrderAuto'];
        quantityMin = data['quantity_min'];
        quantityMax = data['quantity_max'];
        timeLimitLunch24h = data['time_limit_lunch_24h'];
        timeLimitDinner24h = data['time_limit_dinner_24h'];

        // Print the values for debugging
        print('timeLimitLunch24h: $timeLimitLunch24h');
        print('serverTime24h: $serverTime24h');
        print('serverDateStr: $serverDateStr');

        // Compare timeLimitLunch24h and serverTime24h
        // if (timeLimitLunch24h.compareTo(serverTime24h) < 0) {
        //   // Hide the lunch checkbox
        //   isLunchCheckboxEnabled = false;
        //   print('Hiding lunch checkbox');
        // } else {
        //   // Show the lunch checkbox
        //   isLunchCheckboxEnabled = true;
        //   print('Showing lunch checkbox');
        // }

        // Check if the condition for disabling the lunch checkbox is met
        // if (isLunchCheckboxEnabled &&
        //     timeLimitLunch24h.compareTo(serverTime24h) < 0 &&
        //     _isToday(serverDateStr) &&
        //     _isFirstDate(_generateDateList()[0]['days'][0]['date'])) {
        //   print('Condition for disabling lunch checkbox is met');
        //   isLunchCheckboxEnabled = false;
        // }

        print('LINE 36 timeLimitLunch: $timeLimitLunch24h');
        print('LINE 37 timeLimitDinner: $timeLimitDinner24h');
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchMealTypeAndMarkCheckboxes() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final dayDate = args['daydate'] as String;
    print('Day Date: $dayDate'); // Add this line to print dayDate
    final mealType = args['mealType'] as String;
    print('Meal type: $mealType');

    final menuId = args['menuId'] as int;
    print('menuId: $menuId');

    // Pre-mark the checkbox for the specified day and meal type
    if (mealType == 'Lunch') {
      setState(() {
        lunchCheckboxes[dayDate] = true;
      });
    } else if (mealType == 'Dinner') {
      setState(() {
        dinnerCheckboxes[dayDate] = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchMealTypeAndMarkCheckboxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Meals'),
      ),
      body: orderMaxDays == 0 || serverDateStr.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _generateDateList().length,
              itemBuilder: (context, index) {
                final entry = _generateDateList()[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry['month']!,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var dayEntry in entry['days']!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(dayEntry['date']!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value:
                                          lunchCheckboxes[dayEntry['date']] ??
                                              false,
                                      onChanged: (timeLimitLunch24h.compareTo(
                                                      serverTime24h) <
                                                  0 &&
                                              _isFirstDate(dayEntry[
                                                  'date'])) // Check if it's the first date
                                          ? null // Disable the checkbox
                                          : (value) {
                                              setState(() {
                                                print(
                                                    'Lunch checkbox for ${dayEntry['date']} ${value! ? 'checked' : 'unchecked'}');
                                                lunchCheckboxes[
                                                    dayEntry['date']] = value!;
                                                if (!value!) {
                                                  print(
                                                      'Lunch checkbox for ${dayEntry['date']} unchecked');
                                                }
                                              });
                                            },
                                    ),
                                    Text('Lunch'),
                                    SizedBox(width: 16),
                                    // _buildQuantityCounter(
                                    //     'lunch', dayEntry['date']!),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value:
                                          dinnerCheckboxes[dayEntry['date']] ??
                                              false,
                                      onChanged:
                                          (_isFirstDate(dayEntry['date']) &&
                                                  timeLimitDinner24h.compareTo(
                                                          serverTime24h) <
                                                      0)
                                              ? null // Disable the checkbox
                                              : (value) {
                                                  setState(() {
                                                    print(
                                                        'Dinner checkbox for ${dayEntry['date']} ${value! ? 'checked' : 'unchecked'}');
                                                    dinnerCheckboxes[
                                                            dayEntry['date']] =
                                                        value!;
                                                    if (!value!) {
                                                      print(
                                                          'Dinner checkbox for ${dayEntry['date']} unchecked');
                                                    }
                                                  });
                                                },
                                    ),
                                    Text('Dinner'),
                                    SizedBox(width: 16),
                                    // _buildQuantityCounter(
                                    //     'dinner', dayEntry['date']!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildQuantityCounter(String mealType, String date) {
    int currentQuantity = mealType == 'lunch'
        ? lunchQuantities[date] ?? quantityMin
        : dinnerQuantities[date] ?? quantityMin;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (currentQuantity > quantityMin) {
                if (mealType == 'lunch') {
                  lunchQuantities[date] = currentQuantity - 1;
                } else {
                  dinnerQuantities[date] = currentQuantity - 1;
                }
              }
            });
          },
        ),
        Text('Quantity: $currentQuantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (currentQuantity < quantityMax) {
                if (mealType == 'lunch') {
                  lunchQuantities[date] = currentQuantity + 1;
                } else {
                  dinnerQuantities[date] = currentQuantity + 1;
                }
              }
            });
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _generateDateList() {
    List<Map<String, dynamic>> dateList = [];
    DateTime startDate = DateFormat('dd-MMM-yyyy').parse(serverDateStr);
    //print('LINE 220 startDate: $startDate');
    DateTime endDate = startDate.add(Duration(days: orderMaxDays - 1));

    while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
      String formattedDate = DateFormat('EEE, d').format(startDate);

      String suffix =
          _getDaySuffix(int.parse(DateFormat('d').format(startDate)));
      formattedDate += suffix;
      String month = DateFormat('MMM').format(startDate);

      if (dateList.isEmpty || dateList.last['month'] != month) {
        dateList.add({'month': month, 'days': []});
      }

      dateList.last['days'].add({'date': '$formattedDate $month'});

      startDate = startDate.add(Duration(days: 1));
    }

    return dateList;
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: OrderAuto(),
  ));
}
