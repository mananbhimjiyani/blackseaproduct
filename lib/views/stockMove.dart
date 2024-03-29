import 'package:flutter/material.dart';
import 'stockMoveList.dart';
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import '../DummyData/LocationDummy.dart';

class StockMove extends StatefulWidget {
  const StockMove({super.key});

  @override
  _StockMoveState createState() => _StockMoveState();
}

class _StockMoveState extends State<StockMove> {
  String? selectedFromLocation;
  String? selectedToLocation;
  List<String> locations = [];
  final int _currentIndex = 2;

  late Widget destinationScreen;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    // final response =
    //     await http.get(Uri.parse('http://172.20.10.8:3000/locations'));
    //
    // if (response.statusCode == 200) {
    //   List<dynamic> data = json.decode(response.body);
    //   List<String> fetchedLocations = [];
    //   for (var location in data) {
    //     fetchedLocations.add(location['Name']);
    //   }
    //   setState(() {
    //     locations = fetchedLocations;
    //   });
    // } else {
    //   throw Exception('Failed to fetch locations');
    // }
    List<String> dummyLocations = generateDummyLocations();

    setState(() {
      locations = dummyLocations;
    });
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            // Add space between the menu icon and the logo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/appbar.png',
                height: 40,
              ),
            ),
            const SizedBox(width: 8),
            // Add space between the logo and the product list title
            const Text('Location',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text('From Location'),
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
                hint: const Text('To Location'),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text('Continue',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: _currentIndex),
    );
  }
}
