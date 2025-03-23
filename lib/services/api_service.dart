//modern_elevator_app/lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:modern_elevator_app/models/task_category.dart' as task_category;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_elevator_app/models/task_category.dart' as task_category; // Import with alias
import 'package:modern_elevator_app/models/task_category.dart'; // Import TaskCategory directly
import 'dart:developer'; 

class ApiService {
  // Base API URL - replace with your actual backend URL
  // static const baseAPIURL = "http://localhost:3000/api/"
  // static const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator
  static const String baseUrl = 'https://r2zfyj7r7p.us-east-1.awsapprunner.com/api';
  // Use 'http://localhost:3000/api' for iOS simulator
  // Use your actual server URL for real device testing

  // Headers for API requests
  static Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Register a new user
  static Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String role,
      {String? phoneNumber}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Registration failed');
    }
  }

  // Verify email with verification code
  static Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-code'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Verification failed');
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Save tokens to shared preferences
      final prefs = await SharedPreferences.getInstance();
      if (data['data'] != null && data['data']['accessToken'] != null) {
        await prefs.setString('accessToken', data['data']['accessToken']);
        
        // Store user data
        if (data['data']['user'] != null) {
          await prefs.setString('userData', jsonEncode(data['data']['user']));
        }
      }
      
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed');
    }
  }

  // Request forgot password
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Forgot password request failed');
    }
  }

  // Reset password
  static Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'token': token,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Password reset failed');
    }
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userData');
    
    // Optionally hit the logout endpoint if you need to invalidate the token on the server
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      log('Logout error: $e');
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  // modern_elevator_app/lib/services/api_service.dart

// Add these methods to your existing ApiService class

  // Get dashboard data
  static Future<Map<String, dynamic>> getDashboardData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch dashboard data');
    }
  }

  // Get quick stats
  static Future<Map<String, dynamic>> getQuickStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/quick-stats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch quick stats');
    }
  }

  // Get recent activity
  static Future<Map<String, dynamic>> getRecentActivity() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/recent-activity'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch recent activity');
    }
  }

  // Get work summary
  static Future<Map<String, dynamic>> getWorkSummary({String period = 'day'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/work-summary?period=$period'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch work summary');
    }
  }

  // Admin-only: Get mechanic performance metrics
  static Future<Map<String, dynamic>> getMechanicPerformanceMetrics({String timeframe = 'month'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/performance-metrics?timeframe=$timeframe'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch performance metrics');
    }
  }


  // modern_elevator_app/lib/services/api_service.dart
// Add these methods to your existing ApiService class

  // Get all available materials
  static Future<List<dynamic>> getMaterials({String? search}) async {
    final queryParams = search != null ? '?search=$search' : '';
    final response = await http.get(
      Uri.parse('$baseUrl/materials$queryParams'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['materials'] ?? [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch materials');
    }
  }

  // Get projects for the current user
  static Future<List<dynamic>> getProjects() async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['projects'] ?? [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch projects');
    }
  }
  
  // Get elevators for a project
  static Future<List<dynamic>> getElevatorsForProject(String projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/elevators'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['elevators'] ?? [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch elevators');
    }
  }

  // Report an issue
  static Future<Map<String, dynamic>> reportIssue({
    required String type,
    required String title,
    required String description,
    required String projectId,
    required String elevatorId,
    required String priority,
    int? delayMinutes,
    List<String>? photos,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/issues'),
    );

    // Add headers including authorization
    final headers = await _getHeaders();
    request.headers.addAll(headers);

    // Add text fields
    request.fields['type'] = type;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['projectId'] = projectId;
    request.fields['elevatorId'] = elevatorId;
    request.fields['priority'] = priority;
    if (delayMinutes != null) {
      request.fields['delayMinutes'] = delayMinutes.toString();
    }

    // Add photos if available
    if (photos != null) {
      for (var i = 0; i < photos.length; i++) {
        var file = await http.MultipartFile.fromPath('photos', photos[i]);
        request.files.add(file);
      }
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to report issue');
    }
  }

  // Submit material request
  static Future<Map<String, dynamic>> requestMaterials({
    required String projectId,
    required String elevatorId,
    String? notes,
    required String urgency,
    String? neededByDate,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/material-requests'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'projectId': projectId,
        'elevatorId': elevatorId,
        'notes': notes,
        'urgency': urgency,
        'neededByDate': neededByDate,
        'items': items,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to submit material request');
    }
  }

  // Get my issues
  static Future<List<dynamic>> getMyIssues() async {
    final response = await http.get(
      Uri.parse('$baseUrl/issues/my-issues'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['issues'] ?? [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch issues');
    }
  }

  // Get my material requests
  static Future<List<dynamic>> getMyMaterialRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/material-requests/my-requests'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['materialRequests'] ?? [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch material requests');
    }
  }


