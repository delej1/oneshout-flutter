import 'package:flutter/material.dart';

class TabbarContent extends StatelessWidget {
  const TabbarContent({
    Key? key,
    required this.controller,
    required this.children,
    this.physics,
    this.isSnnaping = true,
  }) : super(key: key);
  final PageController controller;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final bool isSnnaping;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      pageSnapping: isSnnaping,
      physics: physics,
      children: children,
    );
  }
}
