// ignore_for_file: lines_longer_than_80_chars, comment_references

library intl_phone_field;

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Country Picker Text Field
class IntlCountryField extends StatefulWidget {
  ///
  const IntlCountryField({
    Key? key,
    this.initialCountryCode,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.readOnly = true,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down_rounded),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.flagWidth = 30.0,
    this.cursorColor,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage,
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
  }) : super(key: key);

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;

  ///Cakkback when user taps widget.
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  ///Callback when form is submitted.
  final FormFieldSetter<Country>? onSaved;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<Country>? onChanged;

  ///Callback when user changes country.
  final ValueChanged<Country>? onCountryChanged;

  /// For validator to work, turn [autovalidateMode] to [AutovalidateMode.onUserInteraction]
  final FutureOr<String?> Function(String?)? validator;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final void Function(String)? onSubmitted;

  /// If false the widget is "disabled": it ignores taps, the [TextFormField]'s
  /// [decoration] is rendered in grey,
  /// [decoration]'s [InputDecoration.counterText] is set to `""`,
  /// and the drop down icon is hidden no matter [showDropdownIcon] value.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  /// 2 Letter ISO Code
  final String? initialCountryCode;

  /// List of 2 Letter ISO Codes of countries to show. Defaults to showing the inbuilt list of all countries.
  final List<String>? countries;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// Won't work if [enabled] is set to `false`.
  final bool showDropdownIcon;

  /// Flag chooser dropdown decoration.
  final BoxDecoration dropdownDecoration;

  /// The style use for the country dial code.
  final TextStyle? dropdownTextStyle;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Icon of the drop down button.
  ///
  /// Default is [Icon(Icons.arrow_drop_down)]
  final Icon dropdownIcon;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Autovalidate mode for text form field
  final AutovalidateMode? autovalidateMode;

  /// Whether to show or hide country flag.
  ///
  /// Default value is `true`.
  final bool showCountryFlag;

  /// Width of country flag.
  ///
  /// Default value is 30.0.
  final double flagWidth;

  /// Message to be displayed on autoValidate error
  ///
  /// Default value is `Invalid Mobile Number`.
  final String? invalidNumberMessage;

  /// The color of the cursor.
  final Color? cursorColor;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The padding of the Flags Button.
  ///
  /// The amount of insets that are applied to the Flags Button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry flagsButtonPadding;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Optional set of styles to allow for customizing the country search
  /// & pick dialog
  final PickerDialogStyle? pickerDialogStyle;

  @override
  IntlCountryFieldState createState() => IntlCountryFieldState();
}

///
class IntlCountryFieldState extends State<IntlCountryField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> _filteredCountries;
  late String _number;

  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries == null
        ? countries
        : countries
            .where((country) => widget.countries!.contains(country.code))
            .toList();
    _filteredCountries = _countryList;
    _number = widget.initialValue ?? '';

    if (widget.initialCountryCode == null && _number.startsWith('+')) {
      _number = _number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere(
        (country) => _number.startsWith(country.dialCode),
        orElse: () => _countryList.first,
      );
      _number = _number.substring(_selectedCountry.dialCode.length);
    } else {
      _selectedCountry = _countryList.firstWhere(
        (item) => item.code == (widget.initialCountryCode ?? 'US'),
        orElse: () => _countryList.first,
      );
    }

    widget.controller?.text = _selectedCountry.name;

    if (widget.autovalidateMode == AutovalidateMode.always) {
      if (widget.validator != null) {
        final x = widget.validator?.call(widget.initialValue);
        if (x is String) {
          setState(() => _validationMessage = x);
        } else {
          // ignore: cast_nullable_to_non_nullable
          (x as Future).then(
            (dynamic msg) => setState(() => _validationMessage = msg as String),
          );
        }
      }
    }
  }

  Future<void> _changeCountry() async {
    _filteredCountries = _countryList;
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = topSafeAreaPadding;

    // final _shadow = shadow ?? _kDefaultBoxShadow;
    //     BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 5);
    final _backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    await showModalBottomSheet<Country>(
      // barrierColor: Colors.black12,
      backgroundColor: _backgroundColor,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => SafeArea(
          minimum: EdgeInsets.only(top: topSafeAreaPadding + 70),
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                width: double.infinity,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true, //Remove top Safe Area
                  child: CountryPickerDialog(
                    isCountryPicker: true,
                    style: widget.pickerDialogStyle,
                    filteredCountries: _filteredCountries,
                    countryList: _countryList,
                    selectedCountry: _selectedCountry,
                    onCountryChanged: (Country country) {
                      _selectedCountry = country;
                      widget.onCountryChanged?.call(country);
                      widget.controller?.text = country.name;
                      // setState(() {});
                      widget.focusNode?.unfocus();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      context: context,
      shape: Theme.of(context).bottomSheetTheme.shape,
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (widget.controller == null) ? _number : null,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      cursorColor: widget.cursorColor,
      onTap: _changeCountry,
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      showCursor: widget.showCursor,
      onFieldSubmitted: widget.onSubmitted,
      decoration: widget.decoration.copyWith(
        prefix: SizedBox(height: 16, child: _buildFlagsButton()),
        counterText: !widget.enabled ? '' : null,
        suffixIcon: widget.showDropdownIcon
            ? const SizedBox(
                height: 24,
                child: Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 24,
                ),
              )
            : null,
        // prefixIconConstraints: const BoxConstraints(maxHeight: 10),
      ),
      // style: widget.style,
      onSaved: (value) {
        widget.onSaved?.call(
          Country(
            name: _selectedCountry.name,
            flag: _selectedCountry.flag,
            code: _selectedCountry.code,
            dialCode: _selectedCountry.dialCode,
            minLength: _selectedCountry.minLength,
            maxLength: _selectedCountry.maxLength,
          ),
        );
      },
      validator: (value) => _validationMessage,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      keyboardAppearance: widget.keyboardAppearance,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
    );
  }

  DecoratedBox _buildFlagsButton() {
    return DecoratedBox(
      decoration: widget.dropdownDecoration,
      child: InkWell(
        borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
        onTap: widget.enabled ? _changeCountry : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (widget.showCountryFlag) ...[
              Image.asset(
                'assets/flags/${_selectedCountry.code.toLowerCase()}.png',
                package: 'app_form_fields',
                width: widget.flagWidth,
                height: 18,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
