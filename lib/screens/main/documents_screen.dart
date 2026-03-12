import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/widgets/document_viewer_screen.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  void _showAddDocumentDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Document'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter document name',
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
                Navigator.of(ctx).pop();
                Provider.of<ImageStorageProvider>(context, listen: false)
                    .addDocument(name);
              }
            },
            child: const Text('Choose Photo'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, int index, String currentName) {
    final textController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
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
                    .renameDocument(index, name);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document'),
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
                  .deleteDocument(index);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, int index, String name) {
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
                _showRenameDialog(context, index, name);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(ctx).pop();
                _showDeleteConfirmation(context, index, name);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(imagePath: imagePath, title: title, isFile: true),
        ));
      },
      onLongPress: () {
        _showOptionsBottomSheet(context, index, title);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error_outline, color: Colors.red, size: 40),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final documents = imageProvider.documents;

    return Scaffold(
      body: documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No documents yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first document',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: documents.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (ctx, i) => _buildGridItem(
                context,
                i,
                documents[i]['name']!,
                documents[i]['path']!,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDocumentDialog(context),
        tooltip: 'Add Document',
        child: const Icon(Icons.add),
      ),
    );
  }
}