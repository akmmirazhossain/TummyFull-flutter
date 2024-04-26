import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/appTheme.dart';
import '../../screens/OrderPlace.dart';
import 'dart:async';

class MenuComp extends StatefulWidget {
  @override
  _MenuCompState createState() => _MenuCompState();
}

class _MenuCompState extends State<MenuComp> {
  Map<String, dynamic> data = {};
  Map<String, dynamic> setting = {};

  String deliveryTimeLunch = '';
  String deliveryTimeDinner = '';

  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchSetting();
  }

  Future<void> fetchData() async {
    // Simulating a delay to show loading spinner
    await Future.delayed(Duration(seconds: 1));

    final response =
        await http.get(Uri.parse('http://192.168.0.216/tf-lara/public/api/menu'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        isLoading = false; // Set loading state to false when data is loaded
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchSetting() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.216/tf-lara/public/api/setting'));

    if (response.statusCode == 200) {
      setState(() {
        setting = json.decode(response.body);
        deliveryTimeLunch = setting['delivery_time_lunch'];
        deliveryTimeDinner = setting['delivery_time_dinner'];
      });
    } else {
      throw Exception('Failed to load setting');
    }
  }

  String formatDate(String date) {
    // Placeholder implementation, adjust based on the actual date format
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: data.keys.map((day) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        data[day]['menu_of'],
                        style: TextStyle(color: onSurface, fontSize: textXl),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8.0),
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: onSurface,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              day.substring(0, 1).toUpperCase() +
                                  day.substring(1) +
                                  ', ' +
                                  formatDate(data[day]['date']),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSm,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (data[day]['menu_active_lunch'] == "yes")
                    buildMealList(
                        day, data[day]['lunch'], 'Lunch', deliveryTimeLunch),
                  buildMealList(
                      day, data[day]['dinner'], 'Dinner', deliveryTimeDinner),
                  Divider(),
                ],
              );
            }).toList(),
          );
  }

  buildMealList(
    String day,
    List<dynamic>? meals,
    String mealType,
    String deliveryTime,
  ) {
    if (meals == null || meals.isEmpty) {
      return Text('No meals available');
    }

    // Check if it's the first day
    bool isFirstDay = data.keys.first == day;

    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                border:
                    Border.all(color: const Color.fromARGB(255, 135, 135, 135)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Text(
                          mealType,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            size: 17,
                            color: Colors.black,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '$deliveryTime',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: meals.map<Widget>((meal) {
                        return meal['food_image'].isNotEmpty
                            ? Image.network(
                                'http://192.168.0.216/tf-lara/public/assets/images/${meal['food_image']}',
                                height: 100,
                                width: 100,
                              )
                            : Container();
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: meals.map<Widget>((meal) {
                            return Text(
                              meal['food_name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          }).toList(),
                        ),
                        Text(
                          (mealType == 'Lunch')
                              ? '৳${data[day]['menu_price_lunch']}'
                              : '৳${data[day]['menu_price_dinner']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (meals != null && meals.isNotEmpty) {
                                // Assuming 'meals' is a list, you can access the first meal
                                dynamic selectedMeal = meals[0];

                                // Extract the menu_id from the selected meal
                                int selectedMenuId;
                                if (mealType == 'Lunch') {
                                  selectedMenuId = data[day]['menu_id_lunch'];
                                } else if (mealType == 'Dinner') {
                                  selectedMenuId = data[day]['menu_id_dinner'];
                                } else {
                                  // Handle other meal types or set a default value
                                  selectedMenuId = 0;
                                }

                                // Navigate to the OrderPlace and pass the menu_id
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderPlace(
                                      menuId: selectedMenuId,
                                      menuOf: data[day]['menu_of'],
                                      date: formatDate(data[day]['date']),
                                      mealType: mealType,
                                      day: day.substring(0, 1).toUpperCase() +
                                          day.substring(1) +
                                          '',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text('Proceed to order'),
                          ),
                        ),
                        if (isFirstDay) // Display only for the first day
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                '(Accepting order till ${mealType == 'Lunch' ? setting['time_limit_lunch'] ?? '' : mealType == 'Dinner' ? setting['time_limit_dinner'] ?? '' : ''})',
                                style: TextStyle(
                                  color: onSurface,
                                  fontSize: textXs,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
