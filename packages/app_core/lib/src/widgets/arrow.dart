import 'package:app_core/src/utils/utils.dart';
import 'package:flutter/material.dart';

class TransactionArrow extends StatelessWidget {
  const TransactionArrow({
    Key? key,
    required this.direction,
    this.size = 14,
    this.disabled = false,
  }) : super(key: key);
  final TransactionDirection direction;
  final double size;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final inward = direction == TransactionDirection.inward;
    final height = size;
    final width = size;
    final color = disabled
        ? Theme.of(context).colorScheme.surfaceVariant
        : inward
            ? Colors.green.shade400
            : Colors.red.shade400;

    return inward
        ? CustomPaint(
            size: Size(
              width,
              height,
            ),
            painter: RPSCustomPainter(color),
          )
        : RotatedBox(
            quarterTurns: 2,
            child: CustomPaint(
              size: Size(
                width,
                height,
              ),
              painter: RPSCustomPainter(color),
            ),
          );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter(this.color);

  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final path_0 = Path()
      ..moveTo(size.width * 0.6206700, size.height * 0.09088934)
      ..lineTo(size.width * 0.9299810, size.height * 0.7095113)
      ..cubicTo(
        size.width * 0.9705750,
        size.height * 0.7906992,
        size.width * 0.9376670,
        size.height * 0.8894230,
        size.width * 0.8564791,
        size.height * 0.9300170,
      )
      ..cubicTo(
        size.width * 0.8336575,
        size.height * 0.9414278,
        size.width * 0.8084925,
        size.height * 0.9473684,
        size.width * 0.7829772,
        size.height * 0.9473684,
      )
      ..lineTo(size.width * 0.1643552, size.height * 0.9473684)
      ..cubicTo(
        size.width * 0.07358435,
        size.height * 0.9473684,
        0,
        size.height * 0.8737841,
        0,
        size.height * 0.7830132,
      )
      ..cubicTo(
        0,
        size.height * 0.7574978,
        size.width * 0.005940635,
        size.height * 0.7323329,
        size.width * 0.01735144,
        size.height * 0.7095113,
      )
      ..lineTo(size.width * 0.3266624, size.height * 0.09088934)
      ..cubicTo(
        size.width * 0.3672564,
        size.height * 0.009701391,
        size.width * 0.4659802,
        size.height * -0.02320653,
        size.width * 0.5471681,
        size.height * 0.01738745,
      )
      ..cubicTo(
        size.width * 0.5789753,
        size.height * 0.03329107,
        size.width * 0.6047664,
        size.height * 0.05908210,
        size.width * 0.6206700,
        size.height * 0.09088934,
      )
      ..close();
    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TransactionChip extends StatelessWidget {
  const TransactionChip({
    Key? key,
    required this.direction,
    this.size = 10,
    required this.label,
  }) : super(key: key);
  final String label;
  final TransactionDirection direction;
  final double size;
  @override
  Widget build(BuildContext context) {
    final inward = direction == TransactionDirection.inward;

    final color = inward ? Colors.green.shade400 : Colors.red.shade400;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(Corners.sm),
      ),
      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
      child: Text(
        label.toUpperCase(),
        style: TextStyles.caption.copyWith(
          color: color,
          fontSize: size,
          height: 1.5,
        ),
      ),
    );
  }
}
