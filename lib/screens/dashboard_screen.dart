// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   final String mechanicName;

//   DashboardScreen({required this.mechanicName});

//   // Sample data for job sites and notifications
//   final List<Map<String, String>> jobSites = [
//     {'siteName': 'Marcy Ave', 'elevatorNumber': 'EL#789'},
//     {'siteName': 'Lorimer', 'elevatorNumber': 'EL#555'},
//     {'siteName': 'Flushing Ave', 'elevatorNumber': 'EL#123'},
//   ];

//   final List<String> notifications = [
//     'Safety meeting at 2 PM today.',
//     'New message from Admin.',
//     'Material request approved.',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//         backgroundColor: Color(0xFF040404), // Black color
//         automaticallyImplyLeading: false, // Removes the back button
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // Welcome Message
//               Text(
//                 'Welcome, $mechanicName',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404), // Black color
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Notifications Section
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404),
//                 ),
//               ),
//               SizedBox(height: 10),
//               ...notifications.map((notification) {
//                 return Card(
//                   elevation: 2,
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.notifications,
//                       color: Color(0xFFF7D104), // Yellow color
//                     ),
//                     title: Text(notification),
//                   ),
//                 );
//               }).toList(),
//               SizedBox(height: 20),
//               // Assigned Job Sites Section
//               Text(
//                 'Assigned Job Sites',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404),
//                 ),
//               ),
//               SizedBox(height: 10),
//               ...jobSites.map((jobSite) {
//                 return Card(
//                   elevation: 2,
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.location_on,
//                       color: Color(0xFFF7D104), // Yellow color
//                     ),
//                     title: Text(jobSite['siteName'] ?? ''),
//                     subtitle: Text(jobSite['elevatorNumber'] ?? ''),
//                   ),
//                 );
//               }).toList(),
//               SizedBox(height: 20),
//               // Quick Access Buttons
//               Text(
//                 'Quick Access',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   // Time Tracking Button
//                   _buildQuickAccessButton(
//                     icon: Icons.timer,
//                     label: 'Time Tracking',
//                     onTap: () {
//                       // TODO: Navigate to Time Tracking Screen
//                       print('Navigate to Time Tracking');
//                     },
//                   ),
//                   // Issue Reporting Button
//                   _buildQuickAccessButton(
//                     icon: Icons.report_problem,
//                     label: 'Issue Reporting',
//                     onTap: () {
//                       // TODO: Navigate to Issue Reporting Screen
//                       print('Navigate to Issue Reporting');
//                     },
//                   ),
//                   // Settings Button
//                   _buildQuickAccessButton(
//                     icon: Icons.settings,
//                     label: 'Settings',
//                     onTap: () {
//                       // TODO: Navigate to Settings Screen
//                       print('Navigate to Settings');
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickAccessButton(
//       {required IconData icon, required String label, required Function() onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: <Widget>[
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Color(0xFF040404),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: Color(0xFF040404), // Black color
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:modern_elevator_app/screens/time_tracking_screen.dart';


// class DashboardScreen extends StatefulWidget {
//   final String mechanicName;

//   DashboardScreen({required this.mechanicName});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   // Sample data for job sites and notifications
//   final List<Map<String, dynamic>> jobSites = [
//     {
//       'siteName': 'Marcy Ave',
//       'elevatorNumber': 'EL#789',
//       'status': 'In Progress',
//       'statusColor': Color(0xFFF7D104), // Yellow
//     },
//     {
//       'siteName': 'Lorimer',
//       'elevatorNumber': 'EL#555',
//       'status': 'Completed',
//       'statusColor': Color(0xFF4CAF50), // Green
//     },
//     {
//       'siteName': 'Flushing Ave',
//       'elevatorNumber': 'EL#123',
//       'status': 'Pending',
//       'statusColor': Color(0xFFFF5252), // Red
//     },
//   ];

//   final List<Map<String, dynamic>> notifications = [
//     {
//       'type': 'Safety',
//       'message': 'Safety meeting at 2 PM today.',
//       'isUnread': true,
//     },
//     {
//       'type': 'Message',
//       'message': 'New message from Admin.',
//       'isUnread': true,
//     },
//     {
//       'type': 'Approval',
//       'message': 'Material request approved.',
//       'isUnread': false,
//     },
//   ];

//   bool _isDarkMode = false; // For dark mode compatibility

//   @override
//   void initState() {
//     super.initState();
//     // You can determine the theme mode from system settings or user preference
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get current date and time
//     String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
//     String formattedTime = DateFormat('h:mm a').format(DateTime.now());

//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             // Implement pull-to-refresh functionality
//             await Future.delayed(Duration(seconds: 2));
//             setState(() {
//               // Refresh data
//             });
//           },
//           child: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 pinned: true,
//                 expandedHeight: 180,
//                 backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color.fromARGB(255, 236, 215, 21),
//                           Color.fromARGB(255, 189, 139, 1),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Welcome Message
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Welcome,',
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'SFProDisplay',
//                                       color: Color(0xFF2A2A2A),
//                                     ),
//                                   ),
//                                   Text(
//                                     widget.mechanicName,
//                                     style: TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'SFProDisplay',
//                                       color: Color(0xFF2A2A2A),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Profile Avatar
//                             GestureDetector(
//                               onTap: () {
//                                 // Navigate to Profile or Settings
//                                 print('Profile Avatar Tapped');
//                               },
//                               child: CircleAvatar(
//                                 radius: 28,
//                                 backgroundImage: AssetImage('assets/images/profile_avatar.png'),
//                                 backgroundColor: Colors.transparent,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: Color(0xFFF7D104), // Yellow outline
//                                       width: 2.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         // Date and Time
//                         Text(
//                           '$formattedDate · $formattedTime',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: 'SFProDisplay',
//                             color: Color(0xFF2A2A2A),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   // Notification Bell Icon
//                   IconButton(
//                     icon: Stack(
//                       children: [
//                         Icon(
//                           Icons.notifications_none,
//                           color: Color(0xFF2A2A2A),
//                           size: 28,
//                         ),
//                         if (notifications.any((n) => n['isUnread']))
//                           Positioned(
//                             right: 0,
//                             child: CircleAvatar(
//                               radius: 6,
//                               backgroundColor: Color(0xFFF7D104),
//                             ),
//                           ),
//                       ],
//                     ),
//                     onPressed: () {
//                       // Show Notification Panel
//                       _showNotificationsPanel(context);
//                     },
//                   ),
//                 ],
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Job Sites Section
//                       SizedBox(height: 20),
//                       Text(
//                         'Assigned Job Sites',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'SFProDisplay',
//                           color: Color(0xFF2A2A2A),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       ...jobSites.map((jobSite) {
//                         return GestureDetector(
//                           onTap: () {
//                             // Navigate to Job Site Details
//                             print('Job Site Tapped: ${jobSite['siteName']}');
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 16),
//                             decoration: BoxDecoration(
//                               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   offset: Offset(0, 4),
//                                   blurRadius: 12,
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               contentPadding: EdgeInsets.all(16),
//                               leading: Icon(
//                                 Icons.location_on,
//                                 color: Color(0xFFF7D104),
//                                 size: 32,
//                               ),
//                               title: Text(
//                                 jobSite['siteName'],
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: 'SFProDisplay',
//                                   color: Color(0xFF2A2A2A),
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 jobSite['elevatorNumber'],
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontFamily: 'SFProDisplay',
//                                   fontFeatures: [FontFeature.tabularFigures()],
//                                   color: Color(0xFF2A2A2A),
//                                 ),
//                               ),
//                               trailing: Wrap(
//                                 crossAxisAlignment: WrapCrossAlignment.center,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: jobSite['statusColor'].withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(
//                                       jobSite['status'],
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         fontFamily: 'SFProDisplay',
//                                         color: jobSite['statusColor'],
//                                       ),
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Color(0xFF2A2A2A),
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       // Quick Access Menu
//                       SizedBox(height: 20),
//                       Text(
//                         'Quick Access',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'SFProDisplay',
//                           color: Color(0xFF2A2A2A),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       GridView.count(
//                         shrinkWrap: true,
//                         crossAxisCount: 4,
//                         mainAxisSpacing: 16,
//                         crossAxisSpacing: 16,
//                         physics: NeverScrollableScrollPhysics(),
//                         children: [
//                           _buildQuickAccessButton(
//                             icon: Icons.timer,
//                             label: 'Time\nTracking',
//                             onTap: () {
//                               // Navigate to Time Tracking Screen
//                               print('Navigate to Time Tracking');
//                             },
//                           ),
//                           _buildQuickAccessButton(
//                             icon: Icons.report_problem,
//                             label: 'Issue\nReporting',
//                             onTap: () {
//                               // Navigate to Issue Reporting Screen
//                               print('Navigate to Issue Reporting');
//                             },
//                           ),
//                           _buildQuickAccessButton(
//                             icon: Icons.settings,
//                             label: 'Settings',
//                             onTap: () {
//                               // Navigate to Settings Screen
//                               print('Navigate to Settings');
//                             },
//                           ),
//                           _buildQuickAccessButton(
//                             icon: Icons.logout,
//                             label: 'Logout',
//                             onTap: () {
//                               // Logout and navigate to Login Screen
//                               print('Logout');
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickAccessButton({
//     required IconData icon,
//     required String label,
//     required Function() onTap,
//   }) {
//     return GestureDetector(
//       onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TimeTrackingScreen(),
//                   ),
//                 );
//               },
//       child: Column(
//         children: [
//           Ink(
//             decoration: BoxDecoration(
//               color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(0, 4),
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: InkWell(
//               customBorder: CircleBorder(),
//               splashColor: Color(0xFFF7D104).withOpacity(0.2),
//               onTap: onTap,
//               child: Container(
//                 width: 64,
//                 height: 64,
//                 child: Icon(
//                   icon,
//                   size: 32,
//                   color: Color(0xFF2A2A2A),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF2A2A2A),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: 'SFProDisplay',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showNotificationsPanel(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       elevation: 10,
//       backgroundColor: Colors.white.withOpacity(0.9),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//       ),
//       builder: (context) {
//         return Container(
//           height: 400,
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'SFProDisplay',
//                   color: Color(0xFF2A2A2A),
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: notifications.map((notification) {
//                     return ListTile(
//                       leading: Icon(
//                         _getNotificationIcon(notification['type']),
//                         color: Color(0xFF2A2A2A),
//                       ),
//                       title: Text(
//                         notification['message'],
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'SFProDisplay',
//                           color: Color(0xFF2A2A2A),
//                         ),
//                       ),
//                       tileColor: notification['isUnread'] ? Color(0xFFF7D104).withOpacity(0.1) : null,
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'Safety':
//         return Icons.health_and_safety;
//       case 'Message':
//         return Icons.message;
//       case 'Approval':
//         return Icons.check_circle;
//       default:
//         return Icons.notifications;
//     }
//   }
// }

// lib/screens/dashboard_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:modern_elevator_app/screens/time_tracking_screen.dart';

// class DashboardScreen extends StatelessWidget {
//   final String mechanicName;

//   DashboardScreen({required this.mechanicName});

//   // Sample data for job sites and notifications
//   final List<Map<String, dynamic>> jobSites = [
//     {'siteName': 'Marcy Ave', 'elevatorNumber': 'EL#789'},
//     {'siteName': 'Lorimer', 'elevatorNumber': 'EL#555'},
//     {'siteName': 'Flushing Ave', 'elevatorNumber': 'EL#123'},
//   ];

//   final List<String> notifications = [
//     'Safety meeting at 2 PM today.',
//     'New message from Admin.',
//     'Material request approved.',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Get current date and time
//     String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
//     String formattedTime = DateFormat('h:mm a').format(DateTime.now());

//     return Scaffold(
//       backgroundColor: Colors.white, // Light background
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: ListView(
//             physics: BouncingScrollPhysics(),
//             children: [
//               SizedBox(height: 16),
//               // Header Section
//               _buildHeaderSection(formattedDate, formattedTime),
//               SizedBox(height: 20),
//               // Notifications Section
//               _buildNotificationsSection(),
//               SizedBox(height: 20),
//               // Assigned Job Sites Section
//               _buildJobSitesSection(),
//               SizedBox(height: 20),
//               // Quick Access Section
//               _buildQuickAccessSection(context),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(String date, String time) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Color(0xFFF8F8F8)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
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
//                         color: Color(0xFF2A2A2A),
//                       ),
//                     ),
//                     Text(
//                       mechanicName,
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'SFProDisplay',
//                         color: Color(0xFF2A2A2A),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Profile Avatar
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to Profile or Settings
//                   print('Profile Avatar Tapped');
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
//               color: Color(0xFF2A2A2A),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section Title and Notification Icon
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Notifications',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'SFProDisplay',
//                 color: Color(0xFF2A2A2A),
//               ),
//             ),
//             // Notification Bell Icon
//             IconButton(
//               icon: Stack(
//                 children: [
//                   Icon(
//                     Icons.notifications_none,
//                     color: Color(0xFF2A2A2A),
//                     size: 28,
//                   ),
//                   if (notifications.isNotEmpty)
//                     Positioned(
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 6,
//                         backgroundColor: Color(0xFFF7D104),
//                       ),
//                     ),
//                 ],
//               ),
//               onPressed: () {
//                 // Show Notification Panel
//                 _showNotificationsPanel();
//               },
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         // Notifications List
//         Container(
//           height: notifications.length * 70.0, // Adjust height based on item count
//           child: ListView.builder(
//             itemCount: notifications.length,
//             physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//             itemBuilder: (context, index) {
//               String notification = notifications[index];
//               return Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.notifications,
//                     color: Color(0xFFF7D104),
//                   ),
//                   title: Text(
//                     notification,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildJobSitesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Assigned Job Sites',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'SFProDisplay',
//             color: Color(0xFF2A2A2A),
//           ),
//         ),
//         SizedBox(height: 10),
//         ListView.builder(
//           itemCount: jobSites.length,
//           physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//           shrinkWrap: true, // Use minimum height needed
//           itemBuilder: (context, index) {
//             Map<String, dynamic> jobSite = jobSites[index];
//             return GestureDetector(
//               onTap: () {
//                 // Navigate to Job Site Details
//                 print('Job Site Tapped: ${jobSite['siteName']}');
//               },
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.location_on,
//                     color: Color(0xFFF7D104),
//                   ),
//                   title: Text(
//                     jobSite['siteName'] ?? '',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                   subtitle: Text(
//                     jobSite['elevatorNumber'] ?? '',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Color(0xFF2A2A2A),
//                     size: 16,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickAccessSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Access',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'SFProDisplay',
//             color: Color(0xFF2A2A2A),
//           ),
//         ),
//         SizedBox(height: 10),
//         GridView.count(
//           crossAxisCount: 4,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//           shrinkWrap: true, // Use minimum height needed
//           children: [
//             // Time Tracking Button
//             _buildQuickAccessButton(
//               icon: Icons.timer,
//               label: 'Time\nTracking',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TimeTrackingScreen(),
//                   ),
//                 );
//               },
//             ),
//             // Issue Reporting Button
//             _buildQuickAccessButton(
//               icon: Icons.report_problem,
//               label: 'Issue\nReporting',
//               onTap: () {
//                 // TODO: Navigate to Issue Reporting Screen
//                 print('Navigate to Issue Reporting');
//               },
//             ),
//             // Settings Button
//             _buildQuickAccessButton(
//               icon: Icons.settings,
//               label: 'Settings',
//               onTap: () {
//                 // TODO: Navigate to Settings Screen
//                 print('Navigate to Settings');
//               },
//             ),
//             // Logout Button
//             _buildQuickAccessButton(
//               icon: Icons.logout,
//               label: 'Logout',
//               onTap: () {
//                 // TODO: Implement Logout
//                 print('Logout');
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickAccessButton({
//     required IconData icon,
//     required String label,
//     required Function() onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Ink(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(0, 4),
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: InkWell(
//               customBorder: CircleBorder(),
//               splashColor: Color(0xFFF7D104).withOpacity(0.2),
//               onTap: onTap,
//               child: Container(
//                 width: 64,
//                 height: 64,
//                 child: Icon(
//                   icon,
//                   size: 32,
//                   color: Color(0xFF2A2A2A),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF2A2A2A),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: 'SFProDisplay',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showNotificationsPanel() {
//     // Implement the sliding notification panel here
//     // For simplicity, we'll just print the action
//     print('Show Notifications Panel');
//   }
// }

// //modern_elevator_app/lib/screens/dashboard_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'issue_reporting_screen.dart';
// import 'time_tracking_screen.dart';

// class DashboardScreen extends StatelessWidget {
//   final String mechanicName;

//   DashboardScreen({required this.mechanicName});

//   // Sample data for job sites and notifications
//   final List<Map<String, dynamic>> jobSites = [
//     {'siteName': 'Marcy Ave', 'elevatorNumber': 'EL#789'},
//     {'siteName': 'Lorimer', 'elevatorNumber': 'EL#555'},
//     {'siteName': 'Flushing Ave', 'elevatorNumber': 'EL#123'},
//   ];

//   final List<String> notifications = [
//     'Safety meeting at 2 PM today.',
//     'New message from Admin.',
//     'Material request approved.',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Get current date and time
//     String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
//     String formattedTime = DateFormat('h:mm a').format(DateTime.now());

//     return Scaffold(
//       backgroundColor: Colors.white, // Light background
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: ListView(
//             physics: BouncingScrollPhysics(),
//             children: [
//               SizedBox(height: 16),
//               // Header Section
//               _buildHeaderSection(formattedDate, formattedTime),
//               SizedBox(height: 20),
//               // Notifications Section
//               _buildNotificationsSection(),
//               SizedBox(height: 20),
//               // Assigned Job Sites Section
//               _buildJobSitesSection(),
//               SizedBox(height: 20),
//               // Quick Access Section
//               _buildQuickAccessSection(context),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(String date, String time) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Color(0xFFF8F8F8)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
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
//                         color: Color(0xFF2A2A2A),
//                       ),
//                     ),
//                     Text(
//                       mechanicName,
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'SFProDisplay',
//                         color: Color(0xFF2A2A2A),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Profile Avatar
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to Profile or Settings
//                   print('Profile Avatar Tapped');
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
//               color: Color(0xFF2A2A2A),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section Title and Notification Icon
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Notifications',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'SFProDisplay',
//                 color: Color(0xFF2A2A2A),
//               ),
//             ),
//             // Notification Bell Icon
//             IconButton(
//               icon: Stack(
//                 children: [
//                   Icon(
//                     Icons.notifications_none,
//                     color: Color(0xFF2A2A2A),
//                     size: 28,
//                   ),
//                   if (notifications.isNotEmpty)
//                     Positioned(
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 6,
//                         backgroundColor: Color(0xFFF7D104),
//                       ),
//                     ),
//                 ],
//               ),
//               onPressed: () {
//                 // Show Notification Panel
//                 _showNotificationsPanel();
//               },
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         // Notifications List
//         Container(
//           height: notifications.length * 70.0, // Adjust height based on item count
//           child: ListView.builder(
//             itemCount: notifications.length,
//             physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//             itemBuilder: (context, index) {
//               String notification = notifications[index];
//               return Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.notifications,
//                     color: Color(0xFFF7D104),
//                   ),
//                   title: Text(
//                     notification,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildJobSitesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Assigned Job Sites',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'SFProDisplay',
//             color: Color(0xFF2A2A2A),
//           ),
//         ),
//         SizedBox(height: 10),
//         ListView.builder(
//           itemCount: jobSites.length,
//           physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//           shrinkWrap: true, // Use minimum height needed
//           itemBuilder: (context, index) {
//             Map<String, dynamic> jobSite = jobSites[index];
//             return GestureDetector(
//               onTap: () {
//                 // Navigate to Job Site Details
//                 print('Job Site Tapped: ${jobSite['siteName']}');
//               },
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.location_on,
//                     color: Color(0xFFF7D104),
//                   ),
//                   title: Text(
//                     jobSite['siteName'] ?? '',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                   subtitle: Text(
//                     jobSite['elevatorNumber'] ?? '',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'SFProDisplay',
//                       color: Color(0xFF2A2A2A),
//                     ),
//                   ),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Color(0xFF2A2A2A),
//                     size: 16,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickAccessSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Access',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'SFProDisplay',
//             color: Color(0xFF2A2A2A),
//           ),
//         ),
//         SizedBox(height: 10),
//         GridView.count(
//           crossAxisCount: 4,
//           childAspectRatio: 0.7, // Adjusted aspect ratio
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
//           shrinkWrap: true, // Use minimum height needed
//           children: [
//             // Time Tracking Button
//             _buildQuickAccessButton(
//               icon: Icons.timer,
//               label: 'Time\nTracking',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TimeTrackingScreen(),
//                   ),
//                 );
//               },
//             ),
//             // Issue Reporting Button
//             _buildQuickAccessButton(
//               icon: Icons.report_problem,
//               label: 'Issue\nReporting',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => IssueReportingMaterialRequestScreen(),
//                   ),
//                 );
//               },
//             ),
//             // Settings Button
//             _buildQuickAccessButton(
//               icon: Icons.settings,
//               label: 'Settings',
//               onTap: () {
//                 // TODO: Navigate to Settings Screen
//                 print('Navigate to Settings');
//               },
//             ),
//             // Logout Button
//             _buildQuickAccessButton(
//               icon: Icons.logout,
//               label: 'Logout',
//               onTap: () {
//                 // TODO: Implement Logout
//                 print('Logout');
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickAccessButton({
//     required IconData icon,
//     required String label,
//     required Function() onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Ink(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(0, 4),
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: InkWell(
//               customBorder: CircleBorder(),
//               splashColor: Color(0xFFF7D104).withOpacity(0.2),
//               onTap: onTap,
//               child: Container(
//                 width: 64,
//                 height: 64,
//                 child: Icon(
//                   icon,
//                   size: 32,
//                   color: Color(0xFF2A2A2A),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF2A2A2A),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: 'SFProDisplay',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showNotificationsPanel() {
//     // Implement the sliding notification panel here
//     // For simplicity, we'll just print the action
//     print('Show Notifications Panel');
//   }
// }



// modern_elevator_app/lib/screens/dashboard_screen.dart
// modern_elevator_app/lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'issue_reporting_screen.dart';
import 'time_tracking_screen.dart';
import '../widgets/base_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  final String mechanicName;

  DashboardScreen({required this.mechanicName});

  // Sample data for job sites and notifications
  final List<Map<String, dynamic>> jobSites = [
    {'siteName': 'Marcy Ave', 'elevatorNumber': 'EL#789'},
    {'siteName': 'Lorimer', 'elevatorNumber': 'EL#555'},
    {'siteName': 'Flushing Ave', 'elevatorNumber': 'EL#123'},
  ];

  final List<String> notifications = [
    'Safety meeting at 2 PM today.',
    'New message from Admin.',
    'Material request approved.',
  ];

  @override
  Widget build(BuildContext context) {
    // Get current date and time
    String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    String formattedTime = DateFormat('h:mm a').format(DateTime.now());

    return BaseScaffold(
      title: 'Dashboard',
      currentIndex: 0,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 16),
              // Header Section
              _buildHeaderSection(formattedDate, formattedTime),
              SizedBox(height: 20),
              // Notifications Section
              _buildNotificationsSection(),
              SizedBox(height: 20),
              // Assigned Job Sites Section
              _buildJobSitesSection(),
              SizedBox(height: 20),
              // Removed Quick Access Section
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
                      mechanicName,
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
                  print('Profile Avatar Tapped');
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

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title and Notification Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProDisplay',
                color: Colors.white,
              ),
            ),
            // Notification Bell Icon
            IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                  if (notifications.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFFF7D104),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                // Show Notification Panel
                _showNotificationsPanel();
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        // Notifications List
        Container(
          height: notifications.length * 70.0, // Adjust height based on item count
          child: ListView.builder(
            itemCount: notifications.length,
            physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
            itemBuilder: (context, index) {
              String notification = notifications[index];
              return Card(
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
                    notification,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFProDisplay',
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobSitesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assigned Job Sites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFProDisplay',
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          itemCount: jobSites.length,
          physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
          shrinkWrap: true, // Use minimum height needed
          itemBuilder: (context, index) {
            Map<String, dynamic> jobSite = jobSites[index];
            return GestureDetector(
              onTap: () {
                // Navigate to Job Site Details
                print('Job Site Tapped: ${jobSite['siteName']}');
              },
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
                    jobSite['siteName'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProDisplay',
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    jobSite['elevatorNumber'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFProDisplay',
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
          },
        ),
      ],
    );
  }

  void _showNotificationsPanel() {
    // Implement the sliding notification panel here
    // For simplicity, we'll just print the action
    print('Show Notifications Panel');
  }
}