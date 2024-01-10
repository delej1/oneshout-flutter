import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle = const SizedBox.shrink(),
    this.quantity = 0,
    this.unit = '',
    this.direction,
    this.onTap,
    this.withArrow = false,
  });
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final num? quantity;
  final String unit;
  final TransactionDirection? direction;
  final Function? onTap;
  final bool withArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        key: key,
        onTap: () => onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: Insets.md),
        minLeadingWidth: 14,
        leading: leading ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TransactionArrow(
                  direction: TransactionDirection.inward,
                ),
              ],
            ),
        title: Text(
          title,
          style: TextStyles.body2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            trailing ??
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 24, height: 1),
                    ),
                    Text(
                      unit,
                    ).subtitle(
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    )
                  ],
                ),
            if (withArrow) ...[
              HSpace.sm,
              const SizedBox(
                width: 16,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
