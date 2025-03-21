// lib/models/daily_report.dart

class DailyReport {
  final String id;
  final String reportDate;
  final String mechanicId;
  final Map<String, dynamic> mechanic;
  final String? reviewedById;
  final Map<String, dynamic>? reviewedBy;
  final String status;
  final int totalRegularMinutes;
  final int totalOvertimeMinutes;
  final int totalDelayMinutes;
  final String? reviewNotes;
  final String? weeklyGoals;
  final List<dynamic> timeEntries;
  final List<dynamic> issues;
  final List<dynamic> materialRequests;
  List<dynamic> _taskCategories = [];

  DailyReport({
    required this.id,
    required this.reportDate,
    required this.mechanicId,
    required this.mechanic,
    this.reviewedById,
    this.reviewedBy,
    required this.status,
    required this.totalRegularMinutes,
    required this.totalOvertimeMinutes,
    required this.totalDelayMinutes,
    this.reviewNotes,
    this.weeklyGoals,
    required this.timeEntries,
    required this.issues,
    required this.materialRequests,
  }) {
    // Process timeEntries to create taskCategories
    _processTaskCategories();
  }

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      id: json['id'] ?? '',
      reportDate: json['reportDate'] ?? '',
      mechanicId: json['mechanicId'] ?? '',
      mechanic: json['mechanic'] ?? {},
      reviewedById: json['reviewedById'],
      reviewedBy: json['reviewedBy'],
      status: json['status'] ?? 'DRAFT',
      totalRegularMinutes: json['totalRegularMinutes'] ?? 0,
      totalOvertimeMinutes: json['totalOvertimeMinutes'] ?? 0,
      totalDelayMinutes: json['totalDelayMinutes'] ?? 0,
      reviewNotes: json['reviewNotes'],
      weeklyGoals: json['weeklyGoals'],
      timeEntries: json['timeEntries'] ?? [],
      issues: json['issues'] ?? [],
      materialRequests: json['materialRequests'] ?? [],
    );
  }

  void _processTaskCategories() {
    // Create a map to group timeEntries by taskCategoryId
    final Map<String, Map<String, dynamic>> categories = {};
    
    for (final entry in timeEntries) {
      final categoryId = entry['taskCategoryId'] ?? 'unknown';
      final category = entry['taskCategory'];
      
      if (category != null) {
        if (!categories.containsKey(categoryId)) {
          categories[categoryId] = {
            'id': categoryId,
            'name': category['name'] ?? 'Unknown Category',
            'timeEntries': [],
          };
        }
        
        categories[categoryId]!['timeEntries'].add(entry);
      }
    }
    
    // Convert the map to a list
    _taskCategories = categories.values.toList();
  }

  List<dynamic> get taskCategories => _taskCategories;

  String get regularHoursFormatted {
    final hours = totalRegularMinutes ~/ 60;
    final minutes = totalRegularMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get overtimeHoursFormatted {
    final hours = totalOvertimeMinutes ~/ 60;
    final minutes = totalOvertimeMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get totalHoursFormatted {
    final totalMinutes = totalRegularMinutes + totalOvertimeMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get mechanicName {
    if (mechanic.isEmpty) return 'Unknown';
    return '${mechanic['firstName'] ?? ''} ${mechanic['lastName'] ?? ''}';
  }
}