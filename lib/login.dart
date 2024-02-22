import 'package:flutter/material.dart';
import 'product_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: Center(
        child: Text('Welcome User!'),
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Text('Welcome Admin!'),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == 'user' && password == 'user') {
      // Navigate to product list
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductList()),
      );
      return;
    } else if (username == 'admin' && password == 'admin') {
      // Navigate to admin page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
      return;
    }

    // Otherwise, proceed with the HTTP request
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'), // Change to your server URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String userRole = responseData['role'];

      if (userRole == 'admin') {
        // Navigate to admin page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (userRole == 'user') {
        // Navigate to user page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        // Unknown role
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unknown user role')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/bsm-logo.png'),
                    width: 300,
                    height: 100,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BSM",
                      style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    Text(
                      "Requisition System",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: Text('Proceed',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
