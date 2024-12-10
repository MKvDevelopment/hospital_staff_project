import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String placeholderUrl; // If needed for a fallback image
  final double borderRadius;
  final BoxFit fit;
  final Duration fadeDuration;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl, // Image URL (can be thumbnail or main)
    this.placeholderUrl = '',
    this.borderRadius = 8.0,
    this.fit = BoxFit.cover,
    this.fadeDuration = const Duration(seconds: 1), // Duration for fade animation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl.isNotEmpty ? imageUrl : placeholderUrl,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          } else {
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: fadeDuration,
              curve: Curves.easeIn,
              child: child,
            );
          }
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.error, color: Colors.red),
          );
        },
      ),
    );
  }
}
