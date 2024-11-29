import 'package:flutter/material.dart';
import 'login.dart';
import '../../shared/utils/token_storage.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await TokenStorage.removeToken(); // Remove the token from storage
            Navigator.pushReplacementNamed(context, '/login'); // Navigate back to login page
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
