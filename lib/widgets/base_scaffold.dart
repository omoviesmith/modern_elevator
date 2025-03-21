// modern_elevator_app/lib/widgets/base_scaffold.dart
// import 'package:flutter/material.dart';
// import 'package:modern_elevator_app/screens/time_tracking_screen.dart';

// class BaseScaffold extends StatelessWidget {
//   final Widget body;
//   final String? title;
//   final bool showAppBar;
//   final bool showFAB;
//   final int currentIndex;

//   BaseScaffold({
//     required this.body,
//     this.title,
//     this.showAppBar = true,
//     this.showFAB = true,
//     this.currentIndex = 0,
//   });

//   void _onItemTapped(BuildContext context, int index) {
//     if (index == currentIndex) return;

//     // Navigation logic based on index
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/issue_reporting');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/settings');
//         break;
//       case 3:
//         // Handle logout
//         Navigator.pushReplacementNamed(context, '/login');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Define BottomAppBar items
//     List<BottomNavigationBarItem> items = [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Dashboard',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.report_problem),
//         label: 'Issue Reporting',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.settings),
//         label: 'Settings',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.logout),
//         label: 'Logout',
//       ),
//     ];

//     return Scaffold(
//       appBar: showAppBar
//           ? AppBar(
//               title: Text(
//                 title ?? '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'SF Pro Display',
//                 ),
//               ),
//               backgroundColor: Color(0xFF040404),
//             )
//           : null,
//       body: body,
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xFF121212),
//         selectedItemColor: Color(0xFFF7D104),
//         unselectedItemColor: Colors.white70,
//         currentIndex: currentIndex,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) => _onItemTapped(context, index),
//         items: items,
//       ),
//       floatingActionButton: showFAB
//           ? FloatingActionButton(
//               backgroundColor: Color(0xFFF7D104),
//               child: Icon(
//                 Icons.timer,
//                 color: Color(0xFF040404),
//               ),
//               onPressed: () {
//                 if (currentIndex != 0) {
//                   Navigator.pushNamed(context, '/time_tracking');
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => TimeTrackingScreen(),
//                     ),
//                   );
//                 }
//               },
//             )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }


// modern_elevator_app/lib/widgets/base_scaffold.dart
import 'package:flutter/material.dart';
import 'package:modern_elevator_app/screens/time_tracking_screen.dart';
import 'package:modern_elevator_app/screens/issue_reporting_screen.dart';
import 'package:modern_elevator_app/screens/dashboard_screen.dart';
import 'package:modern_elevator_app/screens/daily_report_screen.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showAppBar;
  final bool showFAB;
  final int currentIndex;

  BaseScaffold({
    required this.body,
    this.title,
    this.showAppBar = true,
    this.showFAB = true,
    this.currentIndex = 0,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Navigation logic based on index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IssueReportingMaterialRequestScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DailyReportReviewScreen()),
        );
        break;
      case 3:
        // Handle logout or navigate to LoginScreen
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define BottomAppBar items
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.report_problem),
        label: 'Issue Reporting',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.article), // New icon for the Daily Report Screen
        label: 'Daily Report',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.logout),
        label: 'Logout',
      ),
    ];

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(
                title ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              backgroundColor: Color(0xFF040404),
            )
          : null,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF121212),
        selectedItemColor: Color(0xFFF7D104),
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _onItemTapped(context, index),
        items: items,
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              backgroundColor: Color(0xFFF7D104),
              child: Icon(
                Icons.timer,
                color: Color(0xFF040404),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeTrackingScreen(),
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}