import 'package:intl/intl.dart';


// Formats a DateTime object into a simple date string (yyyy-MM-dd).
String formatDate({required DateTime date}) {
  final formattedDate = DateFormat('yyyy-MM-dd').format(date);

  return formattedDate;
}