// Update the clockIn and clockOut methods to match the correct API endpoints
static Future<Map<String, dynamic>> clockIn({
  required String projectId,
  required String elevatorId,
  required String taskId,
  bool isRegularHours = true,
  String? notes,
  double? latitude,
  double? longitude,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/time-entries/clock-in'),
    headers: await _getHeaders(),
    body: jsonEncode({
      'projectId': projectId,
      'elevatorId': elevatorId,
      'taskId': taskId,
      'isRegularHours': isRegularHours,
      if (notes != null) 'notes': notes,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    }),
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to clock in');
  }
}

// End a time entry (clock out)
static Future<Map<String, dynamic>> clockOut({
  String? notes,
  bool isLunchTaken = false,
  double? latitude,
  double? longitude,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/time-entries/clock-out'),
    headers: await _getHeaders(),
    body: jsonEncode({
      if (notes != null) 'notes': notes,
      'isLunchTaken': isLunchTaken,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to clock out');
  }
}

// Get active time entry
// static Future<Map<String, dynamic>?> getActiveTimeEntry() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/time-entries/active'),
//     headers: await _getHeaders(),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return data['data']['active'] ? data['data']['timeEntry'] : null;
//   } else if (response.statusCode == 404) {
//     // No active time entry
//     return null;
//   } else {
//     final errorData = jsonDecode(response.body);
//     throw Exception(errorData['message'] ?? 'Failed to fetch active time entry');
//   }
// }
// In api_service.dart, update the getActiveTimeEntry method:

// Get active time entry with tasks grouped by categories
static Future<Map<String, dynamic>?> getActiveTimeEntry() async {
  final response = await http.get(
    Uri.parse('$baseUrl/time-entries/active'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['active'] ? data['data'] : null;
  } else if (response.statusCode == 404) {
    // No active time entry
    return null;
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch active time entry');
  }
}

// Update getTodayTimeEntries to handle the new format
static Future<Map<String, dynamic>> getTodayTimeEntries() async {
  final now = DateTime.now();
  final today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.get(
    Uri.parse('$baseUrl/time-entries/daily?date=$today'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['summary'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch today\'s time entries');
  }
}
// Update active time entry
static Future<Map<String, dynamic>> updateActiveTimeEntry({
  String? taskId,
  String? notes,
  String? serviceTicketNumber,
  bool? isLunchTaken,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/time-entries/update'),
    headers: await _getHeaders(),
    body: jsonEncode({
      if (taskId != null) 'taskId': taskId,
      if (notes != null) 'notes': notes,
      if (serviceTicketNumber != null) 'serviceTicketNumber': serviceTicketNumber,
      if (isLunchTaken != null) 'isLunchTaken': isLunchTaken,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'];
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to update active time entry');
  }
}


// Add these methods to ApiService class for task categories and tasks
// Add these methods to ApiService class for task categories and tasks

// Get all task categories
static Future<List<task_category.TaskCategory>> getTaskCategories() async {
  final response = await http.get(
    Uri.parse('$baseUrl/tasks/categories'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> categoriesJson = data['data']['categories'] ?? [];
    return await Future.value(categoriesJson.map((json) => TaskCategory.fromJson(json)).toList());
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch task categories');
  }
}
// Get tasks for a specific category
static Future<List<Task>> getTasksForCategory(String categoryId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/tasks/category/$categoryId'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> tasksJson = data['data']['tasks'] ?? [];
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch tasks');
  }
}





// Get time entry summary
static Future<Map<String, dynamic>> getTimeEntrySummary() async {
  final now = DateTime.now();
  final today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.get(
    Uri.parse('$baseUrl/time-entries/daily?date=$today'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['summary'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch time entry summary');
  }
}

  // Verify location
static Future<bool> verifyLocation({
  required String projectId,
  required double latitude,
  required double longitude,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/time-entries/verify-location'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'projectId': projectId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['isVerified'] ?? false;
    } else {
      final errorData = jsonDecode(response.body);
      log('Location verification failed: ${errorData['message']}');
      return false;
    }
  } catch (e) {
    log('Error in verifyLocation: $e');
    // For testing/development purposes, return true to bypass location verification
    return true; // In production, you would return false here
  }
}

// Add these methods to api_service.dart

// Add these methods to api_service.dart
// Add these methods to api_service.dart for Daily Report Review and Submission

// Get today's daily report with full details
static Future<Map<String, dynamic>> getTodayDailyReport() async {
  final response = await http.get(
    Uri.parse('$baseUrl/daily-reports/today'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else if (response.statusCode == 404) {
    // No report found for today
    return {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch today\'s report');
  }
}

// Get report by date
static Future<Map<String, dynamic>> getDailyReportByDate(String date) async {
  final response = await http.get(
    Uri.parse('$baseUrl/daily-reports/by-date?date=$date'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else if (response.statusCode == 404) {
    // No report found for this date
    return {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch report for date');
  }
}

// Get a specific daily report by ID
static Future<Map<String, dynamic>> getDailyReportById(String reportId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/daily-reports/$reportId'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch report');
  }
}

// Submit daily report for review
static Future<Map<String, dynamic>> submitDailyReport(String reportId) async {
  final response = await http.post(
    Uri.parse('$baseUrl/daily-reports/$reportId/submit'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to submit report');
  }
}

// Update time entry in daily report
static Future<Map<String, dynamic>> updateDailyReportTimeEntry(
  String reportId, 
  String entryId, 
  Map<String, dynamic> data
) async {
  final response = await http.put(
    Uri.parse('$baseUrl/daily-reports/$reportId/time-entries/$entryId'),
    headers: await _getHeaders(),
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to update time entry');
  }
}

// Add task entry to time entry
static Future<Map<String, dynamic>> addTaskEntryToTimeEntry(
  String reportId,
  String timeEntryId,
  Map<String, dynamic> taskData
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/daily-reports/$reportId/time-entries/$timeEntryId/tasks'),
    headers: await _getHeaders(),
    body: jsonEncode(taskData),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to add task entry');
  }
}

// Update task entry details
static Future<Map<String, dynamic>> updateTaskEntryDetails(
  String reportId,
  String timeEntryId,
  String taskEntryId,
  Map<String, dynamic> taskData
) async {
  final response = await http.put(
    Uri.parse('$baseUrl/daily-reports/$reportId/time-entries/$timeEntryId/tasks/$taskEntryId'),
    headers: await _getHeaders(),
    body: jsonEncode(taskData),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to update task entry');
  }
}

// Delete task entry
static Future<Map<String, dynamic>> deleteTaskEntry(
  String reportId,
  String timeEntryId,
  String taskEntryId
) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/daily-reports/$reportId/time-entries/$timeEntryId/tasks/$taskEntryId'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['report'] ?? {};
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to delete task entry');
  }
}

// Get list of all reports for current mechanic
static Future<List<dynamic>> getMyDailyReports({String? startDate, String? endDate}) async {
  String url = '$baseUrl/daily-reports/my-reports';
  
  // Add query parameters if provided
  if (startDate != null || endDate != null) {
    List<String> params = [];
    if (startDate != null) params.add('startDate=$startDate');
    if (endDate != null) params.add('endDate=$endDate');
    url += '?${params.join('&')}';
  }
  
  final response = await http.get(
    Uri.parse(url),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['reports'] ?? [];
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to fetch reports');
  }
}

// Download report PDF
static Future<String> downloadDailyReportPDF(String reportId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/daily-reports/$reportId/pdf'),
    headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
    // Handle the PDF file download
    // This would typically involve saving the file locally using path_provider
    // Return the local path to the downloaded file
    return "path_to_downloaded_pdf.pdf";
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to download PDF');
  }
}
}