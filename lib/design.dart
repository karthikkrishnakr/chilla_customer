import 'package:flutter/material.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Define the heights for the curves
    double curveStartHeight = size.height * 0.3;
    double curveEndHeight = size.height * 0.45;

    // Start from the top left corner
    path.lineTo(0, curveStartHeight);

    // First curve control and end points
    var firstControlPoint = Offset(size.width * 0.35, curveStartHeight - 95);
    var firstEndPoint = Offset(size.width * 0.55, curveStartHeight);

    // Second curve control and end points
    var secondControlPoint = Offset(size.width * 0.85, curveEndHeight + 100);
    var secondEndPoint = Offset(size.width, curveEndHeight);

    // Draw the first curve
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Draw the second curve
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Close the path by drawing lines to the bottom right and left corners
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
