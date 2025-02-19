class HelperFunctions {
  static String formatTimestamp(int timestamp) {
    // Convert timestamp from milliseconds to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format: YYYY-MM-DD HH:mm:ss
    String formattedDate =
        "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} "
        "${_twoDigits(date.hour)}:${_twoDigits(date.minute)}:${_twoDigits(date.second)}";

    return formattedDate;
  }

// Helper function to ensure two-digit formatting
  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
