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

// Fungsi ini opsional, tapi jika tetap ingin menerima String:
// Mengubah string yyyy-MM-dd ke DateTime object
DateTime createDateTimeObject(String dateString) {
  return DateTime.parse(dateString); // Asumsikan format yyyy-MM-dd
}
