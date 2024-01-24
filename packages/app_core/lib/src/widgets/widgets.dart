import 'package:app_core/src/utils/utils.dart';
import 'package:flutter/material.dart';

export 'arrow.dart';
export 'avatar_widget.dart';
export 'bottom_navigation_widget.dart';
export 'bottomsheet.dart';
export 'buttons/buttons.dart';
export 'country_picker/country_picker.dart';
export 'decorated_container.dart';
export 'empty_image.dart';
export 'filtered_chip.dart';
export 'icon_widget.dart';
export 'language_picker/language_picker.dart';
export 'positioned_all.dart';
export 'responsive_widget.dart';
export 'rounded_card.dart';
export 'status_card.dart';
export 'stock_type_chip.dart';
export 'tabbar/tabbar.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({Key? key, required this.label, this.textStyle})
      : super(key: key);
  final String label;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        HSpace.md,
        Text(label, style: textStyle ?? Theme.of(context).textTheme.caption),
        HSpace.md,
        const Expanded(child: Divider()),
      ],
    );
  }
}
