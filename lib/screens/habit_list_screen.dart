import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_card.dart';
import 'package:habit_tracker/components/habit_input_card.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_manager.dart';
import 'package:habit_tracker/screens/habit_tabs_screen.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void _reorderHabits(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Habit habit = habits.removeAt(oldIndex);
      habits.insert(newIndex, habit);
      HabitManager.saveHabitOrder(habits);
    });
  }

  Route _openListScreen(int habitIndex) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HabitTabsScreen(initialIndex: habitIndex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
          titleTextStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        body: ReorderableListView(
          onReorder: _reorderHabits,
          children: [
            if (isAddingNewHabit)
              HabitInputCard(
                key: ValueKey('input_card'),
                habitNameController: _habitNameController,
                onSave: _saveHabit,
                onCancel: _cancelAddHabit,
              ),
            for (int index = 0; index < habits.length; index++)
              Dismissible(
                key: ValueKey(habits[index].id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteHabit(habits[index]);
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
                  onTap: () async {
                    if (!isAddingNewHabit) {
                      var result = await Navigator.of(context)
                          .push(_openListScreen(index));
                      if (result == 'reload') {
                        loadHabits();
                      }
                    } else {
                      _cancelAddHabit();
                    }
                  },
                  child: HabitCard(habit: habits[index]),
                ),
              ),
          ],
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
