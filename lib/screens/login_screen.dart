// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// bool _obscurePassword = true; // For password visibility toggle

// class _LoginScreenState extends State<LoginScreen> {
//   // Controllers for text fields
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _rememberMe = false;

//   // Method to handle login button press
//   void _handleLogin() {
//     // TODO: Implement login functionality
//     print("Username: ${_usernameController.text}");
//     print("Password: ${_passwordController.text}");
//     print("Remember Me: $_rememberMe");
//   }

//   // Method to handle biometric authentication
//   void _handleBiometricAuth() {
//     // TODO: Implement biometric authentication
//     print("Biometric Authentication Initiated");
//   }

//   // Method to handle password visibility toggle
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   // Method to handle forgot password
//   void _handleForgotPassword() {
//     // TODO: Implement forgot password functionality
//     print("Forgot Password Pressed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Change as per design
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
//           child: Column(
//             children: <Widget>[
//               // Logo Image
//               Image.asset(
//                 'assets/images/modern_elevator_logo.png',
//                 width: 100,
//                 height: 100,
//               ),
//               SizedBox(height: 20),
//               // Title
//               Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404), // Black color
//                 ),
//               ),
//               SizedBox(height: 40),
//               // Username Field
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Password Field
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Remember Me and Forgot Password
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   // Remember Me Checkbox
//                   Row(
//                     children: <Widget>[
//                       Checkbox(
//                         value: _rememberMe,
//                         activeColor: Color(0xFFF7D104), // Yellow color
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _rememberMe = value ?? false;
//                           });
//                         },
//                       ),
//                       Text('Remember Me'),
//                     ],
//                   ),
//                   // Forgot Password Link
//                   TextButton(
//                     onPressed: _handleForgotPassword,
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                         color: Color(0xFFF7D104), // Yellow color
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               // Login Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handleLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF040404), // Black color
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     textStyle: TextStyle(fontSize: 18),
//                   ),
//                   child: Text('Login'),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Biometric Authentication Button
//               TextButton.icon(
//                 onPressed: _handleBiometricAuth,
//                 icon: Icon(
//                   Icons.fingerprint,
//                   color: Color(0xFF040404), // Black color
//                 ),
//                 label: Text(
//                   'Use Biometric Authentication',
//                   style: TextStyle(
//                     color: Color(0xFF040404), // Black color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//modern_elevator_app/lib/screens/login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dashboard_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// bool _obscurePassword = true; // For password visibility toggle

// class _LoginScreenState extends State<LoginScreen> {
//   // Controllers for text fields
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   bool _rememberMe = false;

//   // Method to handle login button press
//   void _handleLogin() {
//     // TODO: Implement login functionality

//     // For now, we'll assume the login is successful
//     String mechanicName = _usernameController.text; // Use the username as the mechanic's name

//     // Navigate to DashboardScreen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DashboardScreen(mechanicName: mechanicName),
//       ),
//     );
//   }

//   // Method to handle biometric authentication
//   void _handleBiometricAuth() {
//     // TODO: Implement biometric authentication
//     print("Biometric Authentication Initiated");
//   }

//   // Method to handle password visibility toggle
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   // Method to handle forgot password
//   void _handleForgotPassword() {
//     // TODO: Implement forgot password functionality
//     print("Forgot Password Pressed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Change as per design
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
//           child: Column(
//             children: <Widget>[
//               // Logo Image
//               Image.asset(
//                 'assets/images/modern_elevator_logo.png',
//                 width: 100,
//                 height: 100,
//               ),
//               SizedBox(height: 20),
//               // Title
//               Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF040404), // Black color
//                 ),
//               ),
//               SizedBox(height: 40),
//               // Username Field
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Password Field
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Remember Me and Forgot Password
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   // Remember Me Checkbox
//                   Row(
//                     children: <Widget>[
//                       Checkbox(
//                         value: _rememberMe,
//                         activeColor: Color(0xFFF7D104), // Yellow color
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _rememberMe = value ?? false;
//                           });
//                         },
//                       ),
//                       Text('Remember Me'),
//                     ],
//                   ),
//                   // Forgot Password Link
//                   TextButton(
//                     onPressed: _handleForgotPassword,
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                         color: Color(0xFFF7D104), // Yellow color
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               // Login Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handleLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF040404), // Black color
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     textStyle: TextStyle(fontSize: 18),
//                   ),
//                   child: Text('Login'),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Biometric Authentication Button
//               TextButton.icon(
//                 onPressed: _handleBiometricAuth,
//                 icon: Icon(
//                   Icons.fingerprint,
//                   color: Color(0xFF040404), // Black color
//                 ),
//                 label: Text(
//                   'Use Biometric Authentication',
//                   style: TextStyle(
//                     color: Color(0xFF040404), // Black color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// modern_elevator_app/lib/screens/login_screen.dart

