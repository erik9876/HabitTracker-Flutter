import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_card.dart';
import 'package:habit_tracker/components/habit_input_card.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_manager.dart';
import 'package:habit_tracker/screens/habit_detail_screen.dart';
import 'dart:developer';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [];
  bool isAddingNewHabit = false;
  final TextEditingController _habitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    List<Habit> loadedHabits = await HabitManager.loadHabits();
    setState(() {
      habits = loadedHabits;
    });
  }

  void _addHabit() {
    setState(() {
      isAddingNewHabit = true;
      log('Is adding new habit: $isAddingNewHabit');
    });
  }

  void _saveHabit() async {
    if (_habitNameController.text.isNotEmpty) {
      Habit newHabit = Habit(name: _habitNameController.text);
      await newHabit.saveHabit();
      setState(() {
        habits.add(newHabit);
        isAddingNewHabit = false;
        _habitNameController.clear();
      });
    }
  }

  void _cancelAddHabit() {
    setState(() {
      isAddingNewHabit = false;
      _habitNameController.clear();
    });
  }

  void _deleteHabit(Habit habit) async {
    await habit.deleteHabit();
    setState(() {
      habits.remove(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAddingNewHabit) {
          _cancelAddHabit();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Habit List'),
        ),
        body: ListView.builder(
          itemCount: habits.length + (isAddingNewHabit ? 1 : 0),
          itemBuilder: (context, index) {
            if (isAddingNewHabit && index == 0) {
              return HabitInputCard(
                habitNameController: _habitNameController,
                onSave: _saveHabit,
                onCancel: _cancelAddHabit,
              );
            } else {
              final habitIndex = isAddingNewHabit ? index - 1 : index;
              return Dismissible(
                key: ValueKey(habits[habitIndex].id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteHabit(habits[habitIndex]);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (!isAddingNewHabit) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HabitDetailScreen(habit: habits[habitIndex]),
                        ),
                      );
                    } else {
                      _cancelAddHabit();
                    }
                  },
                  child: HabitCard(habit: habits[habitIndex]),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addHabit,
          tooltip: 'Add Habit',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
