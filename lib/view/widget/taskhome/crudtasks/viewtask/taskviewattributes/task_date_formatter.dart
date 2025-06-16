import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskDateFormatter {
  String format(String? date) {
    if (date == null || date == "Not Set" || date.isEmpty) {
      return "166".tr; // Use translation for "Not Set"
    }

    try {
      // Parse ISO8601 string
      final dateTime = DateTime.parse(date);
      // Format to a readable format, e.g., "2025-05-02 at 10:30"
      final formattedTime =
          DateFormat('yyyy-MM-dd \'at\' h:mm a').format(dateTime);
      return "$formattedTime";
    } catch (e) {
      print("Error formatting date: $date, error: $e");
      return "166".tr; // Fallback for invalid date strings
    }
  }
}
