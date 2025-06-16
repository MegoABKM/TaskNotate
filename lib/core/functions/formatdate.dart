// core/functions/formatdate.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';

String formatDate(String? date, String locale) {
  // Accept locale
  if (date == null || date.isEmpty) return "328".tr;
  try {
    final parsedDate = DateTime.parse(date.trim());
    return DateFormat('yyyy-MM-dd', locale).format(parsedDate); // Pass locale
  } catch (e) {
    return "329".tr;
  }
}

String formatDateTime(String? dateTimeString, String locale) {
  // Accept locale
  if (dateTimeString == null || dateTimeString.isEmpty) return "328".tr;
  try {
    final parsedDateTime = DateTime.parse(dateTimeString.trim());
    // Explicitly use the passed 'locale' for DateFormat
    return DateFormat('dd MMMM yyyy, hh:mm a', locale)
        .format(parsedDateTime); // Pass locale
  } catch (e) {
    print(
        "Error parsing date-time '$dateTimeString' for formatting with locale '$locale': $e");
    return "329".tr;
  }
}
