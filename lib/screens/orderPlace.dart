import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../widgets/appBar.dart';

class OrderPlace extends StatefulWidget {
  final int menuId;
  final String menuOf;
  final String date;
  final String mealType;
  final String day;

  const OrderPlace({
    Key? key,
    required this.menuId,
    required this.menuOf,
    required this.date,
    required this.mealType,
    required this.day,
  }) : super(key: key);

  @override
  _OrderPlaceState createState() => _OrderPlaceState();
}

class _OrderPlaceState extends State<OrderPlace> {
  late Future<Map<String, dynamic>> _menuData;
  late Future<Map<String, dynamic>> _settingData;

  @override
  void initState() {
    super.initState();
    _menuData = fetchMenuData(widget.menuId);
    _settingData = fetchSettingData();
  }

  Future<Map<String, dynamic>> fetchMenuData(int menuId) async {
    final response = await http
        .get(Uri.parse('http://192.168.0.216/tf-lara/public/api/menu/$menuId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load menu data');
    }
  }

  Future<Map<String, dynamic>> fetchSettingData() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.216/tf-lara/public/api/setting'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load setting data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(title: "Place Order"),
      body: FutureBuilder(
        future: Future.wait([_menuData, _settingData]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final menuData = snapshot.data![0] as Map<String, dynamic>;
            final settingData = snapshot.data![1] as Map<String, dynamic>;

            final deliveryCharge = settingData['delivery_charge'] ?? 'N/A';

            List<dynamic> menuItems = [];
            if (widget.mealType == 'Lunch') {
              menuItems = menuData['lunch'] as List<dynamic>;
            } else if (widget.mealType == 'Dinner') {
              menuItems = menuData['dinner'] as List<dynamic>;
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "${widget.menuOf} (${widget.day}, ${widget.date}) (${widget.mealType})",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(menuItems.length, (index) {
                      final item = menuItems[index];
                      return Expanded(
                        child: Column(
                          children: [
                            Image.network(
                              'http://192.168.0.216/tf-lara/public/assets/images/${item['food_image']}',
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['food_name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Text(
                  'Delivery Charge: $deliveryCharge',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: ${widget.mealType == 'Lunch' ? menuData['menu_price_lunch'] : menuData['menu_price_dinner']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/screens/home');
                  },
                  child: Text('Back to Home'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/screens/orderauto',
                      arguments: {
                        'checked': 'yes',
                        'menuId': widget.menuId,
                        'daydate': '${widget.day}, ${widget.date}',
                        'mealType': widget.mealType,
                        'price': widget.mealType,
                      },
                    );
                  },
                  child: Text('Proceed'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
