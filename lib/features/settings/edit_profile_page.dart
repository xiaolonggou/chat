import 'package:flutter/material.dart';
import '../../shared/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await TokenStorage.retrieveToken();
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _fullNameController.text = data['full_name'];
          _emailController.text = data['email'];
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final String fullName = _fullNameController.text;
    final String email = _emailController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await TokenStorage.retrieveToken();
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'full_name': fullName, 'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final String currentPassword = _currentPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await TokenStorage.retrieveToken();
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/profile/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error changing password: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
                  const Divider(height: 32),
                  TextField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Change Password'),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
