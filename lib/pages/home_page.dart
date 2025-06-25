import "package:flutter/material.dart";
import "package:habit_tracker/components/custom_drawer.dart";
import "package:habit_tracker/components/habit_tile.dart";
import "package:habit_tracker/components/month_summary.dart";
import "package:habit_tracker/components/my_fab.dart";
import "package:habit_tracker/components/my_alert_box.dart";
import "package:habit_tracker/data/habit_databases.dart";
import 'package:habit_tracker/datetime/date_time.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final String username;

  const HomePage({super.key, required this.userId, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HabitDatabases db = HabitDatabases();
  final TextEditingController _newHabitNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    await db.init();
    await db.loadData(widget.userId);

    if (db.todaysHabitList.isEmpty) {
      await db.createDefaultData(widget.userId);
    }

    await db.updateDatabase(widget.userId);

    setState(() {
      isLoading = false;
    });
  }

  void checkBoxTapped(bool? value, int index) async {
    db.todaysHabitList[index][1] = value;
    await db.updateDatabase(widget.userId);
    setState(() {});
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
          hintText: "Enter Habit Name..",
        );
      },
    );
  }

  void saveNewHabit() async {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    await db.updateDatabase(widget.userId);
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  void saveExistingHabit(int index) async {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    await db.updateDatabase(widget.userId);
  }

  void deleteHabit(int index) async {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    await db.updateDatabase(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        username: widget.username,
        userId: widget.userId,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: MyFloatingActionButton(onPressed: createNewHabit),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF174E8F)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  children: [
                    // Sidebar Icon
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 8),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 80),
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Weekly Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MonthlySummary(
                              datasets: db.heatMapDataSet,
                              startDate:
                                  convertDateTimeToString(DateTime.now()),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Today\'s Habits',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: db.todaysHabitList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                return HabitTile(
                                  habitName: db.todaysHabitList[index][0],
                                  habitCompleted: db.todaysHabitList[index][1],
                                  onChanged: (value) =>
                                      checkBoxTapped(value, index),
                                  settingsTapped: (context) =>
                                      openHabitSettings(index),
                                  deleteTapped: (context) => deleteHabit(index),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
