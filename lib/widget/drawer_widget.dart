import 'package:flutter/material.dart';
import '../Schemas/product.dart';
import '../views/product_list.dart';
import '../views/productRequestCreation.dart';
import '../views/stockMove.dart';
import '../views/productRequestCreation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    // Set background color for avatar
                    child: Icon(
                      Icons.person,
                      color: Colors.blue, // Set color for icon
                      size: 64, // Set size for icon
                    ),
                  ),
                  accountName: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'John Doe', // Replace with actual user name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set color for name
                        ),
                      ),
                      SizedBox(width: 8), // Adding some space between name and rank
                      Text(
                        'Major', // Replace with actual rank
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Set color for rank
                        ),
                      ),
                    ],
                  ),
                  accountEmail: Text(
                    'john.doe@example.com', // Replace with actual user email
                    style: TextStyle(
                      color: Colors.white, // Set color for email
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Product'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Purchase Requisition'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProductRequestCreation()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Stock Move'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StockMove()),
                    );
                  },
                ),
                ListTile(
                  title: Text('User'),
                  onTap: () {
                    // Handle menu item 2 tap
                  },
                ),
                ListTile(
                  title: Text('About This App'),
                  onTap: () {
                    // Handle menu item 2 tap
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
            trailing: Icon(Icons.exit_to_app),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}