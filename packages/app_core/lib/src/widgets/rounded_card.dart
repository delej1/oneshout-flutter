import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class ClippedContainer extends StatelessWidget {
  const ClippedContainer({
    Key? key,
    required this.child,
    this.radius = Corners.lg,
    this.color,
    this.padding,
    this.isScaffoldBody = true,
    this.withPadding = true,
  }) : super(key: key);
  final Widget child;
  final double? radius;
  final Color? color;
  final EdgeInsets? padding;
  final bool isScaffoldBody;
  final bool withPadding;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: color ?? Theme.of(context).canvasColor,
    //   ),
    // );
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        if (isScaffoldBody) VSpace.lg,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius!),
              topRight: Radius.circular(radius!),
            ),
            child: ColoredBox(
              color: color ?? Theme.of(context).canvasColor,
              child: Padding(
                padding: padding ??
                    (withPadding ? EdgeInsets.all(Insets.lg) : EdgeInsets.zero),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    Key? key,
    required this.child,
    this.radius,
  }) : super(key: key);
  final Widget child;
  final double? radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 24)),
        child: child,
      );
}

class RoundedBorder extends StatelessWidget {
  const RoundedBorder({
    Key? key,
    this.color,
    this.width,
    this.radius,
    this.ignorePointer = true,
    this.child,
  }) : super(key: key);
  final Color? color;
  final double? width;
  final double? radius;
  final Widget? child;
  final bool ignorePointer;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignorePointer,
      child: DecoratedContainer(
        borderRadius: radius ?? Corners.md,
        borderColor: color ?? Colors.white,
        borderWidth: width ?? Strokes.thin,
        child: child ?? Container(),
      ),
    );
  }
}
