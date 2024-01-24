import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class StockTypeFilterChip extends StatefulWidget {
  const StockTypeFilterChip({
    super.key,
    this.active = 0,
    required this.onChanged,
    this.children = const ['Stock In', 'Stock Out'],
    this.height = 50,
  });

  final int? active;
  final void Function(int) onChanged;
  final List<String> children;
  final double? height;

  @override
  State<StockTypeFilterChip> createState() => _StockTypeFilterChipState();
}

class _StockTypeFilterChipState extends State<StockTypeFilterChip> {
  late int activeValue;

  @override
  void initState() {
    super.initState();
    activeValue = widget.active!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();

              setState(() {
                activeValue = 0;
              });
              widget.onChanged(0);
            },
            child: _chip(
              label: widget.children[0],
              active: 0 == activeValue,
              context: context,
              type: 'in',
              height: widget.height!,
            ),
          ),
        ),
        HSpace.lg,
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();

              setState(() {
                activeValue = 1;
              });
              widget.onChanged(1);
            },
            child: _chip(
              label: widget.children[1],
              active: 1 == activeValue,
              context: context,
              type: 'out',
              height: widget.height!,
            ),
          ),
        )
      ],
      // separatorBuilder: (BuildContext context, int index) {
      //   return HSpace.md;
      // },
    );
  }

  Widget _chip({
    required bool active,
    required String label,
    required String type,
    required BuildContext context,
    double height = 50,
  }) {
    var bgColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
    var fgColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.2);

    if (type == 'in') {
      if (active) bgColor = Colors.green.shade400;
      if (active) fgColor = Colors.green.shade400;
    } else {
      if (active) bgColor = Colors.red.shade400;
      if (active) fgColor = Colors.red.shade400;
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: bgColor,
        ),
        minimumSize: const Size(0, 40),
        maximumSize: Size(0, height),
      ),
      onPressed: active ? null : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HSpace.md,
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(color: fgColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          HSpace.md,
          ClipOval(
            child: DecoratedContainer(
              borderRadius: height,
              borderWidth: 1,
              borderColor: bgColor,
              color: active ? Colors.white : Colors.transparent,
              padding: EdgeInsets.all(Insets.sm),
              child: TransactionArrow(
                direction: type == 'in'
                    ? TransactionDirection.inward
                    : TransactionDirection.outward,
                disabled: !active,
                size: height / 4,
              ),
            ),
          )
        ],
      ),
    );
  }
}
