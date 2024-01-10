// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

class StringUtils {
  static bool isEmpty(String? s) => s == null || s.trim().isEmpty;
  static bool isNotEmpty(String? s) => !isEmpty(s);

  static bool isEmail(String? value) {
    if (isEmpty(value)) return false;
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value!);
  }

  // Measures text using an off-screen canvas. It's not fast, but not overly slow either. Use with (mild) caution :)
  static Size measure(
    String text,
    TextStyle style, {
    int maxLines = 1,
    TextDirection direction = TextDirection.ltr,
    double maxWidth = double.infinity,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: direction,
    )
      // ignore: avoid_redundant_argument_values
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  // Measures longest text item in a list of Strings. Useful for things like Dropdown Menu, where you just want to take up as much space as the content requires.
  static double measureLongest(
    List<String> items,
    TextStyle style, [
    int? maxItems,
  ]) {
    // ignore: omit_local_variable_types
    double l = 0;
    if (maxItems != null && maxItems < items.length) {
      items.length = maxItems;
    }
    for (final item in items) {
      final m = measure(item, style).width;
      if (m > l) l = m;
    }
    return l;
  }

  /// Gracefully handles null values, and skips the suffix when null
  static String safeGet(String? value, [String? suffix]) {
    return (value ?? '') + (!isEmpty(value) ? suffix ?? '' : '');
  }

  static String pluralize(String s, int length) {
    if (length == 1) return s;
    return '${s}s';
  }

  static String titleCaseSingle(String s) =>
      '${s[0].toUpperCase()}${s.substring(1)}';
  static String titleCase(String s) =>
      s.split(' ').map(titleCaseSingle).join(' ');

  static String defaultOnEmpty(String? value, String defaultValue) =>
      isEmpty(value) ? defaultValue : value!;

  static String getInitials(String string, [int limitTo = 2]) {
    if (string.isEmpty) {
      return '';
    }
    final str = string.replaceAll(RegExp('[^A-Za-z0-9]'), ' ');

    final buffer = StringBuffer();
    final strSplit = str.split(' ');

    final split = strSplit.where((element) => element.isNotEmpty).toList();

    //For one word
    if (split.length == 1) {
      return string.substring(0, 1);
    }

    for (var i = 0; i < limitTo; i++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }
}
