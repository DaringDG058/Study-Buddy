import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DocumentViewerScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isFile;

  const DocumentViewerScreen({
    super.key,
    required this.imagePath,
    required this.title,
    this.isFile = false,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProviderWidget = isFile
        ? FileImage(File(imagePath))
        : AssetImage(imagePath) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PhotoView(
        imageProvider: imageProviderWidget,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}