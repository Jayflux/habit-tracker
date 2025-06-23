// lib/data/habit_databases.dart
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:mysql1/mysql1.dart';

class HabitDatabases {
  static final HabitDatabases _instance = HabitDatabases._internal();
  factory HabitDatabases() => _instance;
  HabitDatabases._internal();

  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  late MySqlConnection _connection;

  Future<void> init() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'habits_admin',
      db: 'habits',
      password: 'admin123',
      timeout: Duration(seconds: 3600),
    ));
  }

  Future<void> createDefaultData(int userId) async {
    todaysHabitList = [
      ["Read", false],
      ["Run", false],
    ];

    final startDate = todaysDateFormatted();

    // Cek apakah data habit untuk hari ini sudah ada
    final checkHabit = await _connection.query(
      'SELECT 1 FROM habits WHERE user_id = ? AND date = ?',
      [userId, startDate],
    );

    if (checkHabit.isEmpty) {
      for (var habit in todaysHabitList) {
        await _connection.query(
          'INSERT INTO habits (user_id, date, name, completed) VALUES (?, ?, ?, ?)',
          [userId, startDate, habit[0], habit[1] ? 1 : 0],
        );
      }
    }
  }

  Future<void> loadData(int userId) async {
    final date = todaysDateFormatted();
    final result = await _connection.query(
      'SELECT name, completed FROM habits WHERE date = ? AND user_id = ?',
      [date, userId],
    );

    if (result.isEmpty) {
      final currentResult = await _connection.query(
        'SELECT DISTINCT name FROM habits WHERE user_id = ? ORDER BY id ASC',
        [userId],
      );
      todaysHabitList = currentResult.map((row) => [row[0], false]).toList();
    } else {
      todaysHabitList = result.map((row) => [row[0], row[1] == 1]).toList();
    }
  }

  Future<void> updateDatabase(int userId) async {
    final date = todaysDateFormatted();

    await _connection.query(
      'DELETE FROM habits WHERE date = ? AND user_id = ?',
      [date, userId],
    );

    for (var habit in todaysHabitList) {
      await _connection.query(
        'INSERT INTO habits (user_id, date, name, completed) VALUES (?, ?, ?, ?)',
        [userId, date, habit[0], habit[1] ? 1 : 0],
      );
    }

    await loadHeatMap(userId);
  }

  Future<void> loadHeatMap(int userId) async {
    // Ambil start_date dari tabel users
    final startDateResult = await _connection.query(
      'SELECT start_date FROM users WHERE id = ?',
      [userId],
    );

    if (startDateResult.isEmpty) return;

    // Ambil nilai dari hasil query
    final rawDate = startDateResult.first[0];
    late DateTime startDate;

    // Deteksi apakah tipe data hasil query sudah DateTime atau String
    if (rawDate is DateTime) {
      startDate = rawDate;
    } else if (rawDate is String) {
      startDate = DateTime.parse(rawDate);
    } else {
      throw Exception(
          "Invalid date format from database: ${rawDate.runtimeType}");
    }

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // Iterasi dari startDate hingga hari ini
    for (int i = 0; i <= daysInBetween; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String dateStr =
          convertDateTimeToString(currentDate); // format: yyyy-MM-dd

      // Ambil persentase dari VIEW daily_habit_percentage
      final percentResult = await _connection.query(
        'SELECT percentage FROM daily_habit_percentage WHERE date = ? AND user_id = ?',
        [dateStr, userId],
      );

      double strength = 0.0;
      if (percentResult.isNotEmpty) {
        strength = double.parse(percentResult.first[0].toString());
      }

      final percentForEachDay = <DateTime, int>{
        DateTime(currentDate.year, currentDate.month, currentDate.day):
            (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  Future<bool> register(String username, String email, String password,
      String? phoneNumber, String? fullName) async {
    try {
      var results = await _connection.query(
        'INSERT INTO users (username, email, password, active_flag, phone_number, full_name, start_date) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          username,
          email,
          password,
          true,
          phoneNumber,
          fullName,
          todaysDateFormatted()
        ],
      );
      return results.affectedRows == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      var results = await _connection.query(
        'SELECT id, username FROM users WHERE username = ? AND password = ?',
        [username, password],
      );

      if (results.isNotEmpty) {
        final row = results.first;
        return {'id': row['id'], 'username': row['username']};
      } else {
        return null;
      }
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final results = await _connection.query(
      'SELECT id, username, email, active_flag, phone_number, full_name FROM users',
    );
    return results
        .map((row) => {
              'id': row['id'],
              'username': row['username'],
              'email': row['email'],
              'active_flag': row['active_flag'],
              'phone_number': row['phone_number'],
              'full_name': row['full_name'],
            })
        .toList();
  }

  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    final result = await _connection.query(
      'SELECT id, username, email, active_flag, phone_number, full_name FROM users WHERE id = ?',
      [userId],
    );

    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'id': row['id'],
        'username': row['username'],
        'email': row['email'],
        'active_flag': row['active_flag'] == 1,
        'phone_number': row['phone_number'],
        'full_name': row['full_name'],
      };
    }
    return null;
  }

  Future<bool> deleteUser(int userId) async {
    try {
      var results = await _connection.query(
        'DELETE FROM users WHERE id = ?',
        [userId],
      );
      return results.affectedRows == 1;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<bool> toggleUserActiveStatus(int userId, bool newStatus) async {
    try {
      var results = await _connection.query(
        'UPDATE users SET active_flag = ? WHERE id = ?',
        [newStatus ? 1 : 0, userId],
      );
      return results.affectedRows == 1;
    } catch (e) {
      print('Error updating active status: $e');
      return false;
    }
  }
}
