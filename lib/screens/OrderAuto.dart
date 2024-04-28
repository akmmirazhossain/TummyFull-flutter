import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderAuto extends StatefulWidget {
  @override
  _OrderAutoState createState() => _OrderAutoState();
}

class _OrderAutoState extends State<OrderAuto> {
  List<dynamic> menuData = [];
  Map<String, bool> lunchCheckState = {};
  Map<String, bool> dinnerCheckState = {};
  List<Map<String, dynamic>> lunchDataList = [];
  Map<int, int> menuIdIndexMap = {};

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
    fetchData();
    initializeLunchDataList();
  }

  void initializeLunchDataList() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      for (var data in menuData) {
        int menuId = data['menu_id_lunch'];
        Map<String, dynamic> lunchData = {
          'menuId': args['menuId'],
          'checked': args['checked'],
          'daydate': args['daydate'],
          'price': args['price'],
        };
        lunchDataList.add(lunchData);
        menuIdIndexMap[menuId] = lunchDataList.length - 1;
      }
    }
  }

  Future<void> fetchData() async {
    final String apiUrl = 'http://192.168.0.216/tf-lara/public/api/orderauto';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          final Map<String, dynamic> data = json.decode(response.body);
          data.forEach((date, details) {
            menuData.add({
              'date': date,
              'daydate': details['daydate'],
              'lunch': details['lunch']?['items'],
              'menu_id_lunch': details['lunch']['menu_id_lunch'],
              'menu_price_lunch': details['lunch']['menu_price_lunch'],
              'dinner': details['dinner']['items'],
              'menu_id_dinner': details['dinner']['menu_id_dinner'],
              'menu_price_dinner': details['menu_price_dinner'],
            });

            // Initialize checkbox state for each menu item
            lunchCheckState[date] = false;
            dinnerCheckState[date] = false;
          });
        });
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed to this page
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Print the arguments
    // if (args != null) {
    //   print('Arguments: $args');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Menu'),
      ),
      body: ListView.builder(
        itemCount: menuData.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 4), // Adjust vertical spacing here
                child: ListTile(
                  title: Text(
                    menuData[index][
                        'daydate'], // Use null-aware operator to handle null value
                    style: TextStyle(fontSize: 16),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
              ),
              if (menuData[index]['lunch'] !=
                  null) // Check if lunch data is not null
                ListTile(
                  dense: true, // Reduce vertical space
                  contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 0), // Decrease vertical padding
                  title: Row(
                    children: [
                      Checkbox(
                        value: (args != null &&
                                args['menuId'] ==
                                    menuData[index]['menu_id_lunch'] &&
                                args['daydate'] == menuData[index]['daydate'] &&
                                args['mealType'] == 'Lunch' &&
                                args['checked'] == 'yes') ||
                            (menuIdIndexMap.containsKey(
                                    menuData[index]['menu_id_lunch']) &&
                                lunchDataList[menuIdIndexMap[menuData[index]
                                        ['menu_id_lunch']]!]['checked'] ==
                                    'yes'),
                        onChanged: (bool? value) {
                          setState(() {
                            if (args != null) {
                              int menuId = menuData[index]
                                  ['menu_id_lunch']; // Define menuId here
                              args['menuId'] = menuId;
                              args['checked'] = value == true ? 'yes' : 'no';
                              args['daydate'] = menuData[index]['daydate'];
                              args['price'] =
                                  menuData[index]['menu_price_lunch'];

                              // If menu ID exists, update its corresponding entry in lunchDataList
                              if (menuIdIndexMap.containsKey(menuId)) {
                                int dataIndex = menuIdIndexMap[menuId]!;
                                lunchDataList[dataIndex]['checked'] =
                                    args['checked'];
                                lunchDataList[dataIndex]['daydate'] =
                                    args['daydate'];
                              } else {
                                // If menu ID is not present, add it to lunchDataList and update menuIdIndexMap
                                Map<String, dynamic> lunchData = {
                                  'menuId': args['menuId'],
                                  'checked': args['checked'],
                                  'daydate': args['daydate'],
                                  'price': args['price'],
                                };
                                lunchDataList.add(lunchData);
                                menuIdIndexMap[menuId] =
                                    lunchDataList.length - 1;
                              }

                              print('----START----');
                              for (var data in lunchDataList) {
                                print('Menu ID: ${data['menuId']}');
                                print('Checked: ${data['checked']}');
                                print('Day Date: ${data['daydate']}');
                                print('Price: ${data['price']}');
                              }
                              print('xxxxENDxxxx \n');
                            }
                          });
                        },
                      ),

                      SizedBox(width: 4), // Decrease horizontal space
                      Text(
                        'Lunch:',
                        style: TextStyle(fontSize: 14), // Set smaller font size
                      ),
                    ],
                  ),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Menu: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ), // Add spacing between "Menu:" and food names
                        for (int i = 0;
                            i < menuData[index]['lunch'].length;
                            i++)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4), // Decrease horizontal padding
                            child: Text(
                              '${capitalize(menuData[index]['lunch'][i]['food_name'])}${i != menuData[index]['lunch'].length - 1 ? ',' : ''}',
                              style: TextStyle(
                                fontSize: 12, // Set smaller font size
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          menuData[index]['menu_price_lunch'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ListTile(
                dense: true, // Reduce vertical space
                contentPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 4), // Decrease vertical padding
                title: Row(
                  children: [
                    Checkbox(
                      value: args != null &&
                          args['menuId'] == menuData[index]['menu_id_dinner'] &&
                          args['daydate'] == menuData[index]['daydate'] &&
                          args['mealType'] == 'Dinner' &&
                          args['checked'] == 'yes',
                      onChanged: (bool? value) {
                        setState(() {
                          // Check if args is not null before accessing its elements
                          if (args != null) {
                            int menuId = menuData[index]['menu_id_dinner'];
                            args['menuId'] = menuId;
                            args['checked'] = value == true ? 'yes' : 'no';
                            args['daydate'] = menuData[index]['daydate'];
                            args['price'] =
                                menuData[index]['menu_price_dinner'];

                            if (menuIdIndexMap.containsKey(menuId)) {
                              // If menu ID exists in the map, update its corresponding entry in lunchDataList
                              int dataIndex = menuIdIndexMap[menuId]!;
                              lunchDataList[dataIndex]['checked'] =
                                  args['checked'];
                              lunchDataList[dataIndex]['daydate'] =
                                  args['daydate'];
                              lunchDataList[dataIndex]['price'] = args['price'];
                            } else {
                              // If menu ID is not present, add it to lunchDataList and update menuIdIndexMap
                              Map<String, dynamic> lunchData = {
                                'menuId': args['menuId'],
                                'checked': args['checked'],
                                'daydate': args['daydate'],
                                'price': args['price'],
                              };
                              lunchDataList.add(lunchData);
                              menuIdIndexMap[menuId] = lunchDataList.length -
                                  1; // Store the index of the added menu ID
                            }

                            // Print the updated lunchDataList
                            print('----START----');
                            for (var data in lunchDataList) {
                              print('Menu ID: ${data['menuId']}');
                              print('Checked: ${data['checked']}');
                              print('Day Date: ${data['daydate']}');
                              print('Price: ${data['price']}');
                            }
                            print('xxxxENDxxxx \n');
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4), // Decrease horizontal space
                    Text(
                      'Dinner:',
                      style: TextStyle(fontSize: 14), // Set smaller font size
                    ),
                  ],
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Menu: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      for (var item in menuData[index]['dinner'])
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4), // Decrease horizontal padding
                          child: Text(
                            item['food_name'],
                            style: TextStyle(
                                fontSize: 12), // Set smaller font size
                          ),
                        ),
                      Text(
                        menuData[index]['menu_price_dinner'].toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4), // Decrease vertical space between rows
            ],
          );
        },
      ),
    );
  }
}
