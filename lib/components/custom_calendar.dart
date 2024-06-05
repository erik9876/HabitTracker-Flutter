import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final Habit habit;
  final VoidCallback onDayLongPressed;
  final Function(DateTime) onMonthSwitched;

  const CustomCalendar(
      {super.key,
      required this.habit,
      required this.onDayLongPressed,
      required this.onMonthSwitched});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TableCalendar(
          firstDay: DateTime(2020, 1, 1),
          lastDay: DateTime(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            widget.onMonthSwitched(focusedDay);
          },
          onDayLongPressed: (selectedDay, focusedDay) {
            if (!isSameDay(selectedDay, DateTime.now())) {
              widget.habit.togglePastDate(selectedDay);
              widget.onDayLongPressed();
            }
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(color: Colors.white),
            outsideDaysVisible: false,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: false,
            rightChevronVisible: false,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white),
            weekendStyle: TextStyle(color: Colors.white),
          ),
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, date) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      DateFormat('MMMM y').format(_focusedDay),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month - 1,
                            );
                          });
                        },
                        child:
                            const Icon(Icons.chevron_left, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month + 1,
                            );
                          });
                        },
                        child: const Icon(Icons.chevron_right,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            },
            defaultBuilder: (context, date, focusedDay) {
              bool isCompleted = widget.habit.completedDates.any(
                (completedDate) => isSameDay(completedDate, date),
              );

              if (isCompleted) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: widget.habit.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(color: Colors.black),
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
                  decoration: BoxDecoration(
                    color: widget.habit.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
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
        ),
      ),
    );
  }
}
