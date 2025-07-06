import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideImage extends StatelessWidget {
  final String imagePath;
  final int index;

  const SlideImage({Key? key, required this.imagePath, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'gallery_image_$index',
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main Image with smooth loading
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                imagePath,
                key: ValueKey(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Gradient Overlay for better text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
