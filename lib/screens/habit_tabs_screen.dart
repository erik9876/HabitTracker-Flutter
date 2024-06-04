import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_manager.dart';
import 'package:habit_tracker/screens/habit_detail_screen.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';

class HabitTabsScreen extends StatefulWidget {
  final int initialIndex;

  const HabitTabsScreen({super.key, required this.initialIndex});

  @override
  State<HabitTabsScreen> createState() => _HabitTabsScreenState();
}

class _HabitTabsScreenState extends State<HabitTabsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    List<Habit> habits = await HabitManager().getHabits();
    setState(() {
      _habits = habits;
      _updateTabController();
    });
  }

  void _updateTabController() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _tabController = TabController(
      length: _habits.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {}); // Ensure state updates immediately
  }

  @override
  void didUpdateWidget(HabitTabsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTabController();
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _navigateToListScreen() {
    Navigator.of(context).pop('reload');
  }

  @override
  Widget build(BuildContext context) {
    if (_habits.isEmpty || _tabController == null) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          title: const Text('Habit Tracker'),
        ),
        body: const Center(
          child: HabitListScreen(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _habits.map((habit) {
                return Center(
                  child: HabitDetailScreen(habit: habit),
                );
              }).toList(),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_habits.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          _tabController!.animateTo(index);
                        },
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: _tabController!.index == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    );
                  }),
                ),
                Positioned(
                  right: 16.0,
                  child: GestureDetector(
                    onTap: _navigateToListScreen,
                    child: const Icon(
                      Icons.list,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
