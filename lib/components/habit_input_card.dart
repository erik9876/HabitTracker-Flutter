import 'package:flutter/material.dart';

class HabitInputCard extends StatelessWidget {
  final TextEditingController habitNameController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const HabitInputCard({
    super.key,
    required this.habitNameController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: TextField(
              controller: habitNameController,
              decoration: const InputDecoration(
                hintText: 'Enter habit name',
                border: InputBorder.none,
              ),
              autofocus: true,
              onSubmitted: (value) {
                onSave();
              },
            ),
          ),
        ),
      ),
    );
  }
}
