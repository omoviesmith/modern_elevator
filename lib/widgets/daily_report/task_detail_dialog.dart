// lib/widgets/daily_report/task_detail_dialog.dart

import 'package:flutter/material.dart';
import '../../utils/time_formatter.dart';

class TaskDetailDialog extends StatelessWidget {
  final dynamic timeEntry;
  final Function(dynamic, Map<String, dynamic>)? onUpdate;

  const TaskDetailDialog({
    Key? key,
    required this.timeEntry,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectName = timeEntry['project']?['name'] ?? 'Unknown Project';
    final elevatorName = timeEntry['elevator']?['name'] ?? 'Unknown Elevator';
    final description = timeEntry['description'] ?? 'Unknown Task';
    final taskEntries = timeEntry['taskEntries'] ?? [];
    final taskCategoryName = timeEntry['taskCategory']?['name'] ?? 'Unknown Category';
    final durationMinutes = timeEntry['durationMinutes'] ?? 0;
    final isOvertime = timeEntry['isOvertime'] ?? false;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _infoRow('Project:', projectName),
              _infoRow('Elevator:', elevatorName),
              _infoRow('Category:', taskCategoryName),
              _infoRow(
                'Duration:',
                TimeFormatter.formatMinutes(durationMinutes),
                valueStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOvertime ? Colors.orange : Colors.green,
                ),
              ),
              const Divider(height: 24),
              const Text(
                'Detailed Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...taskEntries.map((task) => _buildTaskEntryTile(context, task)).toList(),
              const SizedBox(height: 16),
              if (onUpdate != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: () => _showEditDialog(context),
                  child: const Text('Edit Entry'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskEntryTile(BuildContext context, dynamic taskEntry) {
    final taskName = taskEntry['task']?['name'] ?? 'Unknown Task';
    final startTime = TimeFormatter.parseTimeString(taskEntry['startTime']);
    final endTime = TimeFormatter.parseTimeString(taskEntry['endTime']);
    final durationMinutes = taskEntry['durationMinutes'] ?? 0;
    final notes = taskEntry['notes'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${startTime != null ? TimeFormatter.formatTimeOfDay(startTime) : 'N/A'} - '
                  '${endTime != null ? TimeFormatter.formatTimeOfDay(endTime) : 'N/A'}',
                ),
                const SizedBox(width: 10),
                Text(
                  TimeFormatter.formatMinutes(durationMinutes),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (notes != null && notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Notes: $notes',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // This would be implemented to allow editing of the time entry
    // For now, it's just a placeholder that would be expanded upon
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Time Entry'),
        content: const Text('Editing functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Example of how to call the update function
              if (onUpdate != null) {
                // For example, update the description
                onUpdate!(timeEntry, {'description': 'Updated Description'});
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close both dialogs
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}