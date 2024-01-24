// ignore_for_file: lines_longer_than_80_chars

import 'package:intl/intl.dart';

String convertToAgo(DateTime input) {
  final diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} ${Intl.plural(diff.inDays, one: 'day', other: ' days')} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} ${Intl.plural(diff.inHours, one: 'hour', other: ' hours')} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes}${Intl.plural(diff.inMinutes, one: ' minute', other: ' minutes')} ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} ${Intl.plural(diff.inSeconds, one: 'second', other: 'seconds')} ago';
  } else {
    return 'just now';
  }
}
