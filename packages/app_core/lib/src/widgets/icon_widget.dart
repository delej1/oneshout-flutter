import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    Key? key,
    required this.color,
    required this.icon,
    this.size = 24,
  }) : super(key: key);
  final Color color;
  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    );
  }
}
