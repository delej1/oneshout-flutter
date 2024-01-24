import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.amount,
    required this.description,
    this.color = Colors.green,
    this.icon,
    this.backgroundColor,
  });
  final String amount;
  final String description;
  final Color color;
  final Color? backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(Insets.md),
        child: Row(
          children: [
            if (icon != null)
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color),
              )
            else
              Container(
                width: Sizes.xs,
                constraints: BoxConstraints(
                  maxWidth: Sizes.xs,
                  minHeight: Sizes.xl * 2,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox.shrink(),
              ),
            HSpace.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amount,
                    style: TextStyles.moneyStyle.copyWith(
                      fontSize: FontSizes.s32,
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      letterSpacing: -2,
                    ),
                  ),
                  Text(
                    description.toUpperCase(),
                    style: TextStyles.title2.copyWith(
                      height: 1,
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCardWrap extends StatelessWidget {
  const StatusCardWrap({
    Key? key,
    required this.children,
    this.gridCount = 2,
    this.padding,
    this.parentPadding = 0,
  }) : super(key: key);
  final List<Widget> children;
  final double gridCount;
  final double? padding;
  final double parentPadding;

  @override
  Widget build(BuildContext context) {
    var width = DeviceScreen.width(context);
    final _padding = padding ?? Insets.md;
    width = (width - (_padding * 3) - parentPadding) / gridCount;
    return Wrap(
      spacing: _padding,
      runSpacing: _padding,
      children: children.map((e) {
        return SizedBox(width: width, child: e);
      }).toList(),
    );
  }
}
