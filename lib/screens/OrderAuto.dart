import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DayList extends StatefulWidget {
  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  int orderMaxDays = 0;
  String serverDateStr = '';

  Map<String, bool> lunchCheckboxes = {};
  Map<String, bool> dinnerCheckboxes = {};

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.216:8000/api/setting'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orderMaxDays = data['order_max_days'];
        serverDateStr = data['server_date'];

        // Initialize checkboxes after fetching data
        _initializeCheckboxes();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _initializeCheckboxes() {
    List<Map<String, dynamic>> dateList = _generateDateList();
    dateList.forEach((entry) {
      String date = entry['days'][0]['date'];
      lunchCheckboxes[date] = false;
      dinnerCheckboxes[date] = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
                                    Text('Lunch (Quantity - 1 +)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                                    Text('Dinner (Quantity - 1 +)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
    home: DayList(),
  ));
}
