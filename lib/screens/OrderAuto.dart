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

  Map<String, bool> lunchCheckboxes = {};
  Map<String, bool> dinnerCheckboxes = {};
  Map<String, int> lunchQuantities = {};
  Map<String, int> dinnerQuantities = {};
  int quantityMin = 1;
  int quantityMax = 9;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.216:8000/api/setting'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orderMaxDays = data['order_max_days'];
        serverDateStr = data['server_date'];
        quantityMin = data['quantity_min'];
        quantityMax = data['quantity_max'];

        // Initialize checkboxes and quantities after fetching data
        _initializeCheckboxes();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchMealTypeAndMarkCheckboxes() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final menuId = args['menuId'];
    final date = args['date'];

    final mealTypeResponse =
        await http.get(Uri.parse('http://192.168.0.216:8000/api/menu/$menuId'));
    if (mealTypeResponse.statusCode == 200) {
      Map<String, dynamic> mealTypeData = jsonDecode(mealTypeResponse.body);
      String mealType = mealTypeData['meal_type'];

      // Pre-mark checkboxes based on the meal type and date
      if (mealType == 'lunch') {
        setState(() {
          lunchCheckboxes[date] = true;
        });
      } else if (mealType == 'dinner') {
        setState(() {
          dinnerCheckboxes[date] = true;
        });
      }
    } else {
      throw Exception('Failed to load meal type data');
    }
  }

  void _initializeCheckboxes() {
    List<Map<String, dynamic>> dateList = _generateDateList();
    dateList.forEach((entry) {
      String date = entry['days'][0]['date'];
      lunchCheckboxes[date] = false;
      dinnerCheckboxes[date] = false;
      lunchQuantities[date] = quantityMin;
      dinnerQuantities[date] = quantityMin;
    });
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
                                      onChanged: (value) {
                                        setState(() {
                                          print(
                                              'Lunch checkbox ${value! ? 'checked' : 'unchecked'}');
                                          lunchCheckboxes[dayEntry['date']] =
                                              value!;
                                          if (!value!) {
                                            print('Lunch checkbox unchecked');
                                          }
                                        });
                                      },
                                    ),
                                    Text('Lunch'),
                                    SizedBox(width: 16),
                                    _buildQuantityCounter(
                                        'lunch', dayEntry['date']!),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value:
                                          dinnerCheckboxes[dayEntry['date']] ??
                                              false,
                                      onChanged: (value) {
                                        setState(() {
                                          print(
                                              'Dinner checkbox ${value! ? 'checked' : 'unchecked'}');
                                          dinnerCheckboxes[dayEntry['date']] =
                                              value!;
                                          if (!value!) {
                                            print('Dinner checkbox unchecked');
                                          }
                                        });
                                      },
                                    ),
                                    Text('Dinner'),
                                    SizedBox(width: 16),
                                    _buildQuantityCounter(
                                        'dinner', dayEntry['date']!),
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
    DateTime endDate = startDate.add(Duration(days: orderMaxDays - 1));

    while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
      String formattedDate = DateFormat('d').format(startDate);
      String suffix = _getDaySuffix(int.parse(formattedDate));
      formattedDate += suffix;
      String dayName = DateFormat('EEE').format(startDate);
      String month = DateFormat('MMMM').format(startDate);

      if (dateList.isEmpty || dateList.last['month'] != month) {
        dateList.add({'month': month, 'days': []});
      }

      dateList.last['days'].add({'date': '$month $formattedDate, $dayName'});

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
