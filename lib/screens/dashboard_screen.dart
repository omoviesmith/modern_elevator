// //modern_elevator_app/lib/screens/dashboard_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../widgets/base_scaffold.dart';
// import '../services/api_service.dart';
// import 'dart:developer';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool _isLoading = true;
//   bool _isError = false;
//   String _errorMessage = '';
//   Map<String, dynamic> _dashboardData = {};
//   Map<String, dynamic> _quickStats = {};
//   bool _isAdmin = false;
//   String _userName = 'User';

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _isError = false;
//       });

//       // Get user data
//       final userData = await ApiService.getCurrentUser();
//       if (userData != null) {
//         setState(() {
//           _userName = "${userData['firstName']} ${userData['lastName']}";
//           _isAdmin = userData['role'] == 'admin';
//         });
//       }

//       // Load dashboard data
//       await _loadDashboardData();
//       await _loadQuickStats();

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _isError = true;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   Future<void> _loadDashboardData() async {
//     try {
//       final response = await ApiService.getDashboardData();
//       if (response['success'] == true && response['data'] != null) {
//         setState(() {
//           _dashboardData = response['data']['dashboard'] ?? {};
//         });
//       }
//     } catch (e) {
//       log('Error loading dashboard data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _loadQuickStats() async {
//     try {
//       final response = await ApiService.getQuickStats();
//       if (response['success'] == true && response['data'] != null) {
//         setState(() {
//           _quickStats = response['data']['stats'] ?? {};
//         });
//       }
//     } catch (e) {
//       log('Error loading quick stats: $e');
//       rethrow;
//     }
//   }

//   Future<void> _refreshDashboard() async {
//     try {
//       await _loadDashboardData();
//       await _loadQuickStats();
      
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Dashboard refreshed'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to refresh: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

// //modern_elevator_app/lib/screens/dashboard_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../widgets/base_scaffold.dart';
// import '../services/api_service.dart';
// import 'dart:developer';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool _isLoading = true;
//   bool _isError = false;
//   String _errorMessage = '';
//   Map<String, dynamic> _dashboardData = {};
//   Map<String, dynamic> _quickStats = {};
//   bool _isAdmin = false;
//   String _userName = 'User';

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _isError = false;
//       });

//       // Get user data
//       final userData = await ApiService.getCurrentUser();
//       if (userData != null) {
//         setState(() {
//           _userName = "${userData['firstName']} ${userData['lastName']}";
//           _isAdmin = userData['role'] == 'admin';
//         });
//       }

//       // Load dashboard data
//       await _loadDashboardData();
//       await _loadQuickStats();

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _isError = true;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   Future<void> _loadDashboardData() async {
//     try {
//       final response = await ApiService.getDashboardData();
//       if (response['success'] == true && response['data'] != null) {
//         setState(() {
//           _dashboardData = response['data']['dashboard'] ?? {};
//         });
//       }
//     } catch (e) {
//       log('Error loading dashboard data: $e');
//       rethrow;
//     }
//   }

//   Future<void> _loadQuickStats() async {
//     try {
//       final response = await ApiService.getQuickStats();
//       if (response['success'] == true && response['data'] != null) {
//         setState(() {
//           _quickStats = response['data']['stats'] ?? {};
//         });
//       }
//     } catch (e) {
//       log('Error loading quick stats: $e');
//       rethrow;
//     }
//   }

//   Future<void> _refreshDashboard() async {
//     try {
//       await _loadDashboardData();
//       await _loadQuickStats();
      
//       // Show success message
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Dashboard refreshed'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       // Show error message
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to refresh: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       title: 'Dashboard',
//       currentIndex: 0,
//       body: _isLoading 
//           ? _buildLoadingView()
//           : _isError 
//               ? _buildErrorView()
//               : _buildDashboardView(),
//     );
//   }

//   Widget _buildLoadingView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7D104)),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading dashboard...',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             color: Colors.red,
//             size: 60,
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Error loading dashboard',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             _errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white70,
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: _initialize,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFFF7D104),
//               foregroundColor: Colors.black,
//             ),
//             child: Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDashboardView() {
//     // Get current date and time
//     String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
//     String formattedTime = DateFormat('h:mm a').format(DateTime.now());

//     return SafeArea(
//       child: RefreshIndicator(
//         onRefresh: () => _refreshDashboard(),
//         color: Color(0xFFF7D104),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: ListView(
//             physics: BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics(),
//             ),
//             children: [
//               SizedBox(height: 16),
//               // Header Section
//               _buildHeaderSection(formattedDate, formattedTime),
//               SizedBox(height: 20),
//               // Quick Stats Section
//               _buildQuickStatsSection(),
//               SizedBox(height: 20),
//               // Conditional sections based on user role
//               _isAdmin
//                 ? _buildAdminDashboard()
//                 : _buildMechanicDashboard(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(String date, String time) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF040404),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome Message and Profile Avatar
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Welcome Message
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Welcome,',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'SFProDisplay',
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       _userName,
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'SFProDisplay',
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Profile Avatar
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to Profile or Settings
//                   log('Profile Avatar Tapped');
//                 },
//                 child: CircleAvatar(
//                   radius: 28,
//                   backgroundImage: AssetImage('assets/images/profile_avatar.png'),
//                   backgroundColor: Colors.transparent,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Color(0xFFF7D104), // Yellow outline
//                         width: 2.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           // Date and Time
//           Text(
//             '$date · $time',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               fontFamily: 'SFProDisplay',
//               color: Colors.white70,
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

//   Widget _buildQuickStatsSection() {
//     final stats = _quickStats;
    
//     if (_isAdmin) {
//       // Admin quick stats
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Quick Stats'),
//           SizedBox(height: 10),
//           GridView.count(
//             crossAxisCount: 2,
//             childAspectRatio: 1.8,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             children: [
//               _buildStatCard(
//                 title: 'Active Mechanics',
//                 value: stats['totalMechanics']?.toString() ?? '0',
//                 icon: Icons.person,
//               ),
//               _buildStatCard(
//                 title: 'Active Projects',
//                 value: stats['totalProjects']?.toString() ?? '0',
//                 icon: Icons.business,
//               ),
//               _buildStatCard(
//                 title: 'Material Requests',
//                 value: stats['pendingMaterialRequests']?.toString() ?? '0',
//                 icon: Icons.inventory,
//               ),
//               _buildStatCard(
//                 title: 'Open Issues',
//                 value: stats['openIssues']?.toString() ?? '0',
//                 icon: Icons.warning_amber,
//               ),
//             ],
//           ),
//         ],
//       );
//     } else {
//       // Mechanic quick stats
//       final todayTotalMinutes = stats['todayTotalMinutes'] ?? 0;
//       final hours = (todayTotalMinutes / 60).floor();
//       final minutes = todayTotalMinutes % 60;
      
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Today\'s Activity'),
//           SizedBox(height: 10),
//           GridView.count(
//             crossAxisCount: 2,
//             childAspectRatio: 1.8,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             children: [
//               _buildStatCard(
//                 title: 'Hours Worked',
//                 value: '${hours}h ${minutes}m',
//                 icon: Icons.access_time,
//               ),
//               _buildStatCard(
//                 title: 'Active Timer',
//                 value: stats['hasActiveTimeEntry'] == true ? 'Yes' : 'No',
//                 icon: Icons.timer,
//                 iconColor: stats['hasActiveTimeEntry'] == true ? Colors.green : Colors.red,
//               ),
//               _buildStatCard(
//                 title: 'Material Requests',
//                 value: stats['pendingMaterialRequests']?.toString() ?? '0',
//                 icon: Icons.inventory,
//               ),
//               _buildStatCard(
//                 title: 'Open Issues',
//                 value: stats['openIssues']?.toString() ?? '0',
//                 icon: Icons.warning_amber,
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     Color iconColor = const Color(0xFFF7D104),
//   }) {
//     return Card(
//       color: Color(0xFF121212),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: iconColor,
//                   size: 24,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         if (onViewAll != null)
//           TextButton(
//             onPressed: onViewAll,
//             child: Text(
//               'View All',
//               style: TextStyle(
//                 color: Color(0xFFF7D104),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildMechanicDashboard() {
//     return Column(
//       children: [
//         // Assigned Job Sites Section
//         _buildAssignedJobSitesSection(),
//         SizedBox(height: 20),
//         // Notifications Section
//         _buildNotificationsSection(),
//         SizedBox(height: 20),
//         // Daily Report Status
//         _buildDailyReportStatusSection(),
//       ],
//     );
//   }