// import 'package:flutter/material.dart';
// import 'dashboard_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // Controllers for text fields
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   bool _rememberMe = false;
//   bool _obscurePassword = true; // For password visibility toggle

//   // Method to handle login button press
//   void _handleLogin() {
//     // TODO: Implement login functionality

//     // For now, we'll assume the login is successful
//     String mechanicName = _usernameController.text; // Use the username as the mechanic's name

//     // Navigate to DashboardScreen
//     Navigator.pushReplacementNamed(context, '/dashboard');
//   }

//   // Method to handle biometric authentication
//   void _handleBiometricAuth() {
//     // TODO: Implement biometric authentication
//     print("Biometric Authentication Initiated");
//   }

//   // Method to handle password visibility toggle
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   // Method to handle forgot password
//   void _handleForgotPassword() {
//     // TODO: Implement forgot password functionality
//     print("Forgot Password Pressed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404), // Dark background
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
//           child: Column(
//             children: <Widget>[
//               // Logo Image
//               Image.asset(
//                 'assets/images/modern_elevator_logo.png',
//                 width: 100,
//                 height: 100,
//               ),
//               SizedBox(height: 20),
//               // Title
//               Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white, // White color
//                   fontFamily: 'SF Pro Display',
//                 ),
//               ),
//               SizedBox(height: 40),
//               // Username Field
//               TextField(
//                 controller: _usernameController,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   labelStyle: TextStyle(color: Colors.white),
//                   prefixIcon: Icon(Icons.person, color: Color(0xFFF7D104)),
//                   filled: true,
//                   fillColor: Color(0xFF121212),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Password Field
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   labelStyle: TextStyle(color: Colors.white),
//                   prefixIcon: Icon(Icons.lock, color: Color(0xFFF7D104)),
//                   filled: true,
//                   fillColor: Color(0xFF121212),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Remember Me and Forgot Password
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   // Remember Me Checkbox
//                   Row(
//                     children: <Widget>[
//                       Checkbox(
//                         value: _rememberMe,
//                         activeColor: Color(0xFFF7D104), // Yellow color
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _rememberMe = value ?? false;
//                           });
//                         },
//                       ),
//                       Text(
//                         'Remember Me',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   // Forgot Password Link
//                   TextButton(
//                     onPressed: _handleForgotPassword,
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                         color: Color(0xFFF7D104), // Yellow color
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               // Login Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handleLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFF7D104), // Yellow color
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     textStyle: TextStyle(fontSize: 18),
//                     foregroundColor: Color(0xFF040404), // Black color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   child: Text('Login'),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Biometric Authentication Button
//               TextButton.icon(
//                 onPressed: _handleBiometricAuth,
//                 icon: Icon(
//                   Icons.fingerprint,
//                   color: Color(0xFFF7D104), // Yellow color
//                 ),
//                 label: Text(
//                   'Use Biometric Authentication',
//                   style: TextStyle(
//                     color: Color(0xFFF7D104), // Yellow color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//src/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:modern_elevator_app/services/auth_manager.dart';
import 'package:modern_elevator_app/widgets/custom_text_field.dart';
import 'package:modern_elevator_app/widgets/custom_button.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await AuthManager().login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Get user data from response
      final userData = response['data']['user'];
      
      setState(() {
        _isLoading = false;
      });

      // Navigate to Dashboard with user name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DashboardScreen(
      //       mechanicName: "${userData['firstName']} ${userData['lastName']}",
      //     ),
      //   ),
      // );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040404), // Dark background
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Logo Image
                Image.asset(
                  'assets/images/modern_elevator_logo.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                // Title
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                SizedBox(height: 40),
                
                // Error message if any
                if (_errorMessage.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red.shade300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                
                SizedBox(height: 10),
                
                // Remember Me and Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Remember Me Checkbox
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          activeColor: Color(0xFFF7D104), // Yellow color
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    // Forgot Password Link
                    TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFFF7D104), // Yellow color
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 30),
                
                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                
                SizedBox(height: 20),
                
                // Don't have an account section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFFF7D104),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}