import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_card.dart';
import 'package:habit_tracker/components/habit_input_card.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/services/habit_manager.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/screens/habit_tabs_screen.dart';
import 'dart:developer';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/screens/habit_settings_screen.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [];
  bool isAddingNewHabit = false;
  final TextEditingController _habitNameController = TextEditingController();

  final IHabitManager _habitManager = getIt<IHabitManager>();

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
    List<Habit> loadedHabits = await _habitManager.getHabits();
    loadedHabits.sort((h1, h2) => h1.position.compareTo(h2.position));
    if (mounted) {
      setState(() {
        habits = loadedHabits;
      });
    }
  }

  void _addHabit() {
    setState(() {
      isAddingNewHabit = true;
      log('Is adding new habit: $isAddingNewHabit');
    });
  }

  void _saveHabit() async {
    if (_habitNameController.text.isNotEmpty) {
      Habit newHabit =
          await _habitManager.create(_habitNameController.text, habits.length);
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

  void _deleteHabit(Habit habit, BuildContext context) async {
    await _habitManager.delete(habit);
    setState(() {
      habits.remove(habit);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${habit.name} dismissed',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
        ),
      );
    });
  }

  void _reorderHabits(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Habit habit = habits.removeAt(oldIndex);
      habits.insert(newIndex, habit);

      for (int i = 0; i < habits.length; i++) {
        _habitManager.updatePosition(habits[i], i);
      }
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Theme.of(context).dialogBackgroundColor,
              expandedHeight: 50.0,
              collapsedHeight: 15,
              toolbarHeight: 15,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    centerTitle: top <= 80,
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: top <= 80 ? 1.0 : 0.0,
                      child: Transform.translate(
                        offset: const Offset(0, 10),
                        child: const Text(
                          'Habit List',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    background: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 13, bottom: 8),
                        child: Text(
                          'Habit List',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: ReorderableListView(
                onReorder: _reorderHabits,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int index = 0; index < habits.length; index++)
                    Slidable(
                      key: ValueKey(habits[index].id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: () =>
                              _deleteHabit(habits[index], context),
                        ),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      HabitSettingsScreen(habit: habits[index]),
                                ),
                              );

                              setState(() {});
                            },
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            icon: CupertinoIcons.settings,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            label: 'Settings',
                          ),
                          SlidableAction(
                            onPressed: (context) =>
                                _deleteHabit(habits[index], context),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: CupertinoIcons.delete,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            label: 'Delete',
                          ),
                        ],
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
                  if (isAddingNewHabit)
                    HabitInputCard(
                      key: const ValueKey('input_card'),
                      habitNameController: _habitNameController,
                      onSave: _saveHabit,
                      onCancel: _cancelAddHabit,
                    ),
                ],
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
