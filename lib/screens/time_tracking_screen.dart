

// //modern_elevator_app/lib/screens/time_tracking_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:async';
// import '../widgets/base_scaffold.dart';
// import '../services/api_service.dart';
// import '../services/time_tracking_service.dart';
// import '../models/task_category.dart';
// import '../models/time_entry_task.dart';

// import 'dart:developer'; 

// class TimeTrackingScreen extends StatefulWidget {
//   const TimeTrackingScreen({super.key});

//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> with WidgetsBindingObserver {
//   // Loading states
//   bool _isLoading = true;
//   bool _isProjectsLoading = true;
//   bool _isElevatorsLoading = false;
//   bool _isTaskCategoriesLoading = true;
//   bool _isTasksLoading = false;
//   bool _isClockingInOut = false;
//   bool _isLocationChecking = false;

//   // Service instance
//   final _timeTrackingService = TimeTrackingService();

//   // Current time state
//   String _currentTime = '';
//   Timer? _timeUpdateTimer;

//   // Projects, elevators, and tasks data
//   List<dynamic> _projects = [];
//   List<dynamic> _elevators = [];
//   List<TaskCategory> _taskCategories = [];
//   final Map<String, List<Task>> _tasksMap = {};
  
//   // Selected values
//   dynamic _selectedProject;
//   dynamic _selectedElevator;
//   TaskCategory? _selectedCategory;
//   Task? _selectedTask;
  
//   // Time tracking state
//   bool _isClockedIn = false;
//   String _elapsedTimeString = '00:00:00';

//   Timer? _activeTasksTimer;

//   // Active tasks with timers
//   List<Task> _activeTasks = [];
//   Map<String, Duration> _activeTasksDurations = {};
  
//   // Today's summary
//   int _todayTotalMinutes = 0;
//   int _todayRegularMinutes = 0;
//   int _todayOvertimeMinutes = 0;

//   // In time_tracking_screen.dart, add these state variables to _TimeTrackingScreenState

//   // For active time entry details
//   Map<String, dynamic>? _activeTimeEntry;
//   // List<TaskCategoryWithTasks> _taskCategories = [];
//   TimeEntryTask? _currentTask;
//   bool _isLoadingActiveEntry = false;
//   // Add this with the other state variables
// List<TaskCategoryWithTasks> _categoriesWithTasks = []; // New list for categories with tasks

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initialize();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // Refresh the active time entry status when app resumes
//       _refreshActiveTimeEntry();
//     }
//   }

//   @override
// void dispose() {
//   _timeUpdateTimer?.cancel();
//   _activeTasksTimer?.cancel();
  
//   // Remove callbacks from the service
//   _timeTrackingService.removeCallbacks();
  
//   WidgetsBinding.instance.removeObserver(this);
//   super.dispose();
// }

// // Fix other methods where setState is called to check mounted first
// void _updateCurrentTime() {
//   if (mounted) {
//     setState(() {
//       _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
//     });
//   }
// }

//   Future<void> _initialize() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//     // Initialize the time tracking service
//     await _timeTrackingService.initialize();
    
//     // Setup time update timer
//     _updateCurrentTime();
//     _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (mounted) {
//         _updateCurrentTime();
//       }
//     });
    
//     // Setup timer update callback
//     _timeTrackingService.onTimerUpdate = (elapsed) {
//       if (mounted) {
//         setState(() {
//           _elapsedTimeString = _formatDuration(elapsed);
//         });
//       }
//     };
    
//     _timeTrackingService.onTimerStatusChanged = (isActive) {
//       if (mounted) {
//         setState(() {
//           _isClockedIn = isActive;
//         });
        
//         if (isActive) {
//           _loadActiveTasks();
//         } else {
//           _activeTasks = [];
//           _activeTasksDurations = {};
//         }
//       }
//     };
      
//       // Check if there's an active time entry
//       setState(() {
//         _isClockedIn = _timeTrackingService.isActive;
//       });
      
//       if (_isClockedIn) {
//         _elapsedTimeString = _formatDuration(_timeTrackingService.elapsedTime);
//       }
      
//       // Load data in parallel
//       await Future.wait([
//         _loadProjects(),
//         _loadTaskCategories(),
//         _loadTodaySummary(),
//       ]);
      
//       if (_isClockedIn) {
//         _loadActiveTasks();
//         // Load current time entry details after tasks are loaded
//         await _loadCurrentTimeEntryDetails();
//       }

//       setState(() {
//         _isLoading = false;
//       });
//      if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   } catch (e) {
//     log('Error initializing time tracking screen: $e');
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//       _showErrorSnackBar('Failed to initialize: $e');
//     }
//   }
//     // } catch (e) {
//     //   log('Error initializing time tracking screen: $e');
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     //   _showErrorSnackBar('Failed to initialize: $e');
//     // }
//   }

//   // void _updateCurrentTime() {
//   //   setState(() {
//   //     _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
//   //   });
//   // }

//   Future<void> _refreshActiveTimeEntry() async {
//     try {
//       final activeEntry = await ApiService.getActiveTimeEntry();
      
//       setState(() {
//         _isClockedIn = activeEntry != null;
//       });
      
//       if (_isClockedIn && activeEntry != null) {
//         final startTime = DateTime.parse(activeEntry['startTime']);
//         final elapsed = DateTime.now().difference(startTime);
//         setState(() {
//           _elapsedTimeString = _formatDuration(elapsed);
//         });
        
//         _loadActiveTasks();
//         await _loadCurrentTimeEntryDetails();
//       }
//     } catch (e) {
//       log('Error refreshing active time entry: $e');
//     }
//   }

//   Future<void> _loadCurrentTimeEntryDetails() async {
//     try {
//       final activeEntry = await ApiService.getActiveTimeEntry();
//       if (activeEntry != null) {
//         final projectId = activeEntry['projectId'];
//         final elevatorId = activeEntry['elevatorId'];
//         final taskId = activeEntry['taskId'];
        
//         // Set selected project
//         for (var project in _projects) {
//           if (project['id'] == projectId) {
//             setState(() {
//               _selectedProject = project;
//             });
//             break;
//           }
//         }
        
//         // Load elevators and set selected elevator
//         if (_selectedProject != null) {
//           await _loadElevatorsForProject(_selectedProject['id']);
//           for (var elevator in _elevators) {
//             if (elevator['id'] == elevatorId) {
//               setState(() {
//                 _selectedElevator = elevator;
//               });
//               break;
//             }
//           }
//         }
        
//         // Make sure all categories are loaded
//         if (_taskCategories.isEmpty) {
//           await _loadTaskCategories();
//         }
        
//         // Find the task and its category
//         // First we need to load all tasks for all categories
//         for (var category in _taskCategories) {
//           if (!_tasksMap.containsKey(category.id)) {
//             await _loadTasksForCategory(category.id);
//           }
//         }
        
//         // Now search for the task in all loaded tasks
//         TaskCategory? foundCategory;
//         Task? foundTask;
        
//         for (var category in _taskCategories) {
//           final tasks = _tasksMap[category.id] ?? [];
//           for (var task in tasks) {
//             if (task.id == taskId) {
//               foundCategory = category;
//               foundTask = task;
//               break;
//             }
//           }
//           if (foundTask != null) break;
//         }
        
//         if (foundCategory != null && foundTask != null) {
//           setState(() {
//             _selectedCategory = foundCategory;
//             _selectedTask = foundTask;
//           });
//         }
//       }
//     } catch (e) {
//       log('Error loading current time entry details: $e');
//     }
//   }

//   Future<void> _loadProjects() async {
//     try {
//       if (mounted) {
//       setState(() {
//         _isProjectsLoading = true;
//       });
//       }
      
//       final projects = await ApiService.getProjects();
      
//       if (mounted) {
//       setState(() {
//         _projects = projects;
//         _isProjectsLoading = false;
        
//         // Select first project by default if available
//         if (_projects.isNotEmpty && _selectedProject == null) {
//           _selectedProject = _projects[0];
//           _loadElevatorsForProject(_selectedProject['id']);
//         }
//       });
//       }
//     } catch (e) {
      
//       setState(() {
//         _isProjectsLoading = false;
//       });
  
//       _showErrorSnackBar('Failed to load projects: $e');
//     }
//   }

