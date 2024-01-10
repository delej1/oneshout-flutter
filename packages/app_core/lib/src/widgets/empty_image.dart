import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {
  const EmptyImage({
    Key? key,
    this.radius = 80,
    this.lightMode = true,
  }) : super(key: key);

  final double radius;
  final bool lightMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      padding: EdgeInsets.all(radius / 6),
      decoration: BoxDecoration(
        color: lightMode
            ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
            : Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: lightMode
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(radius),
        ),
        height: radius / 2,
        child: Icon(
          Icons.camera_alt_rounded,
          color: lightMode
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          size: radius / 2.5,
        ),
      ),
    );
  }
}
