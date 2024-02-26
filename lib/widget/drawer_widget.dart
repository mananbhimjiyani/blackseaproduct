// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../views/product_list.dart';
import '../views/productRequestCreation.dart';
import '../views/stockMove.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login.dart';
import '../views/user_details.dart'; // Import UserDetails
import 'package:blackseaproduct/Schemas/user.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    User user = User(
      userID: 0,
      userName: '',
      jobTitle: '',
      email: '',
    );

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      // Navigate to UserDetails when profile picture is tapped
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetails(requisitions: [], user: user)),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 60,
                      ),
                    ),
                  ),
                  accountName: GestureDetector(
                    onTap: () {
                      // Navigate to UserDetails when account name is tapped
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetails(requisitions: [], user: user)),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.userName ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          user.jobTitle ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  accountEmail: GestureDetector(
                    onTap: () {
                      // Navigate to UserDetails when account email is tapped
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetails(requisitions: [], user: user)),
                      );
                    },
                    child: Text(
                      user.email ?? '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetails(requisitions: [], user: user)),
                    );
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
