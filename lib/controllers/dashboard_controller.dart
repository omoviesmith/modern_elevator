// modern_elevator_app/lib/controllers/dashboard_controller.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

enum DashboardLoadingStatus { loading, loaded, error }

class DashboardController with ChangeNotifier {
  DashboardLoadingStatus _status = DashboardLoadingStatus.loading;
  String _errorMessage = '';
  Map<String, dynamic> _dashboardData = {};
  Map<String, dynamic> _quickStats = {};
  Map<String, dynamic> _recentActivity = {};
  Map<String, dynamic> _workSummary = {};
  bool _isAdmin = false;

  DashboardLoadingStatus get status => _status;
  String get errorMessage => _errorMessage;
  Map<String, dynamic> get dashboardData => _dashboardData;
  Map<String, dynamic> get quickStats => _quickStats;
  Map<String, dynamic> get recentActivity => _recentActivity;
  Map<String, dynamic> get workSummary => _workSummary;
  bool get isAdmin => _isAdmin;

  // Initialize dashboard
  Future<void> initialize() async {
    try {
      _status = DashboardLoadingStatus.loading;
      notifyListeners();

      // Check if user is admin
      final userData = await ApiService.getCurrentUser();
      _isAdmin = userData != null && userData['role'] == 'admin';

      // Load dashboard data
      await Future.wait([
        _loadDashboardData(),
        _loadQuickStats(),
      ]);

      _status = DashboardLoadingStatus.loaded;
    } catch (e) {
      _status = DashboardLoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Load dashboard data
  Future<void> _loadDashboardData() async {
    try {
      final response = await ApiService.getDashboardData();
      if (response['success'] == true && response['data'] != null) {
        _dashboardData = response['data']['dashboard'] ?? {};
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  // Load quick stats
  Future<void> _loadQuickStats() async {
    try {
      final response = await ApiService.getQuickStats();
      if (response['success'] == true && response['data'] != null) {
        _quickStats = response['data']['stats'] ?? {};
      }
    } catch (e) {
      print('Error loading quick stats: $e');
    }
  }

  // Load recent activity
  Future<void> loadRecentActivity() async {
    try {
      final response = await ApiService.getRecentActivity();
      if (response['success'] == true && response['data'] != null) {
        _recentActivity = response['data'] ?? {};
      }
      notifyListeners();
    } catch (e) {
      print('Error loading recent activity: $e');
    }
  }

  // Load work summary
  Future<void> loadWorkSummary({String period = 'day'}) async {
    try {
      final response = await ApiService.getWorkSummary(period: period);
      if (response['success'] == true && response['data'] != null) {
        _workSummary = response['data']['summary'] ?? {};
      }
      notifyListeners();
    } catch (e) {
      print('Error loading work summary: $e');
    }
  }

  // Refresh all dashboard data
  Future<void> refreshDashboard() async {
    try {
      _status = DashboardLoadingStatus.loading;
      notifyListeners();

      await Future.wait([
        _loadDashboardData(),
        _loadQuickStats(),
      ]);

      _status = DashboardLoadingStatus.loaded;
    } catch (e) {
      _status = DashboardLoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}