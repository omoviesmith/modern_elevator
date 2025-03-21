// lib/providers/daily_report_provider.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/daily_report.dart';

class DailyReportProvider with ChangeNotifier {
  DailyReport? _currentReport;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  DailyReport? get currentReport => _currentReport;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  // Fetch today's report
  Future<void> fetchTodayReport() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final reportData = await ApiService.getTodayDailyReport();
      
      if (reportData.isNotEmpty) {
        _currentReport = DailyReport.fromJson(reportData);
      } else {
        _currentReport = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentReport = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch report by date
  Future<void> fetchReportByDate(String date) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final reportData = await ApiService.getDailyReportByDate(date);
      
      if (reportData.isNotEmpty) {
        _currentReport = DailyReport.fromJson(reportData);
      } else {
        _currentReport = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentReport = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch report by ID
  Future<void> fetchReportById(String reportId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final reportData = await ApiService.getDailyReportById(reportId);
      _currentReport = DailyReport.fromJson(reportData);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentReport = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit the report
  Future<bool> submitReport() async {
    if (_currentReport == null) {
      _error = "No report to submit";
      notifyListeners();
      return false;
    }
    
    _isSubmitting = true;
    notifyListeners();
    
    try {
      final reportData = await ApiService.submitDailyReport(_currentReport!.id);
      _currentReport = DailyReport.fromJson(reportData);
      _error = null;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Update a time entry
  Future<bool> updateTimeEntry(String entryId, Map<String, dynamic> data) async {
    if (_currentReport == null) {
      _error = "No report loaded";
      notifyListeners();
      return false;
    }
    
    try {
      final reportData = await ApiService.updateDailyReportTimeEntry(
        _currentReport!.id, 
        entryId, 
        data
      );
      _currentReport = DailyReport.fromJson(reportData);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Add a task entry to a time entry
  Future<bool> addTaskEntry(String timeEntryId, Map<String, dynamic> taskData) async {
    if (_currentReport == null) {
      _error = "No report loaded";
      notifyListeners();
      return false;
    }
    
    try {
      final reportData = await ApiService.addTaskEntryToTimeEntry(
        _currentReport!.id, 
        timeEntryId, 
        taskData
      );
      _currentReport = DailyReport.fromJson(reportData);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}