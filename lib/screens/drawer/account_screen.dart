import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/screens/auth/login_screen.dart';
import 'package:study_buddy/screens/image_confirm_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _showEditUsernameDialog(BuildContext context, AuthProvider authProvider) {
    final textController = TextEditingController(text: authProvider.username);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new username',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newUsername = textController.text.trim();
              if (newUsername.isNotEmpty) {
                authProvider.updateCredentials(newUsername, authProvider.password ?? '');
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Username updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthProvider authProvider) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Current password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'New password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final oldPass = oldPasswordController.text;
              final newPass = newPasswordController.text;
              
              if (oldPass == authProvider.password) {
                if (newPass.isNotEmpty) {
                  authProvider.updateCredentials(authProvider.username ?? '', newPass);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New password cannot be empty')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect current password')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final profilePicPath = imageProvider.profilePicPath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Profile Picture Section
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image == null) return;
                if (!context.mounted) return;
                
                // Show confirm screen with SafeArea-protected buttons
                final confirmed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => ImageConfirmScreen(
                      imagePath: image.path,
                      title: 'Confirm Profile Picture',
                    ),
                  ),
                );
                
                if (confirmed == true && context.mounted) {
                  imageProvider.setProfilePicPath(image.path);
                }
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: profilePicPath != null && File(profilePicPath).existsSync()
                        ? FileImage(File(profilePicPath))
                        : const AssetImage('lib/assets/images/logo2.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to change photo',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Account Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Username'),
              subtitle: Text(authProvider.username ?? 'N/A', style: const TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () => _showEditUsernameDialog(context, authProvider),
            ),
            const Divider(),
            ListTile(
              title: const Text('Password'),
              subtitle: const Text('••••••••', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () => _showChangePasswordDialog(context, authProvider),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Note: For security reasons, storing and displaying passwords in plain text is not recommended in production applications.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  authProvider.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}