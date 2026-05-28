import 'package:flutter/material.dart';

class RicePlantWidget extends StatelessWidget {
  final double height;
  final double width;

  const RicePlantWidget({
    super.key,
    this.height = 80,
    this.width = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/rice.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
