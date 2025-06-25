import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';

class HistoryPage extends StatefulWidget {
  final int userId;

  const HistoryPage({super.key, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HabitDatabases db = HabitDatabases();
  Map<String, List<String>> historyData = {};

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    await db.init();
    final results = await db.getCompletedHabitsByUser(widget.userId);
    setState(() {
      historyData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: Colors.white)),
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
        child: historyData.isEmpty
            ? const Center(
                child: Text('No history available.',
                    style: TextStyle(color: Colors.white)),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                children: historyData.entries.map((entry) {
                  final date = entry.key;
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
                          date,
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
                                const Icon(Icons.check_box,
                                    color: Colors.lightGreenAccent),
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
                      )
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }
}