//   Widget _buildAdminDashboard() {
//     return Column(
//       children: [
//         // Pending Approvals Section
//         _buildPendingApprovalsSection(),
//         SizedBox(height: 20),
//         // Open Issues Section
//         _buildOpenIssuesSection(),
//         SizedBox(height: 20),
//         // Performance Overview
//         _buildPerformanceOverviewSection(),
//       ],
//     );
//   }

//   Widget _buildAssignedJobSitesSection() {
//     final projects = _dashboardData['currentProjects'] as List<dynamic>? ?? [];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           'Assigned Job Sites',
//           onViewAll: () {
//             // Navigate to job sites screen
//             log('View all job sites');
//           },
//         ),
//         SizedBox(height: 10),
//         if (projects.isEmpty)
//           _buildEmptyState('No job sites assigned', Icons.location_off)
//         else
//           ListView.builder(
//             itemCount: projects.length > 3 ? 3 : projects.length, // Show max 3 items
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               final project = projects[index];
//               return _buildProjectCard(
//                 siteName: project['name'] ?? 'Unknown Project',
//                 elevatorNumber: project['elevators'] != null && project['elevators'].isNotEmpty 
//                   ? project['elevators'][0]['number'] 
//                   : 'No Elevator',
//                 onTap: () {
//                   // Navigate to Job Site Details
//                   log('Job Site Tapped: ${project['name']}');
//                 },
//               );
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildProjectCard({
//     required String siteName,
//     required String elevatorNumber,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: Color(0xFF121212),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(
//             Icons.location_on,
//             color: Color(0xFFF7D104),
//           ),
//           title: Text(
//             siteName,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           subtitle: Text(
//             elevatorNumber,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white70,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.white70,
//             size: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNotificationsSection() {
//     // Since we don't have the actual notifications data structure,
//     // I'll assume it's an array of objects with message and timestamp
//     final notifications = [
//       {'message': 'Safety meeting at 2 PM today.', 'timestamp': DateTime.now().subtract(Duration(hours: 2))},
//       {'message': 'New message from Admin.', 'timestamp': DateTime.now().subtract(Duration(hours: 8))},
//       {'message': 'Material request approved.', 'timestamp': DateTime.now().subtract(Duration(days: 1))},
//     ];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Notifications',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'SFProDisplay',
//                 color: Colors.white,
//               ),
//             ),
//             Stack(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.notifications_none,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                   onPressed: () {
//                     // Show Notification Panel
//                     _showNotificationsPanel();
//                   },
//                 ),
//                 if (_dashboardData['unreadNotificationsCount'] != null && _dashboardData['unreadNotificationsCount'] > 0)
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF7D104),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 16,
//                         minHeight: 16,
//                       ),
//                       child: Text(
//                         _dashboardData['unreadNotificationsCount'].toString(),
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         if (notifications.isEmpty)
//           _buildEmptyState('No notifications', Icons.notifications_off)
//         else
//           ListView.builder(
//             itemCount: notifications.length,
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               return _buildNotificationItem(
//                 message: notification['message'] as String,
//                 timestamp: notification['timestamp'] as DateTime,
//                 onTap: () {
//                   // Navigate to Notification Details
//                   log('Notification Tapped: ${notification['message']}');
//                 },
//               );
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildNotificationItem({
//     required String message,
//     required DateTime timestamp,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: Color(0xFF121212),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(
//             Icons.notifications,
//             color: Color(0xFFF7D104),
//           ),
//           title: Text(
//             message,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//           subtitle: Text(
//             timeago.format(timestamp),
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white70,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDailyReportStatusSection() {
//     final reportStatus = _dashboardData['todayReportStatus'];
    
//     Color statusColor;
//     String statusText;
//     IconData statusIcon;
    
//     if (reportStatus == null) {
//       statusColor = Colors.red;
//       statusText = 'Not Started';
//       statusIcon = Icons.report_off;
//     } else if (reportStatus == 'DRAFT') {
//       statusColor = Colors.orange;
//       statusText = 'In Progress';
//       statusIcon = Icons.edit;
//     } else if (reportStatus == 'SUBMITTED') {
//       statusColor = Colors.blue;
//       statusText = 'Submitted';
//       statusIcon = Icons.check_circle_outline;
//     } else if (reportStatus == 'APPROVED') {
//       statusColor = Colors.green;
//       statusText = 'Approved';
//       statusIcon = Icons.check_circle;
//     } else {
//       statusColor = Colors.grey;
//       statusText = 'Unknown';
//       statusIcon = Icons.help_outline;
//     }
    
//     return Card(
//       color: Color(0xFF121212),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Today\'s Daily Report',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(
//                   statusIcon,
//                   color: statusColor,
//                   size: 24,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   'Status: $statusText',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to Daily Report Screen
//                 log('Navigate to Daily Report');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFF7D104),
//                 foregroundColor: Colors.black,
//                 minimumSize: Size(double.infinity, 48),
//               ),
//               child: Text(
//                 reportStatus == null ? 'Start Daily Report' : 'View Daily Report',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPendingApprovalsSection() {
//     final pendingReports = _dashboardData['pendingReports'] as List<dynamic>? ?? [];
//     final pendingMaterialRequests = _dashboardData['pendingMaterialRequests'] as List<dynamic>? ?? [];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           'Pending Approvals',
//           onViewAll: () {
//             // Navigate to approvals screen
//             log('View all approvals');
//           },
//         ),
//         SizedBox(height: 10),
//         if (pendingReports.isEmpty && pendingMaterialRequests.isEmpty)
//           _buildEmptyState('No pending approvals', Icons.done_all)
//         else
//           Column(
//             children: [
//               if (pendingReports.isNotEmpty)
//                 ..._buildPendingReportsItems(pendingReports),
//               if (pendingReports.isNotEmpty && pendingMaterialRequests.isNotEmpty)
//                 SizedBox(height: 10),
//               if (pendingMaterialRequests.isNotEmpty)
//                 ..._buildPendingMaterialRequestItems(pendingMaterialRequests),
//             ],
//           ),
//       ],
//     );
//   }

//   List<Widget> _buildPendingReportsItems(List<dynamic> pendingReports) {
//     return pendingReports.take(2).map<Widget>((report) {
//       final mechanicName = report['mechanic'] != null
//           ? '${report['mechanic']['firstName']} ${report['mechanic']['lastName']}'
//           : 'Unknown Mechanic';
//       final reportDate = DateTime.tryParse(report['reportDate']) ?? DateTime.now();
      
//       return Card(
//         color: Color(0xFF121212),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(
//             Icons.assignment,
//             color: Color(0xFFF7D104),
//           ),
//           title: Text(
//             'Daily Report by $mechanicName',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           subtitle: Text(
//             'Submitted on ${DateFormat('MMM d, yyyy').format(reportDate)}',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white70,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.white70,
//             size: 16,
//           ),
//           onTap: () {
//             // Navigate to Report Details
//             log('Report Tapped: ${report['id']}');
//           },
//         ),
//       );
//     }).toList();
//   }

//   List<Widget> _buildPendingMaterialRequestItems(List<dynamic> pendingRequests) {
//     return pendingRequests.take(2).map<Widget>((request) {
//       final requestedBy = request['requestedBy'] != null
//           ? '${request['requestedBy']['firstName']} ${request['requestedBy']['lastName']}'
//           : 'Unknown Mechanic';
//       final createdAt = DateTime.tryParse(request['createdAt']) ?? DateTime.now();
      
//       return Card(
//         color: Color(0xFF121212),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(
//             Icons.inventory,
//             color: Color(0xFFF7D104),
//           ),
//           title: Text(
//             'Material Request by $requestedBy',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           subtitle: Text(
//             'Requested on ${DateFormat('MMM d, yyyy').format(createdAt)}',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white70,
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.white70,
//             size: 16,
//           ),
//           onTap: () {
//             // Navigate to Material Request Details
//             log('Material Request Tapped: ${request['id']}');
//           },
//         ),
//       );
//     }).toList();
//   }

//   Widget _buildOpenIssuesSection() {
//     final openIssues = _dashboardData['openIssues'] as List<dynamic>? ?? [];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           'Open Issues',
//           onViewAll: () {
//             // Navigate to issues screen
//             log('View all issues');
//           },
//         ),
//         SizedBox(height: 10),
//         if (openIssues.isEmpty)
//           _buildEmptyState('No open issues', Icons.check_circle)
//         else
//           ListView.builder(
//             itemCount: openIssues.length > 3 ? 3 : openIssues.length, // Show max 3 items
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               final issue = openIssues[index];
//               final reportedBy = issue['reportedBy'] != null
//                   ? '${issue['reportedBy']['firstName']} ${issue['reportedBy']['lastName']}'
//                   : 'Unknown';
//               final projectName = issue['project'] != null ? issue['project']['name'] : 'Unknown Project';
//               final issueType = issue['type'] ?? 'GENERAL';
              
//               return Card(
//                 color: Color(0xFF121212),
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.warning_amber,
//                     color: _getIssueTypeColor(issueType),
//                   ),
//                   title: Text(
//                     issue['title'] ?? 'Untitled Issue',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   subtitle: Text(
//                     '$projectName • Reported by $reportedBy',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.white70,
//                     size: 16,
//                   ),
//                   onTap: () {
//                     // Navigate to Issue Details
//                     log('Issue Tapped: ${issue['id']}');
//                   },
//                 ),
//               );
//             },
//           ),
//       ],
//     );
//   }

//   Color _getIssueTypeColor(String issueType) {
//     switch (issueType) {
//       case 'SAFETY':
//         return Colors.red;
//       case 'MECHANICAL':
//         return Colors.orange;
//       case 'ELECTRICAL':
//         return Colors.blue;
//       case 'HYDRAULIC':
//         return Colors.teal;
//       default:
//         return Color(0xFFF7D104);
//     }
//   }

//   Widget _buildPerformanceOverviewSection() {
//   // Get the weeklyWorkSummary object safely
//   final weeklyWorkSummary = _dashboardData['weeklyWorkSummary'];
  
//   // Prepare default text
//   String workSummaryText = 'No data available';
  
//   // Check if the data structure exists and has the expected properties
//   if (weeklyWorkSummary != null && 
//       weeklyWorkSummary['regularTime'] != null && 
//       weeklyWorkSummary['overtimeTime'] != null &&
//       weeklyWorkSummary['regularTime']['formatted'] != null &&
//       weeklyWorkSummary['overtimeTime']['formatted'] != null) {
    
//     workSummaryText = 'Regular: ${weeklyWorkSummary['regularTime']['formatted']} • Overtime: ${weeklyWorkSummary['overtimeTime']['formatted']}';
//   }
  
//   return Card(
//     color: Color(0xFF121212),
//     elevation: 2,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Performance Overview',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Weekly Work Hours',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white70,
//             ),
//           ),
//           SizedBox(height: 8),
//           // This would ideally be a chart, but we'll use text for now
//           Text(
//             workSummaryText,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to Performance Reports Screen
//               log('Navigate to Performance Reports');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFFF7D104),
//               foregroundColor: Colors.black,
//               minimumSize: Size(double.infinity, 48),
//             ),
//             child: Text(
//               'View Detailed Reports',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   Widget _buildEmptyState(String message, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 24),
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           Icon(
//             icon,
//             color: Colors.white38,
//             size: 48,
//           ),
//           SizedBox(height: 16),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white38,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showNotificationsPanel() {
//     // Implement the sliding notification panel here
//     // For simplicity, we'll just show a bottom sheet
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Color(0xFF121212),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           height: MediaQuery.of(context).size.height * 0.6,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Color(0xFFF7D104),
//                         child: Icon(
//                           Icons.notifications,
//                           color: Colors.black,
//                         ),
//                       ),
//                       title: Text(
//                         'Notification ${index + 1}',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       subtitle: Text(
//                         'Tap to view details',
//                         style: TextStyle(
//                           color: Colors.white70,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }



//modern_elevator_app/lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widgets/base_scaffold.dart';
import '../services/api_service.dart';
import 'dart:developer';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  Map<String, dynamic> _dashboardData = {};
  Map<String, dynamic> _quickStats = {};
  bool _isAdmin = false;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      // Get user data
      final userData = await ApiService.getCurrentUser();
      if (userData != null) {
        if (!mounted) return;
        setState(() {
          _userName = "${userData['firstName']} ${userData['lastName']}";
          _isAdmin = userData['role'] == 'admin';
        });
      }

      // Load dashboard data
      await _loadDashboardData();
      await _loadQuickStats();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      final response = await ApiService.getDashboardData();
      if (response['success'] == true && response['data'] != null) {
        if (!mounted) return;
        setState(() {
          _dashboardData = response['data']['dashboard'] ?? {};
        });
      }
    } catch (e) {
      log('Error loading dashboard data: $e');
      rethrow;
    }
  }

  Future<void> _loadQuickStats() async {
    try {
      final response = await ApiService.getQuickStats();
      if (response['success'] == true && response['data'] != null) {
        if (!mounted) return;
        setState(() {
          _quickStats = response['data']['stats'] ?? {};
        });
      }
    } catch (e) {
      log('Error loading quick stats: $e');
      rethrow;
    }
  }

  Future<void> _refreshDashboard() async {
    try {
      await _loadDashboardData();
      await _loadQuickStats();
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dashboard refreshed'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Dashboard',
      currentIndex: 0,
      body: _isLoading 
          ? _buildLoadingView()
          : _isError 
              ? _buildErrorView()
              : _buildDashboardView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7D104)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading dashboard...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Error loading dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initialize,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF7D104),
              foregroundColor: Colors.black,
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    // Get current date and time
    String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    String formattedTime = DateFormat('h:mm a').format(DateTime.now());

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _refreshDashboard(),
        color: Color(0xFFF7D104),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              SizedBox(height: 16),
              // Header Section
              _buildHeaderSection(formattedDate, formattedTime),
              SizedBox(height: 20),
              // Quick Stats Section
              _buildQuickStatsSection(),
              SizedBox(height: 20),
              // Conditional sections based on user role
              _isAdmin
                ? _buildAdminDashboard()
                : _buildMechanicDashboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String date, String time) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF040404),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message and Profile Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Welcome Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SFProDisplay',
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProDisplay',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Avatar
              GestureDetector(
                onTap: () {
                  // Navigate to Profile or Settings
                  log('Profile Avatar Tapped');
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFF7D104), // Yellow outline
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Date and Time
          Text(
            '$date · $time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProDisplay',
              color: Colors.white70,
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

  Widget _buildQuickStatsSection() {
    final stats = _quickStats;
    
    if (_isAdmin) {
      // Admin quick stats
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Quick Stats'),
          SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: 'Active Mechanics',
                value: stats['totalMechanics']?.toString() ?? '0',
                icon: Icons.person,
              ),
              _buildStatCard(
                title: 'Active Projects',
                value: stats['totalProjects']?.toString() ?? '0',
                icon: Icons.business,
              ),
              _buildStatCard(
                title: 'Material Requests',
                value: stats['pendingMaterialRequests']?.toString() ?? '0',
                icon: Icons.inventory,
              ),
              _buildStatCard(
                title: 'Open Issues',
                value: stats['openIssues']?.toString() ?? '0',
                icon: Icons.warning_amber,
              ),
            ],
          ),
        ],
      );
    } else {
      // Mechanic quick stats
      final todayTotalMinutes = stats['todayTotalMinutes'] ?? 0;
      final hours = (todayTotalMinutes / 60).floor();
      final minutes = todayTotalMinutes % 60;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Today\'s Activity'),
          SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: 'Hours Worked',
                value: '${hours}h ${minutes}m',
                icon: Icons.access_time,
              ),
              _buildStatCard(
                title: 'Active Timer',
                value: stats['hasActiveTimeEntry'] == true ? 'Yes' : 'No',
                icon: Icons.timer,
                iconColor: stats['hasActiveTimeEntry'] == true ? Colors.green : Colors.red,
              ),
              _buildStatCard(
                title: 'Material Requests',
                value: stats['pendingMaterialRequests']?.toString() ?? '0',
                icon: Icons.inventory,
              ),
              _buildStatCard(
                title: 'Open Issues',
                value: stats['openIssues']?.toString() ?? '0',
                icon: Icons.warning_amber,
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = const Color(0xFFF7D104),
  }) {
    return Card(
      color: Color(0xFF121212),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: TextStyle(
                color: Color(0xFFF7D104),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMechanicDashboard() {
    return Column(
      children: [
        // Assigned Job Sites Section
        _buildAssignedJobSitesSection(),
        SizedBox(height: 20),
        // Notifications Section
        _buildNotificationsSection(),
        SizedBox(height: 20),
        // Daily Report Status
        _buildDailyReportStatusSection(),
      ],
    );
  }

  Widget _buildAdminDashboard() {
    return Column(
      children: [
        // Pending Approvals Section
        _buildPendingApprovalsSection(),
        SizedBox(height: 20),
        // Open Issues Section
        _buildOpenIssuesSection(),
        SizedBox(height: 20),
        // Performance Overview
        _buildPerformanceOverviewSection(),
      ],
    );
  }

  Widget _buildAssignedJobSitesSection() {
    final projects = _dashboardData['currentProjects'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Assigned Job Sites',
          onViewAll: () {
            // Navigate to job sites screen
            log('View all job sites');
          },
        ),
        SizedBox(height: 10),
        if (projects.isEmpty)
          _buildEmptyState('No job sites assigned', Icons.location_off)
        else
          ListView.builder(
            itemCount: projects.length > 3 ? 3 : projects.length, // Show max 3 items
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _buildProjectCard(
                siteName: project['name'] ?? 'Unknown Project',
                elevatorNumber: project['elevators'] != null && project['elevators'].isNotEmpty 
                  ? project['elevators'][0]['number'] 
                  : 'No Elevator',
                onTap: () {
                  // Navigate to Job Site Details
                  log('Job Site Tapped: ${project['name']}');
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildProjectCard({
    required String siteName,
    required String elevatorNumber,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.location_on,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            siteName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            elevatorNumber,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    // Since we don't have the actual notifications data structure,
    // I'll assume it's an array of objects with message and timestamp
    final notifications = [
      {'message': 'Safety meeting at 2 PM today.', 'timestamp': DateTime.now().subtract(Duration(hours: 2))},
      {'message': 'New message from Admin.', 'timestamp': DateTime.now().subtract(Duration(hours: 8))},
      {'message': 'Material request approved.', 'timestamp': DateTime.now().subtract(Duration(days: 1))},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProDisplay',
                color: Colors.white,
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    // Show Notification Panel
                    _showNotificationsPanel();
                  },
                ),
                if (_dashboardData['unreadNotificationsCount'] != null && _dashboardData['unreadNotificationsCount'] > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7D104),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _dashboardData['unreadNotificationsCount'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        if (notifications.isEmpty)
          _buildEmptyState('No notifications', Icons.notifications_off)
        else
          ListView.builder(
            itemCount: notifications.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(
                message: notification['message'] as String,
                timestamp: notification['timestamp'] as DateTime,
                onTap: () {
                  // Navigate to Notification Details
                  log('Notification Tapped: ${notification['message']}');
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required String message,
    required DateTime timestamp,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.notifications,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            timeago.format(timestamp),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReportStatusSection() {
    final reportStatus = _dashboardData['todayReportStatus'];
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (reportStatus == null) {
      statusColor = Colors.red;
      statusText = 'Not Started';
      statusIcon = Icons.report_off;
    } else if (reportStatus == 'DRAFT') {
      statusColor = Colors.orange;
      statusText = 'In Progress';
      statusIcon = Icons.edit;
    } else if (reportStatus == 'SUBMITTED') {
      statusColor = Colors.blue;
      statusText = 'Submitted';
      statusIcon = Icons.check_circle_outline;
    } else if (reportStatus == 'APPROVED') {
      statusColor = Colors.green;
      statusText = 'Approved';
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Colors.grey;
      statusText = 'Unknown';
      statusIcon = Icons.help_outline;
    }
    
    return Card(
      color: Color(0xFF121212),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Daily Report',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: $statusText',
                  style: TextStyle(
                    fontSize: 16,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Daily Report Screen
                log('Navigate to Daily Report');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7D104),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                reportStatus == null ? 'Start Daily Report' : 'View Daily Report',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingApprovalsSection() {
    final pendingReports = _dashboardData['pendingReports'] as List<dynamic>? ?? [];
    final pendingMaterialRequests = _dashboardData['pendingMaterialRequests'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Pending Approvals',
          onViewAll: () {
            // Navigate to approvals screen
            log('View all approvals');
          },
        ),
        SizedBox(height: 10),
        if (pendingReports.isEmpty && pendingMaterialRequests.isEmpty)
          _buildEmptyState('No pending approvals', Icons.done_all)
        else
          Column(
            children: [
              if (pendingReports.isNotEmpty)
                ..._buildPendingReportsItems(pendingReports),
              if (pendingReports.isNotEmpty && pendingMaterialRequests.isNotEmpty)
                SizedBox(height: 10),
              if (pendingMaterialRequests.isNotEmpty)
                ..._buildPendingMaterialRequestItems(pendingMaterialRequests),
            ],
          ),
      ],
    );
  }

  List<Widget> _buildPendingReportsItems(List<dynamic> pendingReports) {
    return pendingReports.take(2).map<Widget>((report) {
      final mechanicName = report['mechanic'] != null
          ? '${report['mechanic']['firstName']} ${report['mechanic']['lastName']}'
          : 'Unknown Mechanic';
      final reportDate = DateTime.tryParse(report['reportDate']) ?? DateTime.now();
      
      return Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.assignment,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            'Daily Report by $mechanicName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Submitted on ${DateFormat('MMM d, yyyy').format(reportDate)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
          onTap: () {
            // Navigate to Report Details
            log('Report Tapped: ${report['id']}');
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildPendingMaterialRequestItems(List<dynamic> pendingRequests) {
    return pendingRequests.take(2).map<Widget>((request) {
      final requestedBy = request['requestedBy'] != null
          ? '${request['requestedBy']['firstName']} ${request['requestedBy']['lastName']}'
          : 'Unknown Mechanic';
      final createdAt = DateTime.tryParse(request['createdAt']) ?? DateTime.now();
      
      return Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.inventory,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            'Material Request by $requestedBy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Requested on ${DateFormat('MMM d, yyyy').format(createdAt)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
          onTap: () {
            // Navigate to Material Request Details
            log('Material Request Tapped: ${request['id']}');
          },
        ),
      );
    }).toList();
  }

  Widget _buildOpenIssuesSection() {
    final openIssues = _dashboardData['openIssues'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Open Issues',
          onViewAll: () {
            // Navigate to issues screen
            log('View all issues');
          },
        ),
        SizedBox(height: 10),
        if (openIssues.isEmpty)
          _buildEmptyState('No open issues', Icons.check_circle)
        else
          ListView.builder(
            itemCount: openIssues.length > 3 ? 3 : openIssues.length, // Show max 3 items
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final issue = openIssues[index];
              final reportedBy = issue['reportedBy'] != null
                  ? '${issue['reportedBy']['firstName']} ${issue['reportedBy']['lastName']}'
                  : 'Unknown';
              final projectName = issue['project'] != null ? issue['project']['name'] : 'Unknown Project';
              final issueType = issue['type'] ?? 'GENERAL';
              
              return Card(
                color: Color(0xFF121212),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.warning_amber,
                    color: _getIssueTypeColor(issueType),
                  ),
                  title: Text(
                    issue['title'] ?? 'Untitled Issue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    '$projectName • Reported by $reportedBy',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                  onTap: () {
                    // Navigate to Issue Details
                    log('Issue Tapped: ${issue['id']}');
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getIssueTypeColor(String issueType) {
    switch (issueType) {
      case 'SAFETY':
        return Colors.red;
      case 'MECHANICAL':
        return Colors.orange;
      case 'ELECTRICAL':
        return Colors.blue;
      case 'HYDRAULIC':
        return Colors.teal;
      default:
        return Color(0xFFF7D104);
    }
  }

  Widget _buildPerformanceOverviewSection() {
    // Get the weeklyWorkSummary object safely
    final weeklyWorkSummary = _dashboardData['weeklyWorkSummary'];
    
    // Prepare default text
    String workSummaryText = 'No data available';
    
    // Check if the data structure exists and has the expected properties
    if (weeklyWorkSummary != null && 
        weeklyWorkSummary['regularTime'] != null && 
        weeklyWorkSummary['overtimeTime'] != null &&
        weeklyWorkSummary['regularTime']['formatted'] != null &&
        weeklyWorkSummary['overtimeTime']['formatted'] != null) {
      
      workSummaryText = 'Regular: ${weeklyWorkSummary['regularTime']['formatted']} • Overtime: ${weeklyWorkSummary['overtimeTime']['formatted']}';
    }
    
    return Card(
      color: Color(0xFF121212),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Weekly Work Hours',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            // This would ideally be a chart, but we'll use text for now
            Text(
              workSummaryText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Performance Reports Screen
                log('Navigate to Performance Reports');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7D104),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                'View Detailed Reports',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white38,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationsPanel() {
    // Implement the sliding notification panel here
    // For simplicity, we'll just show a bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFF7D104),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        'Notification ${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Tap to view details',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}