import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Menu {
  final String date;
  final String day;
  final List<MenuItem> lunch;
  final List<MenuItem> dinner;

  Menu({
    required this.date,
    required this.day,
    required this.lunch,
    required this.dinner,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      date: json['date'],
      day: json['day'],
      lunch: (json['lunch']['items'] as List)
          .map((itemJson) => MenuItem.fromJson(itemJson))
          .toList(),
      dinner: (json['dinner']['items'] as List)
          .map((itemJson) => MenuItem.fromJson(itemJson))
          .toList(),
    );
  }
}

class MenuItem {
  final String foodName;
  final String foodImage;

  MenuItem({required this.foodName, required this.foodImage});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      foodName: json['food_name'],
      foodImage: json['food_image'],
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<Menu> menus; // Assuming Menu is the type of your menu items

  @override
  void initState() {
    super.initState();
    // Initialize the menus variable here
    menus =
        []; // Initialize with an empty list, or you can fetch data from somewhere
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.216/tf-lara/public/api/orderauto'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        menus = jsonList.map((json) => Menu.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: menus == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return ListTile(
                  title: Text(menu.date),
                  subtitle: Text(menu.day),
                  onTap: () {
                    // Handle tap on menu item
                  },
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuPage(),
  ));
}
