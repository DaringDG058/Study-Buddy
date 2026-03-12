import 'dart:io';

import 'package:flutter/material.dart';

/// A full-screen image preview with confirm (✓) and cancel (✗) buttons.
/// Properly padded with SafeArea to avoid collision with the device
/// status bar and navigation bar.
///
/// Returns `true` if the user confirms, `false` / null if cancelled.
class ImageConfirmScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImageConfirmScreen({
    super.key,
    required this.imagePath,
    this.title = 'Confirm Image',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen image preview
            Positioned.fill(
              child: InteractiveViewer(
                child: Center(
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Top action bar with cancel and confirm buttons
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel (X) button
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      tooltip: 'Cancel',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.7),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),

                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Confirm (✓) button
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.check, color: Colors.white, size: 30),
                      tooltip: 'Confirm',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green.withValues(alpha: 0.7),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