//   Future<void> _loadElevatorsForProject(String projectId) async {
//     try {
//       if (mounted) {
//       setState(() {
//         _isElevatorsLoading = true;
//         if (_selectedProject == null || _selectedProject['id'] != projectId) {
//           _selectedElevator = null;
//         }
//       });
//       }
      
//       final elevators = await ApiService.getElevatorsForProject(projectId);
//       if (mounted) {
//       setState(() {
//         _elevators = elevators;
//         _isElevatorsLoading = false;
        
//         // Select first elevator by default if available and none is selected
//         if (_elevators.isNotEmpty && _selectedElevator == null) {
//           _selectedElevator = _elevators[0];
//         }
//       });
//       }
//     } catch (e) {
//       setState(() {
//         _isElevatorsLoading = false;
//       });
//       _showErrorSnackBar('Failed to load elevators: $e');
//     }
//   }

//   Future<void> _loadTaskCategories() async {
//     try {
//       if (mounted) {
//       setState(() {
//         _isTaskCategoriesLoading = true;
//       });
//       }
      
//       final categories = await ApiService.getTaskCategories();
//       if (mounted) {
//       setState(() {
//         _taskCategories = categories.cast<TaskCategory>();
//         _isTaskCategoriesLoading = false;
        
//         // Select first category by default if available
//         if (_taskCategories.isNotEmpty && _selectedCategory == null) {
//           _selectedCategory = _taskCategories[0];
//           _loadTasksForCategory(_selectedCategory!.id);
//         }
//       });
//       }
//     } catch (e) {
//       setState(() {
//         _isTaskCategoriesLoading = false;
//       });
//       _showErrorSnackBar('Failed to load task categories: $e');
//     }
//   }

//   Future<void> _loadTasksForCategory(String categoryId) async {
//     // Check if tasks for this category are already loaded
//     if (_tasksMap.containsKey(categoryId)) {
//       // Tasks already loaded, just update the selected task if needed
//       final tasks = _tasksMap[categoryId] ?? [];
//       if (tasks.isNotEmpty && (_selectedTask == null || _selectedTask!.categoryId != categoryId)) {
//         setState(() {
//           _selectedTask = tasks[0] as Task?;
//         });
//       }
//       return;
//     }
    
//     try {
//       if (mounted) {
//       setState(() {
//         _isTasksLoading = true;
//         // Only clear selected task if category changed
//         if (_selectedTask != null && _selectedTask!.categoryId != categoryId) {
//           _selectedTask = null;
//         }
//       });
//       }
      
//       final tasks = await ApiService.getTasksForCategory(categoryId);
//       if (mounted) {
//       setState(() {
//         _tasksMap[categoryId] = tasks.map((task) => Task(
//           id: task.id,
//           name: task.name,
//           description: task.description,
//           categoryId: task.categoryId,
//         )).toList();
//         _isTasksLoading = false;
        
//         // Select first task by default if available and none is selected or category changed
//         if (tasks.isNotEmpty && (_selectedTask == null || _selectedTask!.categoryId != categoryId)) {
//           _selectedTask = tasks[0] as Task?;
//         }
//       });
//       }
//     } catch (e) {
//       setState(() {
//         _isTasksLoading = false;
//       });
//       _showErrorSnackBar('Failed to load tasks: $e');
//     }
//   }

//   Future<void> _loadTodaySummary() async {
//     try {
//       final summary = await ApiService.getTimeEntrySummary();
//       if (mounted) {
//       setState(() {
//         _todayTotalMinutes = summary['totalMinutes'] ?? 0;
//         _todayRegularMinutes = summary['regularMinutes'] ?? 0;
//         _todayOvertimeMinutes = summary['overtimeMinutes'] ?? 0;
//       });
//       }
//     } catch (e) {
//       log('Error loading today\'s summary: $e');
//     }
//   }


// Future<void> _loadActiveTasks() async {
//   setState(() {
//     _isLoadingActiveEntry = true;
//   });
  
//   try {
//     final activeEntry = await ApiService.getActiveTimeEntry();
    
//     if (activeEntry != null && activeEntry['active'] == true) {
//       setState(() {
//         _activeTimeEntry = activeEntry;
//         _isClockedIn = true;
        
//         // Extract current task
//         if (activeEntry['timeEntry'] != null && activeEntry['timeEntry']['currentTask'] != null) {
//           final currentTaskData = activeEntry['timeEntry']['currentTask'];
//           _currentTask = TimeEntryTask(
//             id: currentTaskData['id'],
//             name: currentTaskData['name'],
//             description: currentTaskData['description'] ?? '',
//             startTime: DateTime.parse(currentTaskData['startTime']),
//             endTime: null,
//             notes: currentTaskData['notes'] ?? '',
//             isCurrent: true,
//           );
          
//           // Set selected task for task switching
//           if (_selectedTask == null || _selectedTask!.id != _currentTask!.id) {
//             for (var category in _taskCategories) { // This still uses your original TaskCategory type
//               final tasks = _tasksMap[category.id] ?? [];
//               for (var task in tasks) {
//                 if (task.id == _currentTask!.id) {
//                   _selectedTask = task;
//                   _selectedCategory = category;
//                   break;
//                 }
//               }
//               if (_selectedTask != null) break;
//             }
//           }
//         }
        
//         // Extract task categories with tasks
//         if (activeEntry['timeEntry'] != null && activeEntry['timeEntry']['taskCategories'] != null) {
//           _categoriesWithTasks = (activeEntry['timeEntry']['taskCategories'] as List)
//               .map((categoryJson) => TaskCategoryWithTasks.fromJson(categoryJson))
//               .toList();
//         }
//       });
      
//       // Load project and elevator data
//       await _loadCurrentTimeEntryDetails();
//     } else {
//       setState(() {
//         _isClockedIn = false;
//         _activeTimeEntry = null;
//         _currentTask = null;
//         _categoriesWithTasks = []; // Updated to use the new list
//       });
      
//       // Get today's time entries instead
//       final todayData = await ApiService.getTodayTimeEntries();
      
//       if (todayData['timeEntries'] != null) {
//         // Process today's time entries for the "Today's Activities" section
//         final timeEntries = todayData['timeEntries'] as List;
        
//         // Extract task categories from the daily summary
//         List<TaskCategoryWithTasks> categories = [];
        
//         for (var entry in timeEntries) {
//           if (entry['taskCategories'] != null) {
//             categories.addAll(
//               (entry['taskCategories'] as List)
//                   .map((categoryJson) => TaskCategoryWithTasks.fromJson(categoryJson))
//                   .toList()
//             );
//           }
//         }
        
//         setState(() {
//           _categoriesWithTasks = categories; // Updated to use the new list
//         });
//       }
//     }
//   } catch (e) {
//     log('Error loading active tasks: $e');
//   } finally {
//     setState(() {
//       _isLoadingActiveEntry = false;
//     });
//   }
// }

//   Future<void> _toggleClockInOut() async {
//     if (_isClockingInOut) return;
    
//     if (_isClockedIn) {
//       _showLeavingEarlyPrompt();
//     } else {
//       if (_selectedProject == null || _selectedElevator == null || _selectedTask == null) {
//         _showErrorSnackBar('Please select project, elevator, and task before clocking in.');
//         return;
//       }
      
//       _showLatePrompt();
//     }
//   }

// Future<void> _clockIn({bool adjustedTime = false}) async {
//   if (_isClockingInOut) return;
  
//   // Make sure project and elevator are selected
//   if (_selectedProject == null || _selectedElevator == null || _selectedTask == null) {
//     _showErrorSnackBar('Please select project, elevator, and task before clocking in.');
//     return;
//   }
  
//   setState(() {
//     _isClockingInOut = true;
//     _isLocationChecking = true;
//   });
  
//   try {
//     // First verify location before proceeding
//     log('Verifying location for project: ${_selectedProject['id']}');
//     final isLocationVerified = await _timeTrackingService.verifyLocation(_selectedProject['id']);
    
//     if (!isLocationVerified) {
//       setState(() {
//         _isClockingInOut = false;
//         _isLocationChecking = false;
//       });
//       _showErrorSnackBar('Location verification failed. Please make sure you are at the job site.');
//       return;
//     }
    
//     log('Location verified successfully');
    
