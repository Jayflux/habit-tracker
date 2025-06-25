// lib/datetime/date_time.dart

// Mengembalikan tanggal hari ini dalam format yyyy-MM-dd
String todaysDateFormatted() {
  final now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  return '$year-$month-$day'; // Contoh: 2025-06-23
}

// Konversi objek DateTime ke string dalam format yyyy-MM-dd
String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

// Mengubah string yyyy-MM-dd ke DateTime object
DateTime createDateTimeObject(String dateString) {
  return DateTime.parse(dateString); // Format harus yyyy-MM-dd
}

// ✅ Format custom: Rabu, Jun 25 → untuk label hari
String formatDateLabel(DateTime date) {
  return "${_getWeekday(date.weekday)}, ${_getMonth(date.month)} ${date.day}";
}

// Helper untuk nama hari
String _getWeekday(int weekday) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return weekdays[weekday - 1];
}

// Helper untuk nama bulan
String _getMonth(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}
