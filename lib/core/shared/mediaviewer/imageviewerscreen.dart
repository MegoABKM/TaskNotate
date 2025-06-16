import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewerPage extends StatelessWidget {
  final String imageUrl;

  ImageViewerPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .black, // Optional: set background color to black for full-screen effect
      body: Stack(
        children: [
          // Image to show in full screen
          InteractiveViewer(
            panEnabled: true, // Allow panning
            scaleEnabled: true, // Allow zooming
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Back arrow button
          Positioned(
            top: 40, // Adjust top position for the back arrow
            left: 16, // Adjust left position for the back arrow
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back(); // Go back to the previous screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