//     // Determine if currently in regular hours (7am to 3:30pm on weekdays)
//     final now = DateTime.now();
//     final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
//     final hour = now.hour;
//     final isRegularHours = !isWeekend && (hour >= 7 && (hour < 15 || (hour == 15 && now.minute <= 30)));
    
//     final success = await _timeTrackingService.startTimeEntry(
//       projectId: _selectedProject['id'],
//       elevatorId: _selectedElevator['id'],
//       taskId: _selectedTask!.id,
//       isRegularHours: isRegularHours,
//     );
    
//     setState(() {
//       _isClockingInOut = false;
//       _isLocationChecking = false;
//       _isClockedIn = success;
//     });
    
//     if (success) {
//       _showSuccessMessage('You have successfully clocked in.');
//       // Reload active tasks after clocking in
//       _loadActiveTasks();
//     } else {
//       _showErrorSnackBar('Failed to clock in. Please try again.');
//     }
//   } catch (e) {
//     log('Error clocking in: $e');
//     setState(() {
//       _isClockingInOut = false;
//       _isLocationChecking = false;
//     });
//     _showErrorSnackBar('Error clocking in: $e');
//   }
// }


//   Future<void> _clockOut({bool adjustedTime = false}) async {
//     if (_isClockingInOut) return;
    
//     setState(() {
//       _isClockingInOut = true;
//     });
    
//     try {
//       final success = await _timeTrackingService.completeTimeEntry();
      
//       setState(() {
//         _isClockingInOut = false;
//         _isClockedIn = !success;
//       });
      
//       if (success) {
//         _showSuccessMessage('You have successfully clocked out.');
//         _loadTodaySummary(); // Refresh summary after clocking out
//         _loadActiveTasks(); // Refresh active tasks
//       } else {
//         _showErrorSnackBar('Failed to clock out. Please try again.');
//       }
//     } catch (e) {
//       setState(() {
//         _isClockingInOut = false;
//       });
//       _showErrorSnackBar('Error clocking out: $e');
//     }
//   }

//   // Add this method to handle task switching
//   Future<void> _switchTask() async {
//   if (_selectedTask == null) {
//     _showErrorSnackBar('Please select a task to switch to.');
//     return;
//   }
  
//   try {
//     setState(() {
//       _isLoading = true;
//     });
    
//     // Call API to update the active time entry
//     await ApiService.updateActiveTimeEntry(
//       taskId: _selectedTask!.id,
//     );
    
//     // Refresh active task data
//     await _loadActiveTasks();
    
//     setState(() {
//       _isLoading = false;
//     });
    
//     _showSuccessMessage('Successfully switched to task: ${_selectedTask!.name}');
//   } catch (e) {
//     setState(() {
//       _isLoading = false;
//     });
//     _showErrorSnackBar('Failed to switch task: $e');
//   }
// }


//   void _showLatePrompt() {
//   // Check if current time is after 7 AM
//   final now = DateTime.now();
//   final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
//   final isAfterStartTime = now.hour > 7 || (now.hour == 7 && now.minute > 0);
  
//   if (!isWeekend && isAfterStartTime) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF1E1E1E),
//           title: Text(
//             'Are you aware you\'re late today?',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             'Regular work hours begin at 7AM.',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _clockIn();
//               },
//             ),
//             TextButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Do nothing, time continues running
//               },
//             )
//           ],
//         );
//       },
//     );
//   } else {
//     _clockIn();
//   }
// }

// void _showLeavingEarlyPrompt() {
//   // Check if current time is before 3:30 PM on weekdays
//   final now = DateTime.now();
//   final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
//   final isBeforeEndTime = now.hour < 15 || (now.hour == 15 && now.minute < 30);
  
//   if (!isWeekend && isBeforeEndTime) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF1E1E1E),
//           title: Text(
//             'Are you leaving early today?',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             'Regular work hours ends at 3:30PM.',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _clockOut();
//               },
//             ),
//             TextButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Do nothing, time continues running
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     _clockOut();
//   }
// }


