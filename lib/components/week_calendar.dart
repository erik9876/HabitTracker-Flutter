import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/data/models/habit.dart';

class WeekCalendar extends StatefulWidget {
  final Habit habit;

  const WeekCalendar({
    super.key,
    required this.habit,
  });

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  final DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - DateTime.monday));
  final DateTime _lastDay = DateTime.now()
      .add(Duration(days: DateTime.sunday - DateTime.now().weekday));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      color: Colors.transparent,
      child: SizedBox(
        height: 25,
        child: TableCalendar(
          shouldFillViewport: true,
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          daysOfWeekVisible: false,
          availableCalendarFormats: const {
            CalendarFormat.week: 'Week',
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.rectangle,
            ),
            outsideDaysVisible: false,
            cellMargin: const EdgeInsets.all(0),
            tablePadding: const EdgeInsets.only(left: 16, right: 30),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white),
            weekendStyle: TextStyle(color: Colors.white),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, focusedDay) {
              bool isCompleted = widget.habit.isDateCompleted(date);
              bool isFirstDay = isSameDay(date, _firstDay);
              bool isLastDay = isSameDay(date, _lastDay);
              bool isFuture = focusedDay.isBefore(date);

              return Container(
                decoration: BoxDecoration(
                  color: isCompleted
                      ? widget.habit.color
                      : Colors.white.withOpacity(.1),
                  shape: BoxShape.rectangle,
                  borderRadius: isFirstDay
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )
                      : (isLastDay
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                          : null),
                ),
                child: Center(
                  child: Text(
                    DateFormat('EE').format(date),
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.black
                          : (isFuture
                              ? Colors.white.withOpacity(.3)
                              : Colors.white),
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, date, focusedDay) {
              bool isCompleted = widget.habit.isDateCompleted(date);
              bool isFirstDay = isSameDay(date, _firstDay);
              bool isLastDay = isSameDay(date, _lastDay);

              return Container(
                decoration: BoxDecoration(
                  color: isCompleted
                      ? widget.habit.color
                      : Colors.white.withOpacity(.1),
                  shape: BoxShape.rectangle,
                  borderRadius: isFirstDay
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )
                      : (isLastDay
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                          : null),
                ),
                child: Center(
                  child: Text(
                    DateFormat('EE').format(date),
                    style: TextStyle(
                      color: isCompleted ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
