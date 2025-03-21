// lib/models/task_category.dart

// This file will contain the general-purpose task categories and tasks
// that can be assigned to time entries

class TaskCategory {
  final String id;
  final String code;
  final String name;
  final String? description;
  
  TaskCategory({
    required this.id,
    required this.code,
    required this.name,
    this.description,
  });
  
  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    return TaskCategory(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Task {
  final String id;
  final String name;
  final String? description;
  final String categoryId;
  final bool isActive;
  
  Task({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.isActive = true,
  });
  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      isActive: json['isActive'] ?? true,
    );
  }
}