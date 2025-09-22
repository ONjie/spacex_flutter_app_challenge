import 'package:intl/intl.dart';


// Formats a launch DateTime to a readable string including time.
String formatLaunchDate({required DateTime dateTime}) {
    final formatter = DateFormat("MMM d, yyyy 'at' hh:mm a");
    return formatter.format(dateTime.toLocal());
  }