//   void _showLunchPrompt() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF1E1E1E),
//           title: Text(
//             'Did you take lunch today?',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             'A 30-minute unpaid lunch break is required.',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Continue with clock out process
//                 _clockOut();
//               },
//             ),
//             TextButton(
//               child: Text('No', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showNoLunchApprovalPrompt();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showNoLunchApprovalPrompt() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF1E1E1E),
//           title: Text(
//             'No Lunch Break',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             'Did you get approval from the Construction Foreman to skip lunch?',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Continue with clock out process
//                 _clockOut();
//               },
//             ),
//             TextButton(
//               child: Text('No', style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showErrorSnackBar('Lunch break is required unless approved by the Construction Foreman.');
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAdjustTimeDialog({required bool isClockingIn}) {
//     final now = DateTime.now();
//     TimeOfDay selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF1E1E1E),
//           title: Text(
//             isClockingIn ? 'Adjust Start Time' : 'Adjust End Time',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 isClockingIn 
//                   ? 'Please enter your actual arrival time:'
//                   : 'Please enter your actual departure time:',
//                 style: TextStyle(color: Colors.white70),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFF7D104),
//                   foregroundColor: Colors.black,
//                 ),
//                 child: Text('Select Time'),
//                 onPressed: () async {
//                   final TimeOfDay? picked = await showTimePicker(
//                     context: context,
//                     initialTime: selectedTime,
//                     builder: (BuildContext context, Widget? child) {
//                       return Theme(
//                         data: ThemeData.dark().copyWith(
//                           colorScheme: ColorScheme.dark(
//                             primary: Color(0xFFF7D104),
//                             onPrimary: Colors.black,
//                             surface: Color(0xFF1E1E1E),
//                             onSurface: Colors.white,
//                           ),
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (picked != null) {
//                     selectedTime = picked;
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             TextButton(
//               child: Text('Confirm', style: TextStyle(color: Color(0xFFF7D104))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 if (isClockingIn) {
//                   _clockIn(adjustedTime: true);
//                 } else {
//                   _clockOut(adjustedTime: true);
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showSuccessMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   String _formatMinutes(int minutes) {
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     return "${hours}h ${mins}m";
//   }

//   // @override
//   // void dispose() {
//   //   _timeUpdateTimer?.cancel();
//   //   _activeTasksTimer?.cancel();
//   //   WidgetsBinding.instance.removeObserver(this);
//   //   _timeTrackingService.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       title: 'Time Tracking',
//       currentIndex: 3, // Update this based on your navigation index
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//           : _buildMainContent(),
//     );
//   }


//   Widget _buildMainContent() {
//   return SafeArea(
//     child: SingleChildScrollView(
//       child: Column(
//         children: [
//           // Clock Display Section
//           _buildClockDisplaySection(),
          
//           // Today's Summary Section
//           _buildTodaySummarySection(),
          
//           // Project Selection Section
//           _buildProjectSelectionSection(),
          
//           // Clock In/Out Section
//           _buildClockInOutSection(),
          
//           // Task Selection Section
//           if (_isClockedIn) 
//             _buildTaskSelectionSection()
//           else
//             _buildTaskCategorySection(),
            
//           // Active Tasks Section
//           SizedBox(
//             height: 300, // Fixed height or calculate dynamically
//             child: _buildActiveTasksSection(),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   Widget _buildClockDisplaySection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: BoxDecoration(
//         color: Color(0xFF121212),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Current Time
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Current Time',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 _currentTime,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
          
//           // Elapsed Time (only shown when clocked in)
//           if (_isClockedIn)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'Elapsed Time',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   _elapsedTimeString,
//                   style: TextStyle(
//                     color: Color(0xFFF7D104),
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTodaySummarySection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Wrap(
//         alignment: WrapAlignment.spaceAround,
//         spacing: 16,
//         runSpacing: 16,
//         children: [
//           _buildSummaryItem(
//             label: 'Regular',
//             value: _formatMinutes(_todayRegularMinutes),
//             color: Colors.green,
//           ),
//           _buildSummaryItem(
//             label: 'Overtime',
//             value: _formatMinutes(_todayOvertimeMinutes),
//             color: Colors.orange,
//           ),
//           _buildSummaryItem(
//             label: 'Total',
//             value: _formatMinutes(_todayTotalMinutes),
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryItem({
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 14,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: color,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }


//   // Update the _buildProjectSelectionSection method to handle possible duplicate IDs

// Widget _buildProjectSelectionSection() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     decoration: BoxDecoration(
//       color: Color(0xFF1E1E1E),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Job Site Information',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 16),
        
//         // Project and Elevator Selection using Wrap
//         Wrap(
//           spacing: 16,
//           runSpacing: 16,
//           children: [
//           // Project Dropdown
//           SizedBox(
//             width: MediaQuery.of(context).size.width > 600 ? 
//                   (MediaQuery.of(context).size.width - 64) / 2 : 
//                   MediaQuery.of(context).size.width - 48,
//             child: _isProjectsLoading
//                 ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//                 : _buildDropdownWithCheck(
//                   value: _selectedProject != null ? _selectedProject['id'] : null,
//                   items: _projects.map((project) => DropdownMenuItem<String>(
//                     value: project['id'],
//                     child: Text(
//                       project['name'], 
//                       style: TextStyle(color: Colors.white),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   )).toList(),
//                   onChanged: !_isClockedIn ? (value) {
//                     if (value != null) {
//                       // Find project safely with null check
//                       final projectIndex = _projects.indexWhere((project) => project['id'] == value);
//                       if (projectIndex >= 0) {
//                         setState(() {
//                           _selectedProject = _projects[projectIndex];
//                         });
//                         _loadElevatorsForProject(value as String);
//                       } else {
//                         log('Project with ID $value not found');
//                       }
//                     }
//                   } : null,
//                   hint: 'Select Project',
//                 ),
//           ),
            
//             // Elevator Dropdown
//             SizedBox(
//               width: MediaQuery.of(context).size.width > 600 ? 
//                     (MediaQuery.of(context).size.width - 64) / 2 : 
//                     MediaQuery.of(context).size.width - 48,
//               child: _isElevatorsLoading
//                   ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//                   : _buildDropdownWithCheck(
//                     value: _selectedElevator != null ? _selectedElevator['id'] : null,
//                     items: _elevators.map((elevator) => DropdownMenuItem<String>(
//                       value: elevator['id'],
//                       child: Text(
//                         elevator['number'] ?? 'Elevator ${elevator['elevatorNumber']}', 
//                         style: TextStyle(color: Colors.white),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     )).toList(),
//                     onChanged: !_isClockedIn ? (value) {
//                       if (value != null) {
//                         // Find elevator safely with null check
//                         final elevatorIndex = _elevators.indexWhere((elevator) => elevator['id'] == value);
//                         if (elevatorIndex >= 0) {
//                           setState(() {
//                             _selectedElevator = _elevators[elevatorIndex];
//                           });
//                         } else {
//                           log('Elevator with ID $value not found');
//                         }
//                       }
//                     } : null,
//                     hint: 'Select Elevator',
//                   ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildDropdownWithCheck<T>({
//   required T? value,
//   required List<DropdownMenuItem<T>> items,
//   required Function(T?)? onChanged,
//   required String hint,
// }) {
//   if (items.isEmpty) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<T>(
//           value: null,
//           items: [],
//           onChanged: null,
//           hint: Text(hint, style: TextStyle(color: Colors.white70)),
//           dropdownColor: Color(0xFF2A2A2A),
//           isExpanded: true,
//           icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
//           disabledHint: Text('No items available', style: TextStyle(color: Colors.white70)),
//         ),
//       ),
//     );
//   }

//   // Use a Map to eliminate duplicates while preserving the last instance of each value
//   final Map<dynamic, DropdownMenuItem<T>> uniqueItems = {};
  
//   for (var item in items) {
//     if (item.value != null) {
//       uniqueItems[item.value] = item;
//     }
//   }
  
//   final List<DropdownMenuItem<T>> finalItems = uniqueItems.values.toList();
  
//   // Check if the selected value exists in the items
//   bool valueExists = false;
//   if (value != null) {
//     valueExists = finalItems.any((item) => item.value == value);
//   }
  
//   // If the value doesn't exist and is not null, we need to add a placeholder
//   if (value != null && !valueExists) {
//     finalItems.add(DropdownMenuItem<T>(
//       value: value,
//       child: Text(
//         "Selected item", 
//         style: TextStyle(color: Colors.white),
//       ),
//     ));
//   }
  
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       color: Color(0xFF2A2A2A),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton<T>(
//         value: valueExists || value == null ? value : null,
//         items: finalItems,
//         onChanged: onChanged,
//         hint: Text(hint, style: TextStyle(color: Colors.white70)),
//         dropdownColor: Color(0xFF2A2A2A),
//         isExpanded: true,
//         icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
//       ),
//     ),
//   );
// }

//   Widget _buildClockInOutSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       alignment: Alignment.center,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _isClockedIn ? Colors.redAccent : Color(0xFFF7D104),
//           foregroundColor: Colors.black,
//           padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//           minimumSize: Size(200, 60),
//         ),
//         onPressed: _isClockingInOut ? null : _toggleClockInOut,
//         child: _isClockingInOut
//             ? _isLocationChecking
//                 ? Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
//                       ),
//                       SizedBox(width: 8),
//                       Text('Verifying Location...'),
//                     ],
//                   )
//                 : CircularProgressIndicator(color: Colors.black)
//             : FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       _isClockedIn ? Icons.logout : Icons.login,
//                       size: 24,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       _isClockedIn ? 'CLOCK OUT' : 'CLOCK IN',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   // Update the _buildTaskSelectionSection method

// Widget _buildTaskSelectionSection() {
//   return Column(
//     children: [
//       // Current Task Section
//       Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Current Task',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             _isLoadingActiveEntry 
//                 ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//                 : Text(
//                     _currentTask?.name ?? (_selectedTask?.name ?? 'No Task Selected'),
//                     style: TextStyle(
//                       color: Color(0xFFF7D104),
//                       fontSize: 18,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//             SizedBox(height: 8),
//             if (_currentTask != null)
//               Text(
//                 'Started at: ${DateFormat('HH:mm').format(_currentTask!.startTime)}',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//             SizedBox(height: 16),
//             Text(
//               _selectedProject != null && _selectedElevator != null ? 
//                 'Project: ${_selectedProject?['name'] ?? 'Unknown'} | Elevator: ${_selectedElevator?['elevatorNumber'] ?? 'Unknown'}' :
//                 'Project & Elevator Information Unavailable',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//           ],
//         ),
//       ),
      
//       // Select New Task Section
//       Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Switch Task',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
            
//             // Task Category Selection
//             _isTaskCategoriesLoading
//                 ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//                 : SizedBox(
//                     height: 44,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _taskCategories.length,
//                       itemBuilder: (context, index) {
//                         final category = _taskCategories[index];
//                         final isSelected = _selectedCategory?.id == category.id;
                        
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedCategory = category;
//                             });
//                             _loadTasksForCategory(category.id);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                             margin: EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               color: isSelected ? Color(0xFFF7D104) : Color(0xFF2A2A2A),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 category.code,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.black : Colors.white,
//                                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
            
//             SizedBox(height: 16),
            
//             // Task Selection and Switch Button
//           // Update in _buildTaskSelectionSection
//           Row(
//             children: [
//               Expanded(
//                 child: _selectedCategory != null
//                   ? _isTasksLoading
//                       ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//                       : _buildDropdownWithCheck<String>(
//                           value: _selectedTask?.id,
//                           items: (_tasksMap[_selectedCategory!.id] ?? []).map((task) => 
//                             DropdownMenuItem<String>(
//                               value: task.id,
//                               child: Text(
//                                 task.name, 
//                                 style: TextStyle(color: Colors.white),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             )
//                           ).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               final selectedTasks = _tasksMap[_selectedCategory!.id] ?? [];
//                               final taskIndex = selectedTasks.indexWhere((task) => task.id == value);
//                               if (taskIndex >= 0) {
//                                 setState(() {
//                                   _selectedTask = selectedTasks[taskIndex];
//                                 });
//                               } else {
//                                 log('Task with ID $value not found');
//                               }
//                             }
//                           },
//                           hint: 'Select Task',
//                         )
//                   : SizedBox(),
//               ),
//               SizedBox(width: 12),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFF7D104),
//                   foregroundColor: Colors.black,
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//                 onPressed: _selectedTask != null ? _switchTask : null,
//                 child: Text('Switch Task'),
//               ),
//             ],
//           ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// // Update the _buildTaskCategorySection method

// Widget _buildTaskCategorySection() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     decoration: BoxDecoration(
//       color: Color(0xFF1E1E1E),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Select Task',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 16),
        
//         // Task Category Selection
//         _isTaskCategoriesLoading
//             ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//             : SizedBox(
//                 height: 44,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _taskCategories.length,
//                   itemBuilder: (context, index) {
//                     final category = _taskCategories[index];
//                     final isSelected = _selectedCategory?.id == category.id;
                    
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedCategory = category;
//                         });
//                         _loadTasksForCategory(category.id);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         margin: EdgeInsets.only(right: 8),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Color(0xFFF7D104) : Color(0xFF2A2A2A),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Center(
//                           child: Text(
//                             category.code,
//                             style: TextStyle(
//                               color: isSelected ? Colors.black : Colors.white,
//                               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
        
//         SizedBox(height: 16),
        
//         // Task Selection
//         if (_selectedCategory != null)
//           _isTasksLoading
//               ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//               : _buildDropdownWithCheck<Task>(
//                   value: _selectedTask,
//                   items: (_tasksMap[_selectedCategory!.id] ?? []).map((task) => DropdownMenuItem<Task>(
//                     value: task,
//                     child: Text(
//                       task.name, 
//                       style: TextStyle(color: Colors.white),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   )).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedTask = value;
//                     });
//                   },
//                   hint: 'Select Task',
//                 ),
//       ],
//     ),
//   );
// }


// Widget _buildActiveTasksSection() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//     decoration: BoxDecoration(
//       color: Color(0xFF1E1E1E),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _isClockedIn ? 'Current Activities' : 'Today\'s Activities',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 16),
        
//         Expanded(
//           child: _isLoadingActiveEntry 
//             ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
//             : _categoriesWithTasks.isEmpty  // Changed from _taskCategories to _categoriesWithTasks
//               ? Center(
//                   child: Text(
//                     'No activities recorded yet',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: _categoriesWithTasks.length,  // Changed from _taskCategories
//                   itemBuilder: (context, index) {
//                     final category = _categoriesWithTasks[index];  // Changed from _taskCategories
                    
//                     // Skip categories with no tasks
//                     if (category.tasks.isEmpty) {
//                       return SizedBox.shrink();
//                     }
                    
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Category heading
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
//                           child: Text(
//                             category.name,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
                        
//                         // Tasks in this category
//                         ...category.tasks.map((task) {
//                           final isCurrentTask = task.isCurrent || 
//                             (_currentTask != null && task.id == _currentTask!.id);
                            
//                           return Container(
//                             margin: EdgeInsets.only(bottom: 12),
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Color(0xFF2A2A2A),
//                               borderRadius: BorderRadius.circular(8),
//                               border: isCurrentTask ? Border.all(
//                                 color: Color(0xFFF7D104),
//                                 width: 1.5,
//                               ) : null,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         task.name,
//                                         style: TextStyle(
//                                           color: isCurrentTask ? Color(0xFFF7D104) : Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                       ),
//                                     ),
//                                     Text(
//                                       _formatDuration(task.duration),
//                                       style: TextStyle(
//                                         color: Color(0xFFF7D104),
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   task.timeRange,
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 if (task.notes.isNotEmpty) 
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 4.0),
//                                     child: Text(
//                                       task.notes,
//                                       style: TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 13,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ],
//                     );
//                   },
//                 ),
//         ),
//       ],
//     ),
//   );
// }



//   String _getCategoryCodeForTask(Task task) {
//     for (var category in _taskCategories) {
//       if (category.id == task.categoryId) {
//         return category.code;
//       }
//     }
//     return 'Unknown';
//   }

//   Widget _buildDropdown<T>({
//     required T? value,
//     required List<DropdownMenuItem<T>> items,
//     required Function(T?)? onChanged,
//     required String hint,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<T>(
//           value: value,
//           items: items,
//           onChanged: onChanged,
//           hint: Text(hint, style: TextStyle(color: Colors.white70)),
//           dropdownColor: Color(0xFF2A2A2A),
//           isExpanded: true,
//           icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
//         ),
//       ),
//     );
//   }
// }

// modern_elevator_app/lib/screens/time_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../widgets/base_scaffold.dart';
import '../services/api_service.dart';
import '../services/time_tracking_service.dart';
import '../models/task_category.dart';
import '../models/time_entry_task.dart';

import 'dart:developer'; 

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> with WidgetsBindingObserver {
  // Loading states
  bool _isLoading = true;
  bool _isProjectsLoading = true;
  bool _isElevatorsLoading = false;
  bool _isTaskCategoriesLoading = true;
  bool _isTasksLoading = false;
  bool _isClockingInOut = false;
  bool _isLocationChecking = false;

  // Service instance
  final _timeTrackingService = TimeTrackingService();

  // Current time state
  String _currentTime = '';
  Timer? _timeUpdateTimer;

  // Projects, elevators, and tasks data
  List<dynamic> _projects = [];
  List<dynamic> _elevators = [];
  List<TaskCategory> _taskCategories = [];
  final Map<String, List<Task>> _tasksMap = {};
  
  // Selected values
  dynamic _selectedProject;
  dynamic _selectedElevator;
  TaskCategory? _selectedCategory;
  Task? _selectedTask;
  
  // Time tracking state
  bool _isClockedIn = false;
  String _elapsedTimeString = '00:00:00';

  Timer? _activeTasksTimer;

  // Active tasks with timers
  // ignore: unused_field
  List<Task> _activeTasks = [];
  // ignore: unused_field
  Map<String, Duration> _activeTasksDurations = {};
  
  // Today's summary
  int _todayTotalMinutes = 0;
  int _todayRegularMinutes = 0;
  int _todayOvertimeMinutes = 0;

  // For active time entry details
  // ignore: unused_field
  Map<String, dynamic>? _activeTimeEntry;
  TimeEntryTask? _currentTask;
  bool _isLoadingActiveEntry = false;
  List<TaskCategoryWithTasks> _categoriesWithTasks = []; // New list for categories with tasks

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh the active time entry status when app resumes
      _refreshActiveTimeEntry();
    }
  }

  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    _activeTasksTimer?.cancel();
    
    // Remove callbacks from the service
    _timeTrackingService.removeCallbacks();
    
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Fix other methods where setState is called to check mounted first
  void _updateCurrentTime() {
    if (mounted) {
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    }
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize the time tracking service
      await _timeTrackingService.initialize();
      
      // Setup time update timer
      _updateCurrentTime();
      _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateCurrentTime();
        }
      });
      
      // Setup timer update callback
      _timeTrackingService.onTimerUpdate = (elapsed) {
        if (mounted) {
          setState(() {
            _elapsedTimeString = _formatDuration(elapsed);
          });
        }
      };
      
      _timeTrackingService.onTimerStatusChanged = (isActive) {
        if (mounted) {
          setState(() {
            _isClockedIn = isActive;
          });
          
          if (isActive) {
            _loadActiveTasks();
          } else {
            _activeTasks = [];
            _activeTasksDurations = {};
          }
        }
      };
        
      // Check if there's an active time entry
      setState(() {
        _isClockedIn = _timeTrackingService.isActive;
      });
      
      if (_isClockedIn) {
        _elapsedTimeString = _formatDuration(_timeTrackingService.elapsedTime);
      }
      
      // Load data in parallel
      await Future.wait([
        _loadProjects(),
        _loadTaskCategories(),
        _loadTodaySummary(),
      ]);
      
      if (_isClockedIn) {
        _loadActiveTasks();
        // Load current time entry details after tasks are loaded
        await _loadCurrentTimeEntryDetails();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log('Error initializing time tracking screen: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to initialize: $e');
      }
    }
  }

  Future<void> _refreshActiveTimeEntry() async {
    try {
      final activeEntry = await ApiService.getActiveTimeEntry();
      
      setState(() {
        _isClockedIn = activeEntry != null;
      });
      
      if (_isClockedIn && activeEntry != null) {
        final startTime = DateTime.parse(activeEntry['startTime']);
        final elapsed = DateTime.now().difference(startTime);
        setState(() {
          _elapsedTimeString = _formatDuration(elapsed);
        });
        
        _loadActiveTasks();
        await _loadCurrentTimeEntryDetails();
      }
    } catch (e) {
      log('Error refreshing active time entry: $e');
    }
  }

  Future<void> _loadCurrentTimeEntryDetails() async {
    try {
      final activeEntry = await ApiService.getActiveTimeEntry();
      if (activeEntry != null) {
        final projectId = activeEntry['projectId'];
        final elevatorId = activeEntry['elevatorId'];
        final taskId = activeEntry['taskId'];
        
        // Set selected project
        for (var project in _projects) {
          if (project['id'] == projectId) {
            setState(() {
              _selectedProject = project;
            });
            break;
          }
        }
        
        // Load elevators and set selected elevator
        if (_selectedProject != null) {
          await _loadElevatorsForProject(_selectedProject['id']);
          for (var elevator in _elevators) {
            if (elevator['id'] == elevatorId) {
              setState(() {
                _selectedElevator = elevator;
              });
              break;
            }
          }
        }
        
        // Make sure all categories are loaded
        if (_taskCategories.isEmpty) {
          await _loadTaskCategories();
        }
        
        // Find the task and its category
        // First we need to load all tasks for all categories
        for (var category in _taskCategories) {
          if (!_tasksMap.containsKey(category.id)) {
            await _loadTasksForCategory(category.id);
          }
        }
        
        // Now search for the task in all loaded tasks
        TaskCategory? foundCategory;
        Task? foundTask;
        
        for (var category in _taskCategories) {
          final tasks = _tasksMap[category.id] ?? [];
          for (var task in tasks) {
            if (task.id == taskId) {
              foundCategory = category;
              foundTask = task;
              break;
            }
          }
          if (foundTask != null) break;
        }
        
        if (foundCategory != null && foundTask != null) {
          setState(() {
            _selectedCategory = foundCategory;
            _selectedTask = foundTask;
          });
        }
      }
    } catch (e) {
      log('Error loading current time entry details: $e');
    }
  }

  Future<void> _loadProjects() async {
    try {
      if (mounted) {
        setState(() {
          _isProjectsLoading = true;
        });
      }
      
      final projects = await ApiService.getProjects();
      
      if (mounted) {
        setState(() {
          _projects = projects;
          _isProjectsLoading = false;
          
          // Select first project by default if available
          if (_projects.isNotEmpty && _selectedProject == null) {
            _selectedProject = _projects[0];
            _loadElevatorsForProject(_selectedProject['id']);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isProjectsLoading = false;
      });
  
      _showErrorSnackBar('Failed to load projects: $e');
    }
  }

  Future<void> _loadElevatorsForProject(String projectId) async {
    try {
      if (mounted) {
        setState(() {
          _isElevatorsLoading = true;
          if (_selectedProject == null || _selectedProject['id'] != projectId) {
            _selectedElevator = null;
          }
        });
      }
      
      final elevators = await ApiService.getElevatorsForProject(projectId);
      if (mounted) {
        setState(() {
          _elevators = elevators;
          _isElevatorsLoading = false;
          
          // Select first elevator by default if available and none is selected
          if (_elevators.isNotEmpty && _selectedElevator == null) {
            _selectedElevator = _elevators[0];
          }
        });
      }
    } catch (e) {
      setState(() {
        _isElevatorsLoading = false;
      });
      _showErrorSnackBar('Failed to load elevators: $e');
    }
  }

  Future<void> _loadTaskCategories() async {
    try {
      if (mounted) {
        setState(() {
          _isTaskCategoriesLoading = true;
        });
      }
      
      final categories = await ApiService.getTaskCategories();
      if (mounted) {
        setState(() {
          _taskCategories = categories.cast<TaskCategory>();
          _isTaskCategoriesLoading = false;
          
          // Select first category by default if available
          if (_taskCategories.isNotEmpty && _selectedCategory == null) {
            _selectedCategory = _taskCategories[0];
            _loadTasksForCategory(_selectedCategory!.id);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isTaskCategoriesLoading = false;
      });
      _showErrorSnackBar('Failed to load task categories: $e');
    }
  }

  Future<void> _loadTasksForCategory(String categoryId) async {
    // Check if tasks for this category are already loaded
    if (_tasksMap.containsKey(categoryId)) {
      // Tasks already loaded, just update the selected task if needed
      final tasks = _tasksMap[categoryId] ?? [];
      if (tasks.isNotEmpty && (_selectedTask == null || _selectedTask!.categoryId != categoryId)) {
        setState(() {
          _selectedTask = tasks[0] as Task?;
        });
      }
      return;
    }
    
    try {
      if (mounted) {
        setState(() {
          _isTasksLoading = true;
          // Only clear selected task if category changed
          if (_selectedTask != null && _selectedTask!.categoryId != categoryId) {
            _selectedTask = null;
          }
        });
      }
      
      final tasks = await ApiService.getTasksForCategory(categoryId);
      if (mounted) {
        setState(() {
          _tasksMap[categoryId] = tasks.map((task) => Task(
            id: task.id,
            name: task.name,
            description: task.description,
            categoryId: task.categoryId,
          )).toList();
          _isTasksLoading = false;
          
          // Select first task by default if available and none is selected or category changed
          if (tasks.isNotEmpty && (_selectedTask == null || _selectedTask!.categoryId != categoryId)) {
            _selectedTask = tasks[0] as Task?;
          }
        });
      }
    } catch (e) {
      setState(() {
        _isTasksLoading = false;
      });
      _showErrorSnackBar('Failed to load tasks: $e');
    }
  }

  Future<void> _loadTodaySummary() async {
    try {
      final summary = await ApiService.getTimeEntrySummary();
      if (mounted) {
        setState(() {
          _todayTotalMinutes = summary['totalMinutes'] ?? 0;
          _todayRegularMinutes = summary['regularMinutes'] ?? 0;
          _todayOvertimeMinutes = summary['overtimeMinutes'] ?? 0;
        });
      }
    } catch (e) {
      log('Error loading today\'s summary: $e');
    }
  }

  Future<void> _loadActiveTasks() async {
    setState(() {
      _isLoadingActiveEntry = true;
    });
    
    try {
      final activeEntry = await ApiService.getActiveTimeEntry();
      
      if (activeEntry != null && activeEntry['active'] == true) {
        setState(() {
          _activeTimeEntry = activeEntry;
          _isClockedIn = true;
          
          // Extract current task
          if (activeEntry['timeEntry'] != null && activeEntry['timeEntry']['currentTask'] != null) {
            final currentTaskData = activeEntry['timeEntry']['currentTask'];
            _currentTask = TimeEntryTask(
              id: currentTaskData['id'],
              name: currentTaskData['name'],
              description: currentTaskData['description'] ?? '',
              startTime: DateTime.parse(currentTaskData['startTime']),
              endTime: null,
              notes: currentTaskData['notes'] ?? '',
              isCurrent: true,
            );
            
            // Set selected task for task switching
            if (_selectedTask == null || _selectedTask!.id != _currentTask!.id) {
              for (var category in _taskCategories) {
                final tasks = _tasksMap[category.id] ?? [];
                for (var task in tasks) {
                  if (task.id == _currentTask!.id) {
                    _selectedTask = task;
                    _selectedCategory = category;
                    break;
                  }
                }
                if (_selectedTask != null) break;
              }
            }
          }
          
          // Extract task categories with tasks
          if (activeEntry['timeEntry'] != null && activeEntry['timeEntry']['taskCategories'] != null) {
            _categoriesWithTasks = (activeEntry['timeEntry']['taskCategories'] as List)
                .map((categoryJson) => TaskCategoryWithTasks.fromJson(categoryJson))
                .toList();
          }
        });
        
        // Load project and elevator data
        await _loadCurrentTimeEntryDetails();
      } else {
        setState(() {
          _isClockedIn = false;
          _activeTimeEntry = null;
          _currentTask = null;
          _categoriesWithTasks = []; // Updated to use the new list
        });
        
        // Get today's time entries instead
        final todayData = await ApiService.getTodayTimeEntries();
        
        if (todayData['timeEntries'] != null) {
          // Process today's time entries for the "Today's Activities" section
          final timeEntries = todayData['timeEntries'] as List;
          
          // Extract task categories from the daily summary
          List<TaskCategoryWithTasks> categories = [];
          
          for (var entry in timeEntries) {
            if (entry['taskCategories'] != null) {
              categories.addAll(
                (entry['taskCategories'] as List)
                    .map((categoryJson) => TaskCategoryWithTasks.fromJson(categoryJson))
                    .toList()
              );
            }
          }
          
          setState(() {
            _categoriesWithTasks = categories; // Updated to use the new list
          });
        }
      }
    } catch (e) {
      log('Error loading active tasks: $e');
    } finally {
      setState(() {
        _isLoadingActiveEntry = false;
      });
    }
  }

  Future<void> _toggleClockInOut() async {
    if (_isClockingInOut) return;
    
    if (_isClockedIn) {
      _showLeavingEarlyPrompt();
    } else {
      if (_selectedProject == null || _selectedElevator == null || _selectedTask == null) {
        _showErrorSnackBar('Please select project, elevator, and task before clocking in.');
        return;
      }
      
      _showLatePrompt();
    }
  }

  Future<void> _clockIn({bool adjustedTime = false}) async {
    if (_isClockingInOut) return;
    
    // Make sure project and elevator are selected
    if (_selectedProject == null || _selectedElevator == null || _selectedTask == null) {
      _showErrorSnackBar('Please select project, elevator, and task before clocking in.');
      return;
    }
    
    setState(() {
      _isClockingInOut = true;
      _isLocationChecking = true;
    });
    
    try {
      // First verify location before proceeding
      log('Verifying location for project: ${_selectedProject['id']}');
      final isLocationVerified = await _timeTrackingService.verifyLocation(_selectedProject['id']);
      
      if (!isLocationVerified) {
        setState(() {
          _isClockingInOut = false;
          _isLocationChecking = false;
        });
        _showErrorSnackBar('Location verification failed. Please make sure you are at the job site.');
        return;
      }
      
      log('Location verified successfully');
      
      // Determine if currently in regular hours (7am to 3:30pm on weekdays)
      final now = DateTime.now();
      final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
      final hour = now.hour;
      final isRegularHours = !isWeekend && (hour >= 7 && (hour < 15 || (hour == 15 && now.minute <= 30)));
      
      final success = await _timeTrackingService.startTimeEntry(
        projectId: _selectedProject['id'],
        elevatorId: _selectedElevator['id'],
        taskId: _selectedTask!.id,
        isRegularHours: isRegularHours,
      );
      
      setState(() {
        _isClockingInOut = false;
        _isLocationChecking = false;
        _isClockedIn = success;
      });
      
      if (success) {
        _showSuccessMessage('You have successfully clocked in.');
        // Reload active tasks after clocking in
        _loadActiveTasks();
      } else {
        _showErrorSnackBar('Failed to clock in. Please try again.');
      }
    } catch (e) {
      log('Error clocking in: $e');
      setState(() {
        _isClockingInOut = false;
        _isLocationChecking = false;
      });
      _showErrorSnackBar('Error clocking in: $e');
    }
  }

  Future<void> _clockOut({bool adjustedTime = false}) async {
    if (_isClockingInOut) return;
    
    setState(() {
      _isClockingInOut = true;
    });
    
    try {
      final success = await _timeTrackingService.completeTimeEntry();
      
      setState(() {
        _isClockingInOut = false;
        _isClockedIn = !success;
      });
      
      if (success) {
        _showSuccessMessage('You have successfully clocked out.');
        _loadTodaySummary(); // Refresh summary after clocking out
        _loadActiveTasks(); // Refresh active tasks
      } else {
        _showErrorSnackBar('Failed to clock out. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isClockingInOut = false;
      });
      _showErrorSnackBar('Error clocking out: $e');
    }
  }

  // Add this method to handle task switching
  Future<void> _switchTask() async {
    if (_selectedTask == null) {
      _showErrorSnackBar('Please select a task to switch to.');
      return;
    }
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Call API to update the active time entry
      await ApiService.updateActiveTimeEntry(
        taskId: _selectedTask!.id,
      );
      
      // Refresh active task data
      await _loadActiveTasks();
      
      setState(() {
        _isLoading = false;
      });
      
      _showSuccessMessage('Successfully switched to task: ${_selectedTask!.name}');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to switch task: $e');
    }
  }

  void _showLatePrompt() {
    // Check if current time is after 7 AM
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final isAfterStartTime = now.hour > 7 || (now.hour == 7 && now.minute > 0);
    
    if (!isWeekend && isAfterStartTime) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF1E1E1E),
            title: Text(
              'Are you aware you\'re late today?',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Regular work hours begin at 7AM.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
                onPressed: () {
                  Navigator.pop(context);
                  _clockIn();
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  // Do nothing, time continues running
                },
              )
            ],
          );
        },
      );
    } else {
      _clockIn();
    }
  }

  void _showLeavingEarlyPrompt() {
    // Check if current time is before 3:30 PM on weekdays
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final isBeforeEndTime = now.hour < 15 || (now.hour == 15 && now.minute < 30);
    
    if (!isWeekend && isBeforeEndTime) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF1E1E1E),
            title: Text(
              'Are you leaving early today?',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Regular work hours ends at 3:30PM.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
                onPressed: () {
                  Navigator.pop(context);
                  _clockOut();
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  // Do nothing, time continues running
                },
              ),
            ],
          );
        },
      );
    } else {
      _clockOut();
    }
  }

  // ignore: unused_element
  void _showLunchPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text(
            'Did you take lunch today?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'A 30-minute unpaid lunch break is required.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
              onPressed: () {
                Navigator.pop(context);
                // Continue with clock out process
                _clockOut();
              },
            ),
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
                _showNoLunchApprovalPrompt();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoLunchApprovalPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text(
            'No Lunch Break',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Did you get approval from the Construction Foreman to skip lunch?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Yes', style: TextStyle(color: Color(0xFFF7D104))),
              onPressed: () {
                Navigator.pop(context);
                // Continue with clock out process
                _clockOut();
              },
            ),
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                _showErrorSnackBar('Lunch break is required unless approved by the Construction Foreman.');
              },
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _showAdjustTimeDialog({required bool isClockingIn}) {
    final now = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text(
            isClockingIn ? 'Adjust Start Time' : 'Adjust End Time',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isClockingIn 
                  ? 'Please enter your actual arrival time:'
                  : 'Please enter your actual departure time:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF7D104),
                  foregroundColor: Colors.black,
                ),
                child: Text('Select Time'),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Color(0xFFF7D104),
                            onPrimary: Colors.black,
                            surface: Color(0xFF1E1E1E),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Color(0xFFF7D104))),
              onPressed: () {
                Navigator.pop(context);
                if (isClockingIn) {
                  _clockIn(adjustedTime: true);
                } else {
                  _clockOut(adjustedTime: true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours}h ${mins}m";
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Time Tracking',
      currentIndex: 3, // Update this based on your navigation index
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
          : _buildMainContent(),
    );
  }


  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Clock Display Section
            _buildClockDisplaySection(),
            
            // Today's Summary Section
            _buildTodaySummarySection(),
            
            // Project Selection Section
            _buildProjectSelectionSection(),

            // **Moved Task Selection Section Above Clock In/Out Section**
            if (_isClockedIn) 
              _buildTaskSelectionSection()
            else
              _buildTaskCategorySection(),
            
            // Clock In/Out Section
            _buildClockInOutSection(),
            
            // Active Tasks Section
            SizedBox(
              height: 300, // Fixed height or calculate dynamically
              child: _buildActiveTasksSection(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildClockDisplaySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Current Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Time',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _currentTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          // Elapsed Time (only shown when clocked in)
          if (_isClockedIn)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Elapsed Time',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _elapsedTimeString,
                  style: TextStyle(
                    color: Color(0xFFF7D104),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTodaySummarySection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildSummaryItem(
            label: 'Regular',
            value: _formatMinutes(_todayRegularMinutes),
            color: Colors.green,
          ),
          _buildSummaryItem(
            label: 'Overtime',
            value: _formatMinutes(_todayOvertimeMinutes),
            color: Colors.orange,
          ),
          _buildSummaryItem(
            label: 'Total',
            value: _formatMinutes(_todayTotalMinutes),
            color: Color(0xFFF7D104),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSelectionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Site Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          // **Updated Layout: Double Column in a Single Row**
          Row(
            children: [
              // Project Dropdown
              Expanded(
                child: _isProjectsLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                    : _buildDropdownWithCheck<String>(
                        value: _selectedProject != null ? _selectedProject['id'] : null,
                        items: _projects.map((project) => DropdownMenuItem<String>(
                          value: project['id'],
                          child: Text(
                            project['name'], 
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                        onChanged: !_isClockedIn ? (value) {
                          if (value != null) {
                            // Find project safely with null check
                            final projectIndex = _projects.indexWhere((project) => project['id'] == value);
                            if (projectIndex >= 0) {
                              setState(() {
                                _selectedProject = _projects[projectIndex];
                              });
                              _loadElevatorsForProject(value);
                            } else {
                              log('Project with ID $value not found');
                            }
                          }
                        } : null,
                        hint: 'Select Project',
                      ),
              ),
                
              SizedBox(width: 16),
                
              // Elevator Dropdown
              Expanded(
                child: _isElevatorsLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                    : _buildDropdownWithCheck<String>(
                      value: _selectedElevator != null ? _selectedElevator['id'] : null,
                      items: _elevators.map((elevator) => DropdownMenuItem<String>(
                        value: elevator['id'],
                        child: Text(
                          elevator['number'] ?? 'Elevator ${elevator['elevatorNumber']}', 
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )).toList(),
                      onChanged: !_isClockedIn ? (value) {
                        if (value != null) {
                          // Find elevator safely with null check
                          final elevatorIndex = _elevators.indexWhere((elevator) => elevator['id'] == value);
                          if (elevatorIndex >= 0) {
                            setState(() {
                              _selectedElevator = _elevators[elevatorIndex];
                            });
                          } else {
                            log('Elevator with ID $value not found');
                          }
                        }
                      } : null,
                      hint: 'Select Elevator',
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithCheck<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?)? onChanged,
    required String hint,
  }) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: null,
            items: [],
            onChanged: null,
            hint: Text(hint, style: TextStyle(color: Colors.white70)),
            dropdownColor: Color(0xFF2A2A2A),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
            disabledHint: Text('No items available', style: TextStyle(color: Colors.white70)),
          ),
        ),
      );
    }

    // Use a Map to eliminate duplicates while preserving the last instance of each value
    final Map<dynamic, DropdownMenuItem<T>> uniqueItems = {};
    
    for (var item in items) {
      if (item.value != null) {
        uniqueItems[item.value] = item;
      }
    }
    
    final List<DropdownMenuItem<T>> finalItems = uniqueItems.values.toList();
    
    // Check if the selected value exists in the items
    bool valueExists = false;
    if (value != null) {
      valueExists = finalItems.any((item) => item.value == value);
    }
    
    // If the value doesn't exist and is not null, we need to add a placeholder
    if (value != null && !valueExists) {
      finalItems.add(DropdownMenuItem<T>(
        value: value,
        child: Text(
          "Selected item", 
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: valueExists || value == null ? value : null,
          items: finalItems,
          onChanged: onChanged,
          hint: Text(hint, style: TextStyle(color: Colors.white70)),
          dropdownColor: Color(0xFF2A2A2A),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
        ),
      ),
    );
  }

  Widget _buildClockInOutSection() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isClockedIn ? Colors.redAccent : Color(0xFFF7D104),
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: Size(200, 60),
        ),
        onPressed: _isClockingInOut ? null : _toggleClockInOut,
        child: _isClockingInOut
            ? _isLocationChecking
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Verifying Location...'),
                    ],
                  )
                : CircularProgressIndicator(color: Colors.black)
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isClockedIn ? Icons.logout : Icons.login,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _isClockedIn ? 'CLOCK OUT' : 'CLOCK IN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTaskSelectionSection() {
    return Column(
      children: [
        // Current Task Section
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _isLoadingActiveEntry 
                  ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                  : Text(
                      _currentTask?.name ?? (_selectedTask?.name ?? 'No Task Selected'),
                      style: TextStyle(
                        color: Color(0xFFF7D104),
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
              SizedBox(height: 8),
              if (_currentTask != null)
                Text(
                  'Started at: ${DateFormat('HH:mm').format(_currentTask!.startTime)}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                _selectedProject != null && _selectedElevator != null ? 
                  'Project: ${_selectedProject?['name'] ?? 'Unknown'} | Elevator: ${_selectedElevator?['elevatorNumber'] ?? 'Unknown'}' :
                  'Project & Elevator Information Unavailable',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        
        // Select New Task Section
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              // Task Category Selection
              _isTaskCategoriesLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                  : SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _taskCategories.length,
                        itemBuilder: (context, index) {
                          final category = _taskCategories[index];
                          final isSelected = _selectedCategory?.id == category.id;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _loadTasksForCategory(category.id);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFFF7D104) : Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  category.code,
                                  style: TextStyle(
                                    color: isSelected ? Colors.black : Colors.white,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              
              SizedBox(height: 16),
              
              // Task Selection and Switch Button
              Row(
                children: [
                  Expanded(
                    child: _selectedCategory != null
                      ? _isTasksLoading
                          ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                          : _buildDropdownWithCheck<String>(
                              value: _selectedTask?.id,
                              items: (_tasksMap[_selectedCategory!.id] ?? []).map((task) => 
                                DropdownMenuItem<String>(
                                  value: task.id,
                                  child: Text(
                                    task.name, 
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final selectedTasks = _tasksMap[_selectedCategory!.id] ?? [];
                                  final taskIndex = selectedTasks.indexWhere((task) => task.id == value);
                                  if (taskIndex >= 0) {
                                    setState(() {
                                      _selectedTask = selectedTasks[taskIndex];
                                    });
                                  } else {
                                    log('Task with ID $value not found');
                                  }
                                }
                              },
                              hint: 'Select Task',
                            )
                      : SizedBox(),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF7D104),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: _selectedTask != null ? _switchTask : null,
                    child: Text('Switch Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCategorySection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          // Task Category Selection
          _isTaskCategoriesLoading
              ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
              : SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _taskCategories.length,
                    itemBuilder: (context, index) {
                      final category = _taskCategories[index];
                      final isSelected = _selectedCategory?.id == category.id;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _loadTasksForCategory(category.id);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFF7D104) : Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              category.code,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          
          SizedBox(height: 16),
          
          // Task Selection
          if (_selectedCategory != null)
            _isTasksLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                : _buildDropdownWithCheck<Task>(
                    value: _selectedTask,
                    items: (_tasksMap[_selectedCategory!.id] ?? []).map((task) => DropdownMenuItem<Task>(
                      value: task,
                      child: Text(
                        task.name, 
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTask = value;
                      });
                    },
                    hint: 'Select Task',
                  ),
        ],
      ),
    );
  }
  
  Widget _buildActiveTasksSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isClockedIn ? 'Current Activities' : 'Today\'s Activities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          Expanded(
            child: _isLoadingActiveEntry 
              ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
              : _categoriesWithTasks.isEmpty  // Changed from _taskCategories to _categoriesWithTasks
                ? Center(
                    child: Text(
                      'No activities recorded yet',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _categoriesWithTasks.length,  // Changed from _taskCategories
                    itemBuilder: (context, index) {
                      final category = _categoriesWithTasks[index];  // Changed from _taskCategories
                      
                      // Skip categories with no tasks
                      if (category.tasks.isEmpty) {
                        return SizedBox.shrink();
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category heading
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          // Tasks in this category
                          ...category.tasks.map((task) {
                            final isCurrentTask = task.isCurrent || 
                              (_currentTask != null && task.id == _currentTask!.id);
                              
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                                border: isCurrentTask ? Border.all(
                                  color: Color(0xFFF7D104),
                                  width: 1.5,
                                ) : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.name,
                                          style: TextStyle(
                                            color: isCurrentTask ? Color(0xFFF7D104) : Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(task.duration),
                                        style: TextStyle(
                                          color: Color(0xFFF7D104),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    task.timeRange,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (task.notes.isNotEmpty) 
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        task.notes,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  String _getCategoryCodeForTask(Task task) {
    for (var category in _taskCategories) {
      if (category.id == task.categoryId) {
        return category.code;
      }
    }
    return 'Unknown';
  }

  // ignore: unused_element
  Widget _buildDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?)? onChanged,
    required String hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          hint: Text(hint, style: TextStyle(color: Colors.white70)),
          dropdownColor: Color(0xFF2A2A2A),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFFF7D104)),
        ),
      ),
    );
  }
}