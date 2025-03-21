// lib/utils/time_formatter.dart

class TimeFormatter {
  static String formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  static String formatTimeOfDay(DateTime? time) {
    if (time == null) return 'N/A';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  static DateTime? parseTimeString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }
}