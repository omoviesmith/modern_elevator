// lib/widgets/daily_report/category_section.dart

import 'package:flutter/material.dart';
import '../../utils/time_formatter.dart';

class CategorySection extends StatelessWidget {
  final String categoryName;
  final List<dynamic> timeEntries;
  final Function(dynamic) onEntryTap;

  const CategorySection({
    super.key,
    required this.categoryName,
    required this.timeEntries,
    required this.onEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).primaryColor.withAlpha(25),
            width: double.infinity,
            child: Text(
              categoryName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...timeEntries.map((entry) => _buildTimeEntryTile(context, entry)),
        ],
      ),
    );
  }

  Widget _buildTimeEntryTile(BuildContext context, dynamic entry) {
    final description = entry['description'] ?? 'Unknown Task';
    final durationMinutes = entry['durationMinutes'] ?? 0;
    final isOvertime = entry['isOvertime'] ?? false;
    final taskEntries = entry['taskEntries'] ?? [];

    // Get first and last time to show time range
    DateTime? startTime;
    DateTime? endTime;
    
    if (taskEntries.isNotEmpty) {
      // Sort entries by start time
      taskEntries.sort((a, b) {
        final aTime = TimeFormatter.parseTimeString(a['startTime']);
        final bTime = TimeFormatter.parseTimeString(b['startTime']);
        if (aTime == null || bTime == null) return 0;
        return aTime.compareTo(bTime);
      });
      
      startTime = TimeFormatter.parseTimeString(taskEntries.first['startTime']);
      
      // Find last end time by checking all entries
      for (final task in taskEntries) {
        final taskEndTime = TimeFormatter.parseTimeString(task['endTime']);
        if (taskEndTime != null && (endTime == null || taskEndTime.isAfter(endTime))) {
          endTime = taskEndTime;
        }
      }
    }

    return ListTile(
      title: Text(description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${startTime != null ? TimeFormatter.formatTimeOfDay(startTime) : 'N/A'} - '
                '${endTime != null ? TimeFormatter.formatTimeOfDay(endTime) : 'N/A'}',
              ),
              const SizedBox(width: 10),
              Text(
                TimeFormatter.formatMinutes(durationMinutes),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOvertime ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
          if (taskEntries.isNotEmpty && taskEntries.length > 1)
            Text('${taskEntries.length} detailed tasks', 
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onEntryTap(entry),
    );
  }
}