import 'package:flutter/material.dart';
import 'productRequestCreation.dart';
import 'productRequestView.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (username == 'captain' && password == 'captain') {
      _saveLoginStatus(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RequisitionListView()),
      );
    } else if (username == 'admin' && password == 'admin') {
      _saveLoginStatus(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else if (username == 'user' && password == 'user') {
      _saveLoginStatus(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductRequestCreation()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unknown user role')));
    }
  }

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any other loading indicator
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            // If user is already logged in, navigate to the appropriate page
            return RequisitionListView(); // You can replace this with any default page after login
          } else {
            // If user is not logged in, show the login page
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
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                                child: Text(
                                  'Proceed',
                                  style: TextStyle(color: Colors.white),
                                ),
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
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
