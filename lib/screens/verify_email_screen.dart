// //lib/screens/verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:modern_elevator_app/services/auth_manager.dart';
import 'package:modern_elevator_app/widgets/custom_button.dart';
import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  String? _firstName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final registrationData = await AuthManager().getRegistrationData();
    if (registrationData != null && registrationData['firstName'] != null) {
      setState(() {
        _firstName = registrationData['firstName'];
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitEntered(int index, String value) {
    if (value.length == 1) {
      // Move to next field if not the last one
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, verify code
        _verifyCode();
      }
    }
  }

  String _getVerificationCode() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _getVerificationCode();

    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits of the verification code';
        _successMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await AuthManager().verifyEmail(widget.email, code);

      setState(() {
        _isLoading = false;
        _successMessage = 'Email verified successfully!';
      });

      // Clear registration data since verification is complete
      await AuthManager().clearRegistrationData();

      // Capture the Navigator before the async gap
      final navigator = Navigator.of(context);

      // Wait a moment to show success message then navigate to login
      Future.delayed(const Duration(seconds: 2), () {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _resendCode() async {
    // Implement resend code functionality here
    // This would typically call a resend verification endpoint
    setState(() {
      _errorMessage = '';
      _successMessage = 'Verification code has been resent!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040404),
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: const Color(0xFF040404),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hey ${_firstName ?? "there"}, we\'ve sent a verification code to:',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Success message
              if (_successMessage.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage,
                          style: TextStyle(color: Colors.green.shade300),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Verification code input fields
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 45,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _focusNodes[index].hasFocus
                            ? const Color(0xFFF7D104)
                            : Colors.grey.shade800,
                      ),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _onDigitEntered(index, value),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Verify Button
              CustomButton(
                text: 'Verify Email',
                onPressed: _verifyCode,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),

              // Resend code
              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: const Text(
                    'Didn\'t receive a code? Resend',
                    style: TextStyle(
                      color: Color(0xFFF7D104),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Check your email for a 6-digit verification code',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '2. Enter the code above',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '3. Click "Verify Email" to complete registration',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_elevator_app/services/auth_manager.dart';
// import 'package:modern_elevator_app/widgets/custom_button.dart';
// import 'login_screen.dart';

// class VerifyEmailScreen extends StatefulWidget {
//   final String email;

//   const VerifyEmailScreen({super.key, required this.email});

//   @override
//   _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
// }

// class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(
//     6,
//     (_) => FocusNode(),
//   );

//   bool _isLoading = false;
//   String _errorMessage = '';
//   String _successMessage = '';
//   String? _firstName;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final registrationData = await AuthManager().getRegistrationData();
//     if (registrationData != null && registrationData['firstName'] != null) {
//       setState(() {
//         _firstName = registrationData['firstName'];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onDigitEntered(int index, String value) {
//     if (value.length == 1) {
//       // Move to next field if not the last one
//       if (index < 5) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         // Last digit entered, verify code
//         _verifyCode();
//       }
//     }
//   }

//   String _getVerificationCode() {
//     return _controllers.map((c) => c.text).join();
//   }

//   Future<void> _verifyCode() async {
//     final code = _getVerificationCode();

//     if (code.length != 6) {
//       setState(() {
//         _errorMessage = 'Please enter all 6 digits of the verification code';
//         _successMessage = '';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//       _successMessage = '';
//     });

//     try {
//       await AuthManager().verifyEmail(widget.email, code);

//       setState(() {
//         _isLoading = false;
//         _successMessage = 'Email verified successfully!';
//       });

//       // Clear registration data since verification is complete
//       await AuthManager().clearRegistrationData();

//       // Wait a moment to show success message then navigate to login
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//           (route) => false,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString().replaceAll('Exception: ', '');
//       });
//     }
//   }

//   Future<void> _resendCode() async {
//     // Implement resend code functionality here
//     // This would typically call a resend verification endpoint
//     setState(() {
//       _errorMessage = '';
//       _successMessage = 'Verification code has been resent!';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404),
//       appBar: AppBar(
//         title: Text('Verify Email'),
//         backgroundColor: Color(0xFF040404),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Verify Your Email',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Hey ${_firstName ?? "there"}, we\'ve sent a verification code to:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.email,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 24),

//               // Error message
//               if (_errorMessage.isNotEmpty) ...[
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withAlpha(25),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _errorMessage,
//                           style: TextStyle(color: Colors.red.shade300),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Success message
//               if (_successMessage.isNotEmpty) ...[
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withAlpha(25),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle_outline, color: Colors.green),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _successMessage,
//                           style: TextStyle(color: Colors.green.shade300),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Verification code input fields
//               Text(
//                 'Enter Verification Code',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   6,
//                   (index) => Container(
//                     width: 45,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF121212),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: _focusNodes[index].hasFocus
//                             ? Color(0xFFF7D104)
//                             : Colors.grey.shade800,
//                       ),
//                     ),
//                     child: TextField(
//                       controller: _controllers[index],
//                       focusNode: _focusNodes[index],
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       maxLength: 1,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       decoration: InputDecoration(
//                         counterText: '',
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) => _onDigitEntered(index, value),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),

//               // Verify Button
//               CustomButton(
//                 text: 'Verify Email',
//                 onPressed: _verifyCode,
//                 isLoading: _isLoading,
//               ),
//               SizedBox(height: 20),

//               // Resend code
//               Center(
//                 child: TextButton(
//                   onPressed: _resendCode,
//                   child: Text(
//                     'Didn\'t receive a code? Resend',
//                     style: TextStyle(
//                       color: Color(0xFFF7D104),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Instructions
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade900,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Instructions:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '1. Check your email for a 6-digit verification code',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     Text(
//                       '2. Enter the code above',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     Text(
//                       '3. Click "Verify Email" to complete registration',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_elevator_app/services/auth_manager.dart';
// import 'package:modern_elevator_app/widgets/custom_button.dart';
// import 'login_screen.dart';

// class VerifyEmailScreen extends StatefulWidget {
//   final String email;

//   const VerifyEmailScreen({super.key, required this.email});

//   @override
//   _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
// }

// class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(
//     6,
//     (_) => FocusNode(),
//   );

//   bool _isLoading = false;
//   String _errorMessage = '';
//   String _successMessage = '';
//   String? _firstName;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final registrationData = await AuthManager().getRegistrationData();
//     if (registrationData != null && registrationData['firstName'] != null) {
//       setState(() {
//         _firstName = registrationData['firstName'];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onDigitEntered(int index, String value) {
//     if (value.length == 1) {
//       // Move to next field if not the last one
//       if (index < 5) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         // Last digit entered, verify code
//         _verifyCode();
//       }
//     }
//   }

//   void _onKeyPressed(int index, RawKeyEvent event) {
//     // If backspace is pressed and field is empty, move focus to previous field
//     if (event is KeyDownEvent) {
//       if (event.logicalKey.keyLabel == 'Backspace' && 
//           _controllers[index].text.isEmpty && 
//           index > 0) {
//         _focusNodes[index - 1].requestFocus();
//       }
//     }
//   }

//   String _getVerificationCode() {
//     return _controllers.map((c) => c.text).join();
//   }

//   Future<void> _verifyCode() async {
//     final code = _getVerificationCode();
    
//     if (code.length != 6) {
//       setState(() {
//         _errorMessage = 'Please enter all 6 digits of the verification code';
//         _successMessage = '';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//       _successMessage = '';
//     });

//     try {
//       await AuthManager().verifyEmail(widget.email, code);

//       setState(() {
//         _isLoading = false;
//         _successMessage = 'Email verified successfully!';
//       });

//       // Clear registration data since verification is complete
//       await AuthManager().clearRegistrationData();

//       // Wait a moment to show success message then navigate to login
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//           (route) => false,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString().replaceAll('Exception: ', '');
//       });
//     }
//   }

//   Future<void> _resendCode() async {
//     // Implement resend code functionality here
//     // This would typically call a resend verification endpoint
//     setState(() {
//       _errorMessage = '';
//       _successMessage = 'Verification code has been resent!';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404),
//       appBar: AppBar(
//         title: Text('Verify Email'),
//         backgroundColor: Color(0xFF040404),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Verify Your Email',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Hey ${_firstName ?? "there"}, we\'ve sent a verification code to:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.email,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 24),

//               // Error message
//               if (_errorMessage.isNotEmpty) ...[
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withAlpha(25),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _errorMessage,
//                           style: TextStyle(color: Colors.red.shade300),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Success message
//               if (_successMessage.isNotEmpty) ...[
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withAlpha(25),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle_outline, color: Colors.green),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _successMessage,
//                           style: TextStyle(color: Colors.green.shade300),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],

//               // Verification code input fields
//               Text(
//                 'Enter Verification Code',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   6,
//                   (index) => Container(
//                     width: 45,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF121212),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: _focusNodes[index].hasFocus
//                             ? Color(0xFFF7D104)
//                             : Colors.grey.shade800,
//                       ),
//                     ),
//                     child: TextField(
//                       controller: _controllers[index],
//                       focusNode: _focusNodes[index],
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       maxLength: 1,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       decoration: InputDecoration(
//                         counterText: '',
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) => _onDigitEntered(index, value),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),

//               // Verify Button
//               CustomButton(
//                 text: 'Verify Email',
//                 onPressed: _verifyCode,
//                 isLoading: _isLoading,
//               ),
//               SizedBox(height: 20),

//               // Resend code
//               Center(
//                 child: TextButton(
//                   onPressed: _resendCode,
//                   child: Text(
//                     'Didn\'t receive a code? Resend',
//                     style: TextStyle(
//                       color: Color(0xFFF7D104),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Instructions
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade900,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Instructions:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '1. Check your email for a 6-digit verification code',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     Text(
//                       '2. Enter the code above',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     Text(
//                       '3. Click "Verify Email" to complete registration',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }