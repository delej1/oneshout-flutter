import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///Option for the MoneyText display format
enum MoneyTextFormat {
  /// Format with currency and decimal e.g NGN 5,000.00
  normal,

  /// Format without currency, but with decimal e.g 5,000.00
  plain,

  /// Compact value e.g NGN 5k
  compact,
}

/// Money Text Field
class MoneyText extends StatelessWidget {
  ///
  MoneyText(
    this.amount, {
    Key? key,
    MoneyTextStyle? style,
  })  : style = const MoneyTextStyle().merge(
          style ?? const MoneyTextStyle(),
        ),
        super(key: key);

  /// Compact MoneyText widget.
  MoneyText.compact(
    this.amount, {
    Key? key,
    MoneyTextStyle? style,
  })  : style = const MoneyTextStyle(
          moneyFormat: MoneyTextFormat.compact,
        ).merge(style!),
        super(key: key);

  /// Plain MoneyText widget.
  MoneyText.plain(
    this.amount, {
    Key? key,
    MoneyTextStyle? style,
  })  : style = const MoneyTextStyle(
          moneyFormat: MoneyTextFormat.plain,
        ).merge(style!),
        super(key: key);

  /// Money value to display. e.g 5000
  final num amount;

  /// Style for the widget [MoneyTextStyle].
  final MoneyTextStyle? style;

  @override
  Widget build(BuildContext context) {
    final currencyFontSize = style!.currencyFontSize ?? style!.amountFontSize;

    return RichText(
      text: TextSpan(
        text: style!.moneyFormat == MoneyTextFormat.plain
            ? ''
            : style!.withCurrencyCode!
                ? '${style!.currencyCode!} '
                : '${style!.currencySymbol}',
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: currencyFontSize,
          fontWeight: style!.fontWeight,
        ),
        children: [
          TextSpan(
            text: _formatMoneyText(),
            style: TextStyle(
              color: amount < 0 ? Colors.red : Colors.grey.shade800,
              fontSize: style!.amountFontSize,
              fontWeight: style!.fontWeight,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMoneyText() {
    var f = style!.compact!
        ? NumberFormat.compactCurrency(
            name: '',
            symbol: '',
          )
        : NumberFormat.currency(
            customPattern: '#,###.##',
            name: '',
            symbol: '',
          );

    switch (style!.moneyFormat) {
      case MoneyTextFormat.compact:
        f = NumberFormat.compactCurrency(name: '', symbol: '');
        break;
      case MoneyTextFormat.normal:
        f = f;
        break;
      case MoneyTextFormat.plain:
        f = f;
        break;
      case null:
        f = f;
    }

    final formattedAmount = f.format(amount);

    return formattedAmount;
  }
}

/// Style definitions fo a MoneyTextField
class MoneyTextStyle {
  ///
  const MoneyTextStyle({
    this.currencyCode = 'NGN ',
    this.currencySymbol = '₦ ',
    this.moneyFormat = MoneyTextFormat.normal,
    this.amountFontSize,
    this.currencyFontSize,
    this.withCurrencyCode = false,
    this.showCurrency = true,
    this.compact = false,
    this.fontWeight,
  });

  /// Currency code e.g NGN.
  final String? currencyCode;

  /// Currency symbol e.g ₦.
  final String? currencySymbol;

  /// Money display format [MoneyTextFormat].
  final MoneyTextFormat? moneyFormat;

  /// Font size for the money value.
  final double? amountFontSize;

  /// Font size for the currency name.
  final double? currencyFontSize;

  /// Flag to display the currency code.
  final bool? withCurrencyCode;

  /// Flag to display the currency
  final bool? showCurrency;

  /// Flag to compact the money value.
  /// If true, it displays 5k, otherwise 5,000
  final bool? compact;

  /// Font weight for the widget.
  final FontWeight? fontWeight;

  /// Merge default with user's custom styling for the widget
  MoneyTextStyle merge(MoneyTextStyle style) {
    return MoneyTextStyle(
      currencyCode: style.currencyCode ?? currencyCode,
      currencySymbol: style.currencySymbol ?? currencySymbol,
      moneyFormat: moneyFormat ?? style.moneyFormat,
      amountFontSize: style.amountFontSize ?? amountFontSize,
      currencyFontSize: style.currencyFontSize ?? currencyFontSize,
      withCurrencyCode: style.withCurrencyCode ?? withCurrencyCode,
      showCurrency: style.showCurrency ?? showCurrency,
      compact: style.compact ?? compact,
      fontWeight: style.fontWeight ?? fontWeight,
    );
  }
}
