import 'package:flutter/material.dart';

class CustomUploadProgressIndicator extends StatelessWidget {
  final double uploadProgress; // Progress value (0.0 to 1.0)
  final int uploadedItemCount; // Number of uploaded items
  final int totalItemCount; // Total items to be uploaded

  const CustomUploadProgressIndicator({
    Key? key,
    required this.uploadProgress,
    required this.uploadedItemCount,
    required this.totalItemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
            bottom: Radius.circular(10),
          ),
          color: Colors.black.withOpacity(0.7),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              value: uploadProgress,
              minHeight: 40,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Text(
              "(${uploadedItemCount}/${totalItemCount})   ${(uploadProgress * 100).toStringAsFixed(0)}%",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
