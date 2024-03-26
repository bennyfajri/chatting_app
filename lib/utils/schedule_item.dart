import 'package:chatting_app/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onButtonChange,
    this.onTap,
  });

  final Schedule schedule;
  final Function(bool, String) onButtonChange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.hardEdge,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
            title: Text(DateFormat.Hm().format(schedule.time),
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            trailing:
            Switch(
              value: schedule.isActive,
              onChanged: (value) => onButtonChange(value, schedule.id ?? ""),
            )
        ),
      ),
    );
  }
}
