import 'package:app_form_fields/src/money_textfield/money_textfield_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is a form field for money values.
class MoneyTextField extends StatefulWidget {
  ///
  const MoneyTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.incremental = false,
    this.decoration = const InputDecoration(
      hintText: '0.00',
    ),
    this.textStyle = const TextStyle(
      fontFamily: '',
    ),
    this.textAlign = TextAlign.center,
    this.autoFocus = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,

    // this.error = "",
  }) : super(key: key);

  /// [MoneyTextFieldController] controller for the MoneyTextField.
  final MoneyTextFieldController controller;

  /// FocusNode for the MoneyTextField.
  final FocusNode? focusNode;

  /// Show increment/decrement buttons if true.
  final bool incremental;

  /// [InputDecoration] for the MoneyTextField.
  final InputDecoration? decoration;

  /// [TextStyle] for the MoneyTextField.
  final TextStyle? textStyle;

  /// [TextAlign] for the MoneyTextField.
  final TextAlign textAlign;

  /// Flag to set focus on the MoneyTextField.
  final bool autoFocus;

  /// Flag to set focus on the MoneyTextField.
  final bool readOnly;

  /// Validators for the MoneyTextField.
  final String? Function(dynamic value)? validator;

  /// Trigger on value change.
  final ValueChanged<String>? onChanged;

  // String error;

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  FocusNode focusNode = FocusNode();
  TextAlign textAlign = TextAlign.start;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(_onFocus);

    textAlign = widget.incremental ? TextAlign.center : TextAlign.start;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, TextEditingValue value, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.incremental)
              Row(
                children: [
                  _counterAction(
                    icon: CupertinoIcons.minus,
                    onPressed: () => widget.controller.decrement(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildTextField(),
                    ),
                  ),
                  _counterAction(
                    icon: CupertinoIcons.add,
                    onPressed: () => widget.controller.increment(),
                  ),
                ],
              )
            else
              _buildTextField(),
            if (widget.controller.errorText.isNotEmpty)
              Text(
                widget.controller.errorText,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Colors.red,
                    ),
              )
          ],
        );
      },
    );
  }

  SizedBox _counterAction({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 35,
      width: 35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      textAlign: textAlign,
      decoration: widget.decoration,
      style: widget.textStyle,
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        widget.onChanged?.call(value);
        setState(() {
          widget.controller.errorText = '';
        });
      },
      focusNode: focusNode,
      autofocus: widget.autoFocus,
      // readOnly: widget.controller.readOnly,
      readOnly: widget.readOnly,
      validator: (value) => widget.validator?.call(value),
    );
  }

  void _onFocus() {
    if (widget.controller.readOnly) return;
    if (focusNode.hasFocus) {
      widget.controller.fieldHasFocus = true;
      widget.controller.toNum();
    } else {
      widget.controller.fieldHasFocus = false;
      widget.controller.toMoney();
    }
  }
}
