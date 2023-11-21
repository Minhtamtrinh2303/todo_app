import 'package:intl/intl.dart';

extension ExString on String? {
  String toDateTimeFormat() {
    if (this == null) {
      return '--:--';
    }
    try {
      return DateFormat('M/d/yyyy h:mm a', 'en_US')
          .format(DateTime.parse(this!));
    } on FormatException {
      return '--:--';
    }
  }
}
