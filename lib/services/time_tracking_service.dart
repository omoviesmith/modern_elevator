//modern_elevator_app/lib/services/time_tracking_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class TimeTrackingService {
  // Singleton instance
  static final TimeTrackingService _instance = TimeTrackingService._internal();
  factory TimeTrackingService() => _instance;
  TimeTrackingService._internal();

  // Time tracking state
  String? _activeTimeEntryId;
  DateTime? _startTime;
  bool _isRegularHours = true;
  Timer? _timer;
  
  // Callback function for timer updates
  Function(Duration)? onTimerUpdate;
  Function(bool)? onTimerStatusChanged;
  ValueNotifier<Duration> activeTime = ValueNotifier<Duration>(Duration.zero);

  // Initialize - call this at app startup
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _activeTimeEntryId = prefs.getString('activeTimeEntryId');
    final startTimeStr = prefs.getString('timeEntryStartTime');
    
    if (startTimeStr != null) {
      _startTime = DateTime.parse(startTimeStr);
      _isRegularHours = prefs.getBool('isRegularHours') ?? true;
      
      // Start timer if there's an active time entry
      if (_activeTimeEntryId != null && _startTime != null) {
        _startTimer();
        if (onTimerStatusChanged != null) {
          onTimerStatusChanged!(true);
        }
      }
    } else {
      // Check with backend if there's an active time entry
      try {
        final activeEntry = await ApiService.getActiveTimeEntry();
        if (activeEntry != null) {
          _activeTimeEntryId = activeEntry['id'];
          _startTime = DateTime.parse(activeEntry['startTime']);
          _isRegularHours = activeEntry['isRegularHours'] ?? true;
          
          await prefs.setString('activeTimeEntryId', _activeTimeEntryId!);
          await prefs.setString('timeEntryStartTime', _startTime!.toIso8601String());
          await prefs.setBool('isRegularHours', _isRegularHours);
          
          _startTimer();
          if (onTimerStatusChanged != null) {
            onTimerStatusChanged!(true);
          }
        }
      } catch (e) {
        print('Error initializing time tracking: $e');
      }
    }
  }

    // Start timer to update elapsed time
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final elapsed = DateTime.now().difference(_startTime!);
        activeTime.value = elapsed;
        
        // Only call the callback if it's not null
        if (onTimerUpdate != null) {
          onTimerUpdate!(elapsed);
        }
      }
    });
  }

  // // Start timer to update elapsed time
  // void _startTimer() {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (_startTime != null) {
  //       final elapsed = DateTime.now().difference(_startTime!);
  //       activeTime.value = elapsed;
  //       if (onTimerUpdate != null) {
  //         onTimerUpdate!(elapsed);
  //       }
  //     }
  //   });
  // }

  // Check if location permission is granted
  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

// Verify location is within project site
Future<bool> verifyLocation(String projectId) async {
  try {
    final position = await getCurrentLocation();
    if (position == null) {
      print('Could not get current location');
      // For testing purposes, return true to bypass location verification
      return true; // In production, return false
    }
    
    final isVerified = await ApiService.verifyLocation(
      projectId: projectId,
      latitude: position.latitude,
      longitude: position.longitude,
    );
    
    print('Location verification result: $isVerified');
    return isVerified;
  } catch (e) {
    print('Error verifying location: $e');
    // For testing purposes, return true to bypass location verification
    return true; // In production, return false
  }
}

  // Start a time entry
  Future<bool> startTimeEntry({
    required String projectId,
    required String elevatorId,
    required String taskId,
    bool isRegularHours = true,
    String? notes,
  }) async {
    try {
      // Get current location
      final position = await getCurrentLocation();
      
      final response = await ApiService.clockIn(
        projectId: projectId,
        elevatorId: elevatorId,
        taskId: taskId,
        isRegularHours: isRegularHours,
        notes: notes,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );
      
      final timeEntryData = response['data']['timeEntry'];
      _activeTimeEntryId = timeEntryData['id'];
      _startTime = DateTime.parse(timeEntryData['startTime']);
      _isRegularHours = timeEntryData['isRegularHours'] ?? isRegularHours;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('activeTimeEntryId', _activeTimeEntryId!);
      await prefs.setString('timeEntryStartTime', _startTime!.toIso8601String());
      await prefs.setBool('isRegularHours', _isRegularHours);
      
      // Start timer
      _startTimer();
      if (onTimerStatusChanged != null) {
        onTimerStatusChanged!(true);
      }
      
      return true;
    } catch (e) {
      print('Error starting time entry: $e');
      return false;
    }
  }

  // Complete a time entry
  Future<bool> completeTimeEntry({
    String? notes,
    bool isLunchTaken = false,
  }) async {
    if (_activeTimeEntryId == null || _startTime == null) {
      return false;
    }
    
    try {
      // Get current location
      final position = await getCurrentLocation();
      
      await ApiService.clockOut(
        notes: notes,
        isLunchTaken: isLunchTaken,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );
      
      // Clean up timer and state
      _timer?.cancel();
      _activeTimeEntryId = null;
      _startTime = null;
      
      // Clear from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('activeTimeEntryId');
      await prefs.remove('timeEntryStartTime');
      await prefs.remove('isRegularHours');
      
      activeTime.value = Duration.zero;
      if (onTimerStatusChanged != null) {
        onTimerStatusChanged!(false);
      }
      
      return true;
    } catch (e) {
      print('Error completing time entry: $e');
      return false;
    }
  }

  // Check if there's an active time entry
  bool get isActive => _activeTimeEntryId != null && _startTime != null;
  
  // Get elapsed time
  Duration get elapsedTime {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }
  
  // Get active time entry ID
  String? get activeTimeEntryId => _activeTimeEntryId;
  
  // Is regular hours
  bool get isRegularHours => _isRegularHours;

    // Add a method to remove callbacks
  void removeCallbacks() {
    onTimerUpdate = null;
    onTimerStatusChanged = null;
  }
  
  // Update dispose to also remove callbacks
  void dispose() {
    _timer?.cancel();
    _timer = null;
    removeCallbacks();
  }
  

}