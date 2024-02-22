import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stockMoveList.dart';
import 'drawer_widget.dart';
import 'bottom_navigation_bar_widget.dart';

class StockMove extends StatefulWidget {
  @override
  _StockMoveState createState() => _StockMoveState();
}

class _StockMoveState extends State<StockMove> {
  String? selectedFromLocation;
  String? selectedToLocation;
  List<String> locations = [];
  int _currentIndex = 2;

  late Widget destinationScreen; // Initialize destinationScreen here

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/locations'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> fetchedLocations = [];
      for (var location in data) {
        fetchedLocations.add(location['Name']);
      }
      setState(() {
        locations = fetchedLocations;
      });
    } else {
      throw Exception('Failed to fetch locations');
    }
  }

  void navigateToStoreMoveList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockMoveList(
          selectedFromLocation: selectedFromLocation!,
          selectedToLocation: selectedToLocation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Disable the automatic drawer button
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Use the menu icon for the drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        title: Row(
          children: [
            SizedBox(width: 8),
            // Add space between the menu icon and the logo
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/bsm-logo.png',
                height: 40,
              ),
            ),
            SizedBox(width: 8),
            // Add space between the logo and the product list title
            Text('Location'),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: Text('From Location'),
              value: selectedFromLocation,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFromLocation = newValue;
                });
              },
              items: locations
                  .where((value) => value != selectedToLocation)
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            if (selectedFromLocation != null)
              DropdownButton<String>(
                hint: Text('To Location'),
                value: selectedToLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedToLocation = newValue;
                  });
                },
                items: locations
                    .where((value) => value != selectedFromLocation)
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ElevatedButton(
              onPressed: navigateToStoreMoveList,
              child: Text('Continue',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: _currentIndex),
    );
  }
}
