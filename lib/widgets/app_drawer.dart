// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/screens/image_confirm_screen.dart';
import 'package:study_buddy/screens/drawer/account_screen.dart';
import 'package:study_buddy/screens/drawer/assignment_reminders_screen.dart';
import 'package:study_buddy/screens/drawer/motivation_screen.dart';
import 'package:study_buddy/screens/drawer/settings_screen.dart';
import 'package:study_buddy/utils/themes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final username = authProvider.username ?? 'User';
    final appName = imageProvider.appDisplayName;

    final profilePicPath = imageProvider.profilePicPath;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appName, style: kAppNameStyle),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              if (!context.mounted) return;

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
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: profilePicPath != null && File(profilePicPath).existsSync()
                                  ? FileImage(File(profilePicPath))
                                  : const AssetImage('lib/assets/images/logo2.jpg') as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            username,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: const Text('Motivation Bar'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MotivationScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in_outlined),
                  title: const Text('Assignment Reminders'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssignmentRemindersScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('Account'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
           ListTile(
            title: const Text('Made By - ', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('K M DUSHYANTH GOWDA\n1MS24IS058\n\n'),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('MADE WITH ❤️\n\n'),
          ),
        ],
      ),
    );
  }
}