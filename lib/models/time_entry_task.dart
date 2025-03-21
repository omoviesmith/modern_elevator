// Create or update in models/time_entry_task.dart

class TimeEntryTask {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final String notes;
  final bool isCurrent;

  TimeEntryTask({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.notes,
    this.isCurrent = false,
  });

  factory TimeEntryTask.fromJson(Map<String, dynamic> json) {
    return TimeEntryTask(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      notes: json['notes'] ?? '',
      isCurrent: json['isCurrent'] ?? false,
    );
  }

  // Calculate duration
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  // Format time range
  String get timeRange {
    final startFormatted = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    if (endTime == null) {
      return '$startFormatted - now';
    }
    final endFormatted = '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
    return '$startFormatted - $endFormatted';
  }
}

class TaskCategoryWithTasks {
  final String id;
  final String name;
  final List<TimeEntryTask> tasks;

  TaskCategoryWithTasks({
    required this.id,
    required this.name,
    required this.tasks,
  });

  factory TaskCategoryWithTasks.fromJson(Map<String, dynamic> json) {
    List<TimeEntryTask> tasks = [];
    if (json['tasks'] != null) {
      tasks = (json['tasks'] as List)
          .map((taskJson) => TimeEntryTask.fromJson(taskJson))
          .toList();
    }
    
    return TaskCategoryWithTasks(
      id: json['id'],
      name: json['name'],
      tasks: tasks,
    );
  }
}