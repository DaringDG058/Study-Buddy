import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  void _showEditUrlDialog(BuildContext context) {
    final imageProvider =
        Provider.of<ImageStorageProvider>(context, listen: false);
    final textController =
        TextEditingController(text: imageProvider.attendanceUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Attendance Link'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'https://example.com',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              var url = textController.text.trim();
              if (url.isNotEmpty) {
                if (!url.startsWith('http://') &&
                    !url.startsWith('https://')) {
                  url = 'https://$url';
                }
                imageProvider.setAttendanceUrl(url);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Attendance link updated successfully')),
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
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final url = imageProvider.attendanceUrl;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.language, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Attendance Portal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                url,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _launchURL(context, url),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Open Attendance Portal',
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _showEditUrlDialog(context),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Change Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}