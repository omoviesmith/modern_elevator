// //modern_elevator_app/lib/screens/splash_screen.dart

// import 'package:flutter/material.dart';
// import 'login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {

//   // Navigate to Login Screen after a delay
//   @override
//   void initState() {
//     super.initState();
//     _navigateToLogin();
//   }

//   _navigateToLogin() async {
//     await Future.delayed(Duration(milliseconds: 3000), () {});
//     Navigator.pushReplacement(
//       context, 
//       MaterialPageRoute(builder: (context) => LoginScreen())
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404), // Black background
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.asset(
//               'assets/images/modern_elevator_logo.png',
//               width: 150,
//               height: 150,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Modern Elevator',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Color(0xFFF7D104), // Yellow color
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// modern_elevator_app/lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Navigate to Login Screen after a delay
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040404), // Black background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/modern_elevator_logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Modern Elevator',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFF7D104), // Yellow color
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ],
        ),
      ),
    );
  }
}