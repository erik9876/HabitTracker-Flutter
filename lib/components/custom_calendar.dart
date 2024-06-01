import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/data/models/habit.dart';

class CustomCalendar extends StatefulWidget {
  final Habit habit;

  const CustomCalendar({super.key, required this.habit});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, focusedDay) {
          bool isCompleted = widget.habit.completedDates.any(
            (completedDate) => isSameDay(completedDate, date),
          );

          if (isCompleted) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, date, focusedDay) {
          bool isCompleted = widget.habit.completedDates.any(
            (completedDate) => isSameDay(completedDate, date),
          );

          if (isCompleted) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
