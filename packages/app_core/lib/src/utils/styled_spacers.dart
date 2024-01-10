// ignore_for_file: prefer_constructors_over_static_methods

import 'package:app_core/app_core.dart';
import 'package:flutter/cupertino.dart';

class VSpace extends StatelessWidget {
  const VSpace(this.size, {Key? key}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);

  static VSpace get xs => VSpace(Insets.xs);
  static VSpace get sm => VSpace(Insets.sm);
  static VSpace get md => VSpace(Insets.md);
  static VSpace get lg => VSpace(Insets.lg);
  static VSpace get xl => VSpace(Insets.xl);
  static VSpace get xxl => VSpace(Insets.xxl);
  static VSpace get xxxl => VSpace(Insets.xxxl);
}

class HSpace extends StatelessWidget {
  const HSpace(this.size, {Key? key}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);

  static HSpace get xs => HSpace(Insets.xs);
  static HSpace get sm => HSpace(Insets.sm);
  static HSpace get md => HSpace(Insets.md);
  static HSpace get lg => HSpace(Insets.lg);
  static HSpace get xl => HSpace(Insets.xl);
}
