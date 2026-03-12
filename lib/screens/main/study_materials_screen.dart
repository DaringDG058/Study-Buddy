import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  void _launchURL(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  void _showAddLinkDialog(BuildContext context) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Link name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
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
              final name = nameController.text.trim();
              var url = urlController.text.trim();
              if (name.isNotEmpty && url.isNotEmpty) {
                if (!url.startsWith('http://') && !url.startsWith('https://')) {
                  url = 'https://$url';
                }
                Provider.of<ImageStorageProvider>(context, listen: false)
                    .addLink(name, url);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showRenameLinkDialog(BuildContext context, int index, String currentName) {
    final textController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Link'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
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
                Provider.of<ImageStorageProvider>(context, listen: false)
                    .renameLink(index, name);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteLinkConfirmation(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Link'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<ImageStorageProvider>(context, listen: false)
                  .deleteLink(index);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLinkOptionsBottomSheet(BuildContext context, int index, String name) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showRenameLinkDialog(context, index, name);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(ctx).pop();
                _showDeleteLinkConfirmation(context, index, name);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final allLinks = imageProvider.links;

    return Scaffold(
      body: allLinks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No links yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('Tap + to add a link', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 80.0),
              itemCount: allLinks.length,
              itemBuilder: (context, index) {
                final link = allLinks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                  child: ListTile(
                    title: Text(
                      link['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      link['url']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _launchURL(context, link['url']!),
                    onLongPress: () => _showLinkOptionsBottomSheet(context, index, link['name']!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLinkDialog(context),
        tooltip: 'Add Link',
        child: const Icon(Icons.add_link),
      ),
    );
  }
}