import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showEditAppNameDialog(BuildContext context) {
    final imageProvider = Provider.of<ImageStorageProvider>(context, listen: false);
    final textController = TextEditingController(text: imageProvider.appDisplayName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change App Name'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter app name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = textController.text.trim();
              if (name.isNotEmpty) {
                imageProvider.setAppDisplayName(name);
                Navigator.of(ctx).pop();
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
    final imageProvider = Provider.of<ImageStorageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('App Display Name'),
              subtitle: Text(imageProvider.appDisplayName),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showEditAppNameDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}