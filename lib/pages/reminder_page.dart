import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/datetime/date_time.dart';

class ReminderPage extends StatefulWidget {
  final int userId;

  const ReminderPage({super.key, required this.userId});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final HabitDatabases db = HabitDatabases();
  Map<String, List<String>> reminderData = {};

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    await db.init();
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    final todayStr = convertDateTimeToString(today);
    final tomorrowStr = convertDateTimeToString(tomorrow);

    final todayHabits =
        await db.getIncompleteHabitsByDate(widget.userId, todayStr);
    final tomorrowHabits = await db.getHabitsForTomorrow(widget.userId);

    setState(() {
      reminderData = {
        'Today - ${formatDateLabel(today)}': todayHabits,
        'Tomorrow - ${formatDateLabel(tomorrow)}': tomorrowHabits,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Reminders', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF174E8F)],
          ),
        ),
        child: reminderData.isEmpty
            ? const Center(
                child: Text('No pending habits.',
                    style: TextStyle(color: Colors.white)),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                children: reminderData.entries.map((entry) {
                  final label = entry.key;
                  final habits = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Column(
                          children: habits.map((habit) {
                            return Row(
                              children: [
                                const Icon(Icons.check_box_outline_blank,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    habit,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }
}
