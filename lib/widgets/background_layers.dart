import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/styles.dart';

class BackgroundLayers extends StatelessWidget {
  const BackgroundLayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid Floor
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(0.2) // 10deg roughly
                ..scale(1.5, 1.5, 1.5),
              child: CustomPaint(painter: GridPainter()),
            ),
          ),
        ),

        // Ambient Glow Orbs
        // Top Left
        Positioned(
          top: -100,
          left: -100,
          width: 800,
          height: 800,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.05),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.05,
                  ), // Very low alpha
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 4.seconds,
                curve: Curves.easeInOut,
              ),
        ),

        // Bottom Right
        Positioned(
          bottom: -100,
          right: -100,
          width: 600,
          height: 600,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(
                    alpha: 0.05,
                  ), // Very low alpha
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
          )
              .animate(
                delay: 1.seconds,
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.3, 1.3),
                duration: 5.seconds,
                curve: Curves.easeInOut,
              ),
        ),

        // Bottom Gradient Overlay (to fade out grid at bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 150,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.backgroundDark, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const double spacing = 60.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
