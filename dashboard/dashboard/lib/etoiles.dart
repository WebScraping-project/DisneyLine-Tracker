  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'dart:math';

class StarBackground extends StatelessWidget {
  const StarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: StarPainter(),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  List<Star> stars;

  StarPainter() : stars = generateStars();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      canvas.drawCircle(Offset(star.x, star.y), star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

List<Star> generateStars() {
  final random = Random();
  List<Star> stars = [];
  for (int i = 0; i < 100; i++) {
    final x = random.nextDouble() * 2000;
    final y = random.nextDouble() *
        1000; // ajustez la taille de l'écran selon vos besoins
    final radius = random.nextDouble() * 1.5; // Taille des étoiles aléatoire
    stars.add(Star(x: x, y: y, radius: radius));
  }
  return stars;
}

class Star {
  final double x;
  final double y;
  final double radius;

  Star({required this.x, required this.y, required this.radius});
}