// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

///Dialog picker style.
class PickerDialogStyle {
  ///
  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
  });

  ///Background color of the dialog.
  final Color? backgroundColor;

  ///TextStyle of the country code text.
  final TextStyle? countryCodeStyle;

  ///Text style of the country name.
  final TextStyle? countryNameStyle;

  ///[Divider] widget.
  final Widget? listTileDivider;

  ///[ListTile] contentPadding
  final EdgeInsets? listTilePadding;

  ///Padding
  final EdgeInsets? padding;

  ///Color for searchfield cursor
  final Color? searchFieldCursorColor;

  ///InputDecoration for search field.
  final InputDecoration? searchFieldInputDecoration;

  ///Padding for search field.
  final EdgeInsets? searchFieldPadding;
}

///Country picker dialog
///
class CountryPickerDialog extends StatefulWidget {
  ///
  const CountryPickerDialog({
    Key? key,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    required this.isCountryPicker,
    this.focusSearchField = false,
    this.style,
  }) : super(key: key);

  ///List of countries.
  final List<Country> countryList;

  ///Default selected country.
  final Country selectedCountry;

  ///Action for when the country is selected.
  final ValueChanged<Country> onCountryChanged;

  ///List of countries matching a search.
  final List<Country> filteredCountries;

  /// [PickerDialogStyle] for the dialog.
  final PickerDialogStyle? style;

  /// If true, the picker hides country phone code.
  final bool isCountryPicker;

  /// if true, focus is given to the search field
  final bool focusSearchField;

  @override
  CountryPickerDialogState createState() => CountryPickerDialogState();
}

///
class CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;
  late InputDecoration _searchFieldInputDecoration;

  ///Focus node for the dialog search field.
  final focusNode = FocusNode();

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;
    _searchFieldInputDecoration = widget.style?.searchFieldInputDecoration ??
        const InputDecoration(
          suffixIcon: Icon(Icons.search),
          labelText: 'Find a country',
        );
    if (!focusNode.hasFocus && widget.focusSearchField) {
      focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.lg),
          child: Container(
            color: widget.style?.backgroundColor ??
                Theme.of(context).dialogBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: widget.style?.padding ?? const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Choose a Country',
                      textAlign: TextAlign.center,
                    ).h5(),
                    VSpace.lg,
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredCountries.length,
                        itemBuilder: (ctx, index) => Column(
                          children: <Widget>[
                            ListTile(
                              dense: true,
                              leading: Image.asset(
                                'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                                package: 'app_core',
                                width: 32,
                              ),
                              // contentPadding: widget.style?.listTilePadding ?? EdgeInsets.symmetric(vertical: 5),
                              title: Text(
                                _filteredCountries[index].name,
                                // style: widget.style?.countryNameStyle ?? TextStyle(fontWeight: FontWeight.w600),
                              ),
                              trailing: (widget.isCountryPicker)
                                  ? null
                                  : Text(
                                      '+${_filteredCountries[index].dialCode}',
                                      style: widget.style?.countryCodeStyle ??
                                          const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                              onTap: () {
                                _selectedCountry = _filteredCountries[index];
                                widget.onCountryChanged(_selectedCountry);

                                Navigator.of(context).pop(_selectedCountry);
                              },
                            ),
                            widget.style?.listTileDivider ??
                                const Divider(thickness: 1),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding:
                          widget.style?.searchFieldPadding ?? EdgeInsets.zero,
                      child: TextField(
                        focusNode: focusNode,
                        cursorColor: widget.style?.searchFieldCursorColor,
                        decoration: _searchFieldInputDecoration,
                        onChanged: (value) {
                          _filteredCountries = isNumeric(value)
                              ? widget.countryList
                                  .where(
                                    (country) =>
                                        country.dialCode.contains(value),
                                  )
                                  .toList()
                              : widget.countryList
                                  .where(
                                    (country) => country.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                          if (mounted) setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
