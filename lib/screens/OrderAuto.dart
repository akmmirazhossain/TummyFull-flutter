import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class OrderAuto extends StatefulWidget {
  @override
  _OrderAutoState createState() => _OrderAutoState();
}

class _OrderAutoState extends State<OrderAuto> {
  List<dynamic> menuData = [];
  Map<String, bool> lunchCheckState = {};
  Map<String, bool> dinnerCheckState = {};
  List<Map<String, dynamic>> mealDataList = [];
  Map<int, int> menuIdIndexMap = {};

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
    fetchData();
    // initializeLunchDataList();
  }

  // void initializeLunchDataList() {
  //   final Map<String, dynamic>? args =
  //       ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

  //   if (args != null) {
  //     for (var data in menuData) {
  //       int menuId = data['menu_id_lunch'];
  //       Map<String, dynamic> lunchData = {
  //         'menuId': args['menuId'],
  //         'checked': args['checked'],
  //         'daydate': args['daydate'],
  //         'price': args['price'],
  //       };
  //       lunchDataList.add(lunchData);
  //       menuIdIndexMap[menuId] = lunchDataList.length - 1;
  //     }
  //   }
  // }

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
                          value: ((args != null &&
                                          //IF MATCHES WITH THE ARGS DATA
                                          args['checked'] == 'yes') &&
                                      args['mealType'] == 'Lunch' &&
                                      args['daydate'] ==
                                          menuData[index]['daydate'] ||

                                  //CHECK IF THE DATA IS PRESENT IN THE LUNCH DATA LIST
                                  mealDataList.any((data) =>
                                      data['checked'] == 'yes' &&
                                      data['mealType'] == 'Lunch' &&
                                      data['daydate'] ==
                                          menuData[index]['daydate']))
                              ? (() {
                                  //ADD UP THE ARGS DATA FROM THE PREVIOUS PAGE
                                  if (args != null) {
                                    String daydate = args['daydate'];
                                    int menuId = args['menuId'];
                                    bool dataExists = mealDataList.any((data) =>
                                        data['checked'] == 'yes' &&
                                        data['mealType'] == 'Lunch' &&
                                        data['daydate'] == daydate);

                                    if (!dataExists) {
                                      // Create the meal data map
                                      Map<String, dynamic> mealData = {
                                        'menuId': menuId,
                                        'mealType': 'Lunch',
                                        'daydate': daydate,
                                        'price': args['price'],
                                      };

                                      // Add the new meal data to mealDataList
                                      mealDataList.add(mealData);

                                      // Print the added meal data
                                      print(
                                          '1) CHECKBOX - New meal data added:');
                                      print(mealData);
                                    }
                                  }

                                  return true;
                                })()
                              : false,
                          onChanged: (bool? value) {
                            setState(() {
                              if (args != null) {
                                // Assign variables
                                int menuId = menuData[index]['menu_id_lunch'];
                                String daydate = menuData[index]['daydate'];

                                args['menuId'] = menuId;
                                args['mealType'] = "Lunch";
                                args['daydate'] = daydate;
                                args['price'] =
                                    menuData[index]['menu_price_lunch'];

                                // Find the index of the existing meal data in mealDataList
                                final existingMealIndex =
                                    mealDataList.indexWhere((meal) =>
                                        meal['daydate'] == daydate &&
                                        meal['mealType'] == 'Lunch');

                                if (existingMealIndex != -1) {
                                  // Remove the existing meal data from the list
                                  print("2) Removing existing lunch data...");
                                  mealDataList.removeAt(existingMealIndex);
                                  // Print the updated mealDataList
                                  print("3) Updated mealDataList:");
                                  mealDataList.forEach((meal) {
                                    print(meal);
                                  });
                                } else {
                                  // Create the meal data map
                                  Map<String, dynamic> newMealData = {
                                    'menuId': menuId,
                                    'mealType': 'Lunch',
                                    'daydate': daydate,
                                    'price': args['price'],
                                    // Add other meal data fields as needed
                                  };

                                  // Add the new meal data to the mealDataList
                                  mealDataList.add(newMealData);

                                  // Print the newly added meal data
                                  print("4) New lunch data added:");
                                  print(newMealData);
                                }
                              }
                            });
                          }),

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
                              mealDataList[dataIndex]['checked'] =
                                  args['checked'];
                              mealDataList[dataIndex]['daydate'] =
                                  args['daydate'];
                              mealDataList[dataIndex]['price'] = args['price'];
                            } else {
                              // If menu ID is not present, add it to lunchDataList and update menuIdIndexMap
                              Map<String, dynamic> lunchData = {
                                'menuId': args['menuId'],
                                'checked': args['checked'],
                                'daydate': args['daydate'],
                                'price': args['price'],
                              };
                              mealDataList.add(lunchData);
                              menuIdIndexMap[menuId] = mealDataList.length -
                                  1; // Store the index of the added menu ID
                            }

                            // Print the updated lunchDataList
                            print('----START----');
                            for (var data in mealDataList) {
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
