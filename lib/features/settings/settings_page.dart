import 'package:flutter/material.dart';
import 'package:chat/features/settings/edit_profile_page.dart';
import 'package:chat/shared/utils/token_storage.dart'; // Import TokenStorage for logout
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for token removal

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
          const Divider(), // Optional, to separate sections
          // Logout ListTile
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Clear token from storage when user logs out
              await TokenStorage.removeToken();

              // Navigate back to login screen after logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
