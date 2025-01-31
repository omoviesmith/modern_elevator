// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   bool _isDarkMode = false; // For dark mode toggle
//   bool _isClockedIn = false;
//   String _currentTime = '';
//   String _selectedJobSite = 'Select Job Site';
//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();
//     _updateTime();

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   void _updateTime() {
//     setState(() {
//       _currentTime = DateFormat('HH mm:ss').format(DateTime.now());
//     });
//     Future.delayed(Duration(seconds: 1), _updateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeaderSection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Status Bar Placeholder (Time, Battery, Network)
//           SizedBox(height: 24),
//           // Back Button and Time Display
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Digital Clock Display
//               Text(
//                 _currentTime.replaceFirst(' ', ':'),
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Placeholder for alignment
//               SizedBox(width: 48),
//             ],
//           ),
//           SizedBox(height: 16),
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobSiteSelectionArea() {
//     return Stack(
//       children: [
//         // Glass-morphism background
//         Container(
//           margin: EdgeInsets.all(16),
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//             backgroundBlendMode: BlendMode.overlay,
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Column(
//               children: [
//                 // Job Site Dropdown
//                 _buildJobSiteDropdown(),
//                 SizedBox(height: 16),
//                 // GPS Verification Icon
//                 _buildGPSVerificationIcon(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 18,
//                       color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value!;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Image.asset(
//             'assets/images/magnifying_glass_yellow.png',
//             width: 24,
//             height: 24,
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isVerifyingGPS = false;
//         _isGPSVerified = true;
//       });
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isDarkMode ? Colors.black : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn ? Color(0xFFF7D104).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _isDarkMode ? Colors.black : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt({required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isDarkMode ? Colors.white : Color(0xFF040404),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.black : Colors.white, backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.white : Colors.black, backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? (_isDarkMode ? Colors.black : Colors.white) : (_isDarkMode ? Colors.white : Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             color: _isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive ? Color(0xFFF7D104).withOpacity(0.5) : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color: _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }


// // Time Tracking Screen with updated fonts
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   bool _isDarkMode = false; // For dark mode toggle
//   bool _isClockedIn = false;
//   String _currentTime = '';
//   String _selectedJobSite = 'Select Job Site';
//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();
//     _updateTime();

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   void _updateTime() {
//     setState(() {
//       _currentTime = DateFormat('HH mm:ss').format(DateTime.now());
//     });
//     Future.delayed(Duration(seconds: 1), _updateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeaderSection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Status Bar Placeholder (Time, Battery, Network)
//           SizedBox(height: 24),
//           // Back Button and Time Display
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Digital Clock Display
//               Text(
//                 _currentTime.replaceFirst(' ', ':'),
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Placeholder for alignment
//               SizedBox(width: 48),
//             ],
//           ),
//           SizedBox(height: 16),
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobSiteSelectionArea() {
//     return Stack(
//       children: [
//         // Glass-morphism background
//         Container(
//           margin: EdgeInsets.all(16),
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//             backgroundBlendMode: BlendMode.overlay,
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Column(
//               children: [
//                 // Job Site Dropdown
//                 _buildJobSiteDropdown(),
//                 SizedBox(height: 16),
//                 // GPS Verification Icon
//                 _buildGPSVerificationIcon(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'SFProDisplay',
//                       fontSize: 18,
//                       color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value!;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Image.asset(
//             'assets/images/magnifying_glass_yellow.png',
//             width: 24,
//             height: 24,
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isVerifyingGPS = false;
//         _isGPSVerified = true;
//       });
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isDarkMode ? Colors.black : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn ? Color(0xFFF7D104).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'SFProDisplay',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _isDarkMode ? Colors.black : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt({required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'SFProDisplay',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isDarkMode ? Colors.white : Color(0xFF040404),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.black : Colors.white, backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.white : Colors.black, backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'SFProDisplay',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? (_isDarkMode ? Colors.black : Colors.white) : (_isDarkMode ? Colors.white : Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'SFProDisplay',
//             fontSize: 16,
//             color: _isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive ? Color(0xFFF7D104).withOpacity(0.5) : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'SFProDisplay',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color: _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }


// // lib/screens/time_tracking_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   bool _isDarkMode = false; // For dark mode toggle
//   bool _isClockedIn = false;
//   String _currentTime = '';

//   // Set _selectedJobSite to null initially
//   String? _selectedJobSite;

//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();
//     _updateTime();

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   void _updateTime() {
//     setState(() {
//       _currentTime = DateFormat('HH mm:ss').format(DateTime.now());
//     });
//     Future.delayed(Duration(seconds: 1), _updateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeaderSection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     // Get screen size for responsive design
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // 4% of screen width
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Status Bar Placeholder (Time, Battery, Network)
//           SizedBox(height: screenHeight * 0.03), // 3% of screen height
//           // Back Button and Time Display
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                   size: screenWidth * 0.06, // 6% of screen width
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Digital Clock Display
//               Text(
//                 _currentTime.replaceFirst(' ', ':'),
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: screenWidth * 0.08, // 8% of screen width
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Placeholder for alignment
//               SizedBox(width: screenWidth * 0.12), // 12% of screen width
//             ],
//           ),
//           SizedBox(height: screenHeight * 0.02), // 2% of screen height
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
// }

//   // Widget _buildHeaderSection() {
//   //   return Container(
//   //     padding: EdgeInsets.symmetric(horizontal: 16),
//   //     decoration: BoxDecoration(
//   //       gradient: LinearGradient(
//   //         colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//   //         begin: Alignment.topCenter,
//   //         end: Alignment.bottomCenter,
//   //       ),
//   //     ),
//   //     child: Column(
//   //       children: [
//   //         // Status Bar Placeholder (Time, Battery, Network)
//   //         SizedBox(height: 24),
//   //         // Back Button and Time Display
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             // Back Button
//   //             IconButton(
//   //               icon: Icon(
//   //                 Icons.arrow_back_ios,
//   //                 color: Colors.white,
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.pop(context);
//   //               },
//   //             ),
//   //             // Digital Clock Display
//   //             Text(
//   //               _currentTime.replaceFirst(' ', ':'),
//   //               style: TextStyle(
//   //                 fontFamily: 'Inter',
//   //                 fontSize: 32,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: Colors.white,
//   //               ),
//   //             ),
//   //             // Placeholder for alignment
//   //             SizedBox(width: 48),
//   //           ],
//   //         ),
//   //         SizedBox(height: 16),
//   //         // Yellow Accent Line
//   //         Container(
//   //           height: 1,
//   //           color: Color(0xFFF7D104),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildJobSiteSelectionArea() {
//     return Stack(
//       children: [
//         // Glass-morphism background
//         Container(
//           margin: EdgeInsets.all(16),
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//             backgroundBlendMode: BlendMode.overlay,
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Column(
//               children: [
//                 // Job Site Dropdown
//                 _buildJobSiteDropdown(),
//                 SizedBox(height: 16),
//                 // GPS Verification Icon
//                 _buildGPSVerificationIcon(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 18,
//                       color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Image.asset(
//             'assets/images/magnifying_glass_yellow.png',
//             width: 24,
//             height: 24,
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isVerifyingGPS = false;
//         _isGPSVerified = true;
//       });
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isDarkMode ? Colors.black : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn ? Color(0xFFF7D104).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _isDarkMode ? Colors.black : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt({required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isDarkMode ? Colors.white : Color(0xFF040404),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.black : Colors.white, backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.white : Colors.black, backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? (_isDarkMode ? Colors.black : Colors.white) : (_isDarkMode ? Colors.white : Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             color: _isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive ? Color(0xFFF7D104).withOpacity(0.5) : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color: _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }

//lib/screens/time_tracking_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   bool _isDarkMode = false; // For dark mode toggle
//   bool _isClockedIn = false;
//   String _currentTime = '';

//   // Set _selectedJobSite to null initially
//   String? _selectedJobSite;

//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();
//     _updateTime();

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   void _updateTime() {
//     setState(() {
//       _currentTime = DateFormat('HH mm:ss').format(DateTime.now());
//     });
//     Future.delayed(Duration(seconds: 1), _updateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeaderSection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Status Bar Placeholder (Time, Battery, Network)
//           SizedBox(height: 24),
//           // Back Button and Time Display
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Digital Clock Display
//               Text(
//                 _currentTime.replaceFirst(' ', ':'),
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Placeholder for alignment
//               SizedBox(width: 48),
//             ],
//           ),
//           SizedBox(height: 16),
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobSiteSelectionArea() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
//               // Remove backgroundBlendMode to prevent unintended blending
//             ),
//             child: Column(
//               children: [
//                 // Job Site Dropdown
//                 _buildJobSiteDropdown(),
//                 SizedBox(height: 16),
//                 // GPS Verification Icon
//                 _buildGPSVerificationIcon(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 18,
//                       color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Icon(
//             Icons.search,
//             color: Color(0xFFF7D104),
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isVerifyingGPS = false;
//         _isGPSVerified = true;
//       });
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isDarkMode ? Colors.black : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn ? Color(0xFFF7D104).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _isDarkMode ? Colors.black : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt({required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isDarkMode ? Colors.white : Color(0xFF040404),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.black : Colors.white, backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.white : Colors.black, backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? (_isDarkMode ? Colors.black : Colors.white) : (_isDarkMode ? Colors.white : Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             color: _isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive ? Color(0xFFF7D104).withOpacity(0.5) : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color: _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }

// //modern_elevator_app/lib/screens/time_tracking_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects
// import 'dart:async'; // For Timer

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   bool _isDarkMode = false; // For dark mode toggle
//   bool _isClockedIn = false;
//   String _currentTime = '';

//   // Set _selectedJobSite to null initially
//   String? _selectedJobSite;

//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   Timer? _timer; // Declare the timer

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();

//     // Start the timer to update time every second
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       if (mounted) {
//         setState(() {
//           _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
//         });
//       }
//     });

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer
//     super.dispose();
//   }

//   void _updateTime() {
//     // No longer needed since we're using Timer.periodic
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeaderSection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF040404), Color(0xFF1C1C1C)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Status Bar Placeholder (Time, Battery, Network)
//           SizedBox(height: 24),
//           // Back Button and Time Display
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back Button
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Digital Clock Display
//               Text(
//                 _currentTime.replaceFirst(' ', ':'),
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Placeholder for alignment
//               SizedBox(width: 48),
//             ],
//           ),
//           SizedBox(height: 16),
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobSiteSelectionArea() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
//               // Remove backgroundBlendMode to prevent unintended blending
//             ),
//             child: Column(
//               children: [
//                 // Job Site Dropdown
//                 _buildJobSiteDropdown(),
//                 SizedBox(height: 16),
//                 // GPS Verification Icon
//                 _buildGPSVerificationIcon(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 18,
//                       color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Icon(
//             Icons.search,
//             color: Color(0xFFF7D104),
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _isVerifyingGPS = false;
//           _isGPSVerified = true;
//         });
//       }
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isDarkMode ? Colors.black : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn ? Color(0xFFF7D104).withOpacity(0.7) : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _isDarkMode ? Colors.black : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt({required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isDarkMode ? Colors.white : Color(0xFF040404),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.black : Colors.white,
//                     backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: _isDarkMode ? Colors.white : Colors.black,
//                     backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive
//                         ? (_isDarkMode ? Colors.black : Colors.white)
//                         : (_isDarkMode ? Colors.white : Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             color: _isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive
//                       ? Color(0xFFF7D104).withOpacity(0.5)
//                       : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.white : Color(0xFF040404),
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color:
//                             _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:'
//         '${minutes.toString().padLeft(2, '0')}:'
//         '${seconds.toString().padLeft(2, '0')}';
//   }
// }

// modern_elevator_app/lib/screens/time_tracking_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:ui'; // For glass-morphism effects
// import 'dart:async'; // For Timer

// class TimeTrackingScreen extends StatefulWidget {
//   @override
//   _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
// }

// class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
//   // Setting dark mode to true
//   bool _isDarkMode = true;
//   bool _isClockedIn = false;
//   String _currentTime = '';

//   // Set _selectedJobSite to null initially
//   String? _selectedJobSite;

//   bool _isVerifyingGPS = false;
//   bool _isGPSVerified = false;

//   Timer? _timer; // Declare the timer

//   // Sample data
//   List<String> jobSites = [
//     'Marcy Ave',
//     'Lorimer',
//     'Flushing Ave',
//     'New Lots',
//   ];

//   List<String> taskCategories = [
//     'G1',
//     'G2',
//     'G3',
//     'A&P',
//     'SM',
//     'SRD',
//     'ENT',
//     'CAB',
//     'COM',
//   ];

//   String _activeCategory = 'G1';

//   // Tasks under each category
//   Map<String, List<String>> tasks = {
//     'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
//     'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
//     'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
//     // ... Add more tasks
//   };

//   // Selected tasks with timers
//   Map<String, Duration> selectedTasks = {};

//   // Timers for each task
//   Map<String, Stopwatch> taskTimers = {};

//   @override
//   void initState() {
//     super.initState();

//     // Start the timer to update time every second
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       if (mounted) {
//         setState(() {
//           _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
//         });
//       }
//     });

//     // Initialize timers for tasks
//     tasks.forEach((category, taskList) {
//       taskList.forEach((task) {
//         taskTimers[task] = Stopwatch();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer
//     super.dispose();
//   }

//   void _updateTime() {
//     // No longer needed since we're using Timer.periodic
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404), // Dark background
//       appBar: AppBar(
//         backgroundColor: Color(0xFF040404),
//         elevation: 0,
//         title: Text(
//           'Time Tracking',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontFamily: 'SF Pro Display',
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Clock Display Section
//             _buildClockDisplaySection(),
//             // Job Site Selection Area
//             _buildJobSiteSelectionArea(),
//             // Clock In/Out Section
//             _buildClockInOutSection(),
//             // Task Management Area
//             Expanded(child: _buildTaskManagementArea()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildClockDisplaySection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       color: Color(0xFF040404),
//       child: Column(
//         children: [
//           SizedBox(height: 16),
//           // Digital Clock Display
//           Text(
//             _currentTime,
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16),
//           // Yellow Accent Line
//           Container(
//             height: 1,
//             color: Color(0xFFF7D104),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildJobSiteSelectionArea() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Color(0xFF121212), // Dark grey background
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               // Job Site Dropdown
//               _buildJobSiteDropdown(),
//               SizedBox(height: 16),
//               // GPS Verification Icon
//               _buildGPSVerificationIcon(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildJobSiteDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedJobSite,
//               items: jobSites.map((site) {
//                 return DropdownMenuItem(
//                   value: site,
//                   child: Text(
//                     site,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedJobSite = value;
//                   _verifyGPS();
//                 });
//               },
//               hint: Text(
//                 'Select Job Site',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 18,
//                   color: Colors.grey,
//                 ),
//               ),
//               dropdownColor: Color(0xFF1E1E1E),
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Color(0xFFF7D104),
//               ),
//             ),
//           ),
//         ),
//         // Search Icon
//         IconButton(
//           icon: Icon(
//             Icons.search,
//             color: Color(0xFFF7D104),
//           ),
//           onPressed: () {
//             // Open search functionality
//             print('Search Job Sites');
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGPSVerificationIcon() {
//     return GestureDetector(
//       onTap: () {
//         _verifyGPS();
//       },
//       child: AnimatedContainer(
//         duration: Duration(seconds: 1),
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
//           shape: BoxShape.circle,
//         ),
//         child: _isVerifyingGPS
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : Icon(
//                 _isGPSVerified ? Icons.check : Icons.gps_fixed,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   void _verifyGPS() {
//     setState(() {
//       _isVerifyingGPS = true;
//     });

//     // Simulate GPS verification delay
//     Future.delayed(Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _isVerifyingGPS = false;
//           _isGPSVerified = true;
//         });
//       }
//     });
//   }

//   Widget _buildClockInOutSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: GestureDetector(
//           onTap: () {
//             _toggleClockInOut();
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Status Indicator Ring
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color(0xFF040404),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                     width: 4,
//                   ),
//                 ),
//               ),
//               // Clock In/Out Button
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
//                       _isClockedIn
//                           ? Color(0xFFF7D104).withOpacity(0.7)
//                           : Colors.grey.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     _isClockedIn ? 'Clock Out' : 'Clock In',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF040404),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleClockInOut() {
//     if (_isClockedIn) {
//       // Clocking Out
//       setState(() {
//         _isClockedIn = false;
//       });
//       // Show pop-up prompt
//       _showLeavingEarlyPrompt();
//     } else {
//       // Clocking In
//       setState(() {
//         _isClockedIn = true;
//       });
//       // Show pop-up prompt
//       _showLatePrompt();
//     }
//   }

//   void _showLatePrompt() {
//     // Show prompt asking if the user was late
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Were you late today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust start time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   void _showLeavingEarlyPrompt() {
//     // Show prompt asking if the user is leaving early
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return _buildPopupPrompt(
//           title: 'Are you leaving early today?',
//           onYes: () {
//             // Handle if yes
//             Navigator.of(context).pop();
//             // Allow user to adjust end time
//           },
//           onNo: () {
//             // Handle if no
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPopupPrompt(
//       {required String title, required Function onYes, required Function onNo}) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Color(0xFF1E1E1E),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => onYes(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Color(0xFF040404),
//                     backgroundColor: Color(0xFFF7D104),
//                   ),
//                   child: Text('Yes'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => onNo(),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.grey[800],
//                   ),
//                   child: Text('No'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskManagementArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           // Task Categories
//           _buildTaskCategories(),
//           SizedBox(height: 16),
//           // Task List
//           Expanded(
//             child: _buildTaskList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCategories() {
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: taskCategories.length,
//         itemBuilder: (context, index) {
//           String category = taskCategories[index];
//           bool isActive = _activeCategory == category;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _activeCategory = category;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? Color(0xFFF7D104) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isActive ? Color(0xFFF7D104) : Colors.grey,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: isActive ? Color(0xFF040404) : Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTaskList() {
//     List<String>? taskList = tasks[_activeCategory];

//     if (taskList == null || taskList.isEmpty) {
//       return Center(
//         child: Text(
//           'No tasks available',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: taskList.length,
//       itemBuilder: (context, index) {
//         String task = taskList[index];
//         bool isActive = selectedTasks.containsKey(task);

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               if (isActive) {
//                 // Stop timer
//                 taskTimers[task]?.stop();
//                 selectedTasks.remove(task);
//               } else {
//                 // Start timer
//                 taskTimers[task]?.start();
//                 selectedTasks[task] = Duration();
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: Color(0xFF121212), // Dark grey background
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isActive
//                       ? Color(0xFFF7D104).withOpacity(0.5)
//                       : Colors.black12,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value!) {
//                       taskTimers[task]?.start();
//                       selectedTasks[task] = Duration();
//                     } else {
//                       taskTimers[task]?.stop();
//                       selectedTasks.remove(task);
//                     }
//                   });
//                 },
//                 activeColor: Color(0xFFF7D104),
//                 checkColor: Color(0xFF040404),
//               ),
//               title: Text(
//                 task,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//               trailing: isActive
//                   ? Text(
//                       _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                         fontFeatures: [FontFeature.tabularFigures()],
//                         color: Colors.grey,
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = (duration.inMinutes % 60);
//     int seconds = (duration.inSeconds % 60);

//     return '${hours.toString().padLeft(2, '0')}:'
//         '${minutes.toString().padLeft(2, '0')}:'
//         '${seconds.toString().padLeft(2, '0')}';
//   }
// }


// modern_elevator_app/lib/screens/time_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../widgets/base_scaffold.dart';

class TimeTrackingScreen extends StatefulWidget {
  @override
  _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  bool _isClockedIn = false;
  String _currentTime = '';
  String? _selectedJobSite;
  bool _isVerifyingGPS = false;
  bool _isGPSVerified = false;
  Timer? _timer;

  // Sample data
  List<String> jobSites = [
    'Marcy Ave',
    'Lorimer',
    'Flushing Ave',
    'New Lots',
  ];

  List<String> taskCategories = [
    'G1',
    'G2',
    'G3',
    'A&P',
    'SM',
    'SRD',
    'ENT',
    'CAB',
    'COM',
  ];

  String _activeCategory = 'G1';

  // Tasks under each category
  Map<String, List<String>> tasks = {
    'G1': ['Safety Discussions, JHA', 'Install Car Rail Brackets', 'Install Car Rails'],
    'G2': ['Install Controller', 'Wire to Power Unit', 'Install Oil Cooler'],
    'G3': ['Install Platform', 'Set Up Guide Shoes', 'Fill Power Unit'],
    // ... Add more tasks
  };

  // Selected tasks with timers
  Map<String, Duration> selectedTasks = {};
  // Timers for each task
  Map<String, Stopwatch> taskTimers = {};

  @override
  void initState() {
    super.initState();

    // Start the timer to update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        });
      }
    });

    // Initialize timers for tasks
    tasks.forEach((category, taskList) {
      taskList.forEach((task) {
        taskTimers[task] = Stopwatch();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Time Tracking',
      currentIndex: 0,
      body: SafeArea(
        child: Column(
          children: [
            // Clock Display Section
            _buildClockDisplaySection(),
            // Job Site Selection Area
            _buildJobSiteSelectionArea(),
            // Clock In/Out Section
            _buildClockInOutSection(),
            // Task Management Area
            Expanded(child: _buildTaskManagementArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildClockDisplaySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color(0xFF040404),
      child: Column(
        children: [
          SizedBox(height: 16),
          // Digital Clock Display
          Text(
            _currentTime,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          // Yellow Accent Line
          Container(
            height: 1,
            color: Color(0xFFF7D104),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSiteSelectionArea() {
    return Container(
      margin: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF121212), // Dark grey background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Job Site Dropdown
              _buildJobSiteDropdown(),
              SizedBox(height: 16),
              // GPS Verification Icon
              _buildGPSVerificationIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobSiteDropdown() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedJobSite,
              items: jobSites.map((site) {
                return DropdownMenuItem(
                  value: site,
                  child: Text(
                    site,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJobSite = value;
                  _verifyGPS();
                });
              },
              hint: Text(
                'Select Job Site',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              dropdownColor: Color(0xFF1E1E1E),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFF7D104),
              ),
            ),
          ),
        ),
        // Search Icon
        IconButton(
          icon: Icon(
            Icons.search,
            color: Color(0xFFF7D104),
          ),
          onPressed: () {
            // Open search functionality
            print('Search Job Sites');
          },
        ),
      ],
    );
  }

  Widget _buildGPSVerificationIcon() {
    return GestureDetector(
      onTap: () {
        _verifyGPS();
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _isGPSVerified ? Colors.green : Color(0xFFF7D104),
          shape: BoxShape.circle,
        ),
        child: _isVerifyingGPS
            ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Icon(
                _isGPSVerified ? Icons.check : Icons.gps_fixed,
                color: Colors.white,
              ),
      ),
    );
  }

  void _verifyGPS() {
    setState(() {
      _isVerifyingGPS = true;
    });

    // Simulate GPS verification delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVerifyingGPS = false;
          _isGPSVerified = true;
        });
      }
    });
  }

  Widget _buildClockInOutSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: GestureDetector(
          onTap: () {
            _toggleClockInOut();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Status Indicator Ring
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF040404),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    ),
                  ],
                  border: Border.all(
                    color: _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
                    width: 4,
                  ),
                ),
              ),
              // Clock In/Out Button
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _isClockedIn ? Color(0xFFF7D104) : Colors.grey,
                      _isClockedIn
                          ? Color(0xFFF7D104).withOpacity(0.7)
                          : Colors.grey.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _isClockedIn ? 'Clock Out' : 'Clock In',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF040404),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleClockInOut() {
    if (_isClockedIn) {
      // Clocking Out
      setState(() {
        _isClockedIn = false;
      });
      // Show pop-up prompt
      _showLeavingEarlyPrompt();
    } else {
      // Clocking In
      setState(() {
        _isClockedIn = true;
      });
      // Show pop-up prompt
      _showLatePrompt();
    }
  }

  void _showLatePrompt() {
    // Show prompt asking if the user was late
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildPopupPrompt(
          title: 'Were you late today?',
          onYes: () {
            // Handle if yes
            Navigator.of(context).pop();
            // Allow user to adjust start time
          },
          onNo: () {
            // Handle if no
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showLeavingEarlyPrompt() {
    // Show prompt asking if the user is leaving early
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildPopupPrompt(
          title: 'Are you leaving early today?',
          onYes: () {
            // Handle if yes
            Navigator.of(context).pop();
            // Allow user to adjust end time
          },
          onNo: () {
            // Handle if no
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget _buildPopupPrompt(
      {required String title, required Function onYes, required Function onNo}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Color(0xFF1E1E1E),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => onYes(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF040404),
                    backgroundColor: Color(0xFFF7D104),
                  ),
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () => onNo(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey[800],
                  ),
                  child: Text('No'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskManagementArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Task Categories
          _buildTaskCategories(),
          SizedBox(height: 16),
          // Task List
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCategories() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: taskCategories.length,
        itemBuilder: (context, index) {
          String category = taskCategories[index];
          bool isActive = _activeCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                _activeCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFF7D104) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? Color(0xFFF7D104) : Colors.grey,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Color(0xFF040404) : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList() {
    List<String>? taskList = tasks[_activeCategory];

    if (taskList == null || taskList.isEmpty) {
      return Center(
        child: Text(
          'No tasks available',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        String task = taskList[index];
        bool isActive = selectedTasks.containsKey(task);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isActive) {
                // Stop timer
                taskTimers[task]?.stop();
                selectedTasks.remove(task);
              } else {
                // Start timer
                taskTimers[task]?.start();
                selectedTasks[task] = Duration();
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Color(0xFF121212), // Dark grey background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? Color(0xFFF7D104).withOpacity(0.5)
                      : Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListTile(
              leading: Checkbox(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      taskTimers[task]?.start();
                      selectedTasks[task] = Duration();
                    } else {
                      taskTimers[task]?.stop();
                      selectedTasks.remove(task);
                    }
                  });
                },
                activeColor: Color(0xFFF7D104),
                checkColor: Color(0xFF040404),
              ),
              title: Text(
                task,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              trailing: isActive
                  ? Text(
                      _formatDuration(taskTimers[task]?.elapsed ?? Duration()),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontFeatures: [FontFeature.tabularFigures()],
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}