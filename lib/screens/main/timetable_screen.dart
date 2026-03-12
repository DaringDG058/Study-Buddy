import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageStorageProvider>(context);
    final timetablePath = imageProvider.timetablePath;
    final hasImage = timetablePath != null && File(timetablePath).existsSync();

    return Scaffold(
      body: hasImage
          ? PhotoView(
              imageProvider: FileImage(File(timetablePath)),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No timetable uploaded yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await imageProvider.pickAndSetTimetable();
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Timetable'),
                  ),
                ],
              ),
            ),
      floatingActionButton: hasImage
          ? FloatingActionButton(
              onPressed: () async {
                await imageProvider.pickAndSetTimetable();
              },
              tooltip: 'Change Timetable',
              child: const Icon(Icons.edit),
            )
          : null,
    );
  }
}