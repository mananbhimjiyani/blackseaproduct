import 'package:flutter/material.dart';
import '../views/product_list.dart';
import '../views/productRequestCreation.dart';
import '../views/stockMove.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    // Set background color for avatar
                    child: Icon(
                      Icons.person,
                      color: Colors.blue, // Set color for icon
                      size: 60, // Set size for icon
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
                  leading: const Icon(Icons.list),
                  title: const Text('Product'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductList()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_list_bulleted_add),
                  title: const Text('Purchase Requisition'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductRequestCreation()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.move_down_rounded),
                  title: const Text('Stock Move'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const StockMove()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('User'),
                  onTap: () {
                    // Handle menu item 2 tap
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About This App'),
                  onTap: () {
                    // Handle menu item 2 tap
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
            trailing: const Icon(Icons.exit_to_app),
          ),
          const SizedBox(height: 20,)
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