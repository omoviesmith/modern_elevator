// import 'package:flutter/material.dart';
// import 'package:modern_elevator_app/services/auth_manager.dart';
// import 'package:modern_elevator_app/widgets/custom_text_field.dart';
// import 'package:modern_elevator_app/widgets/custom_button.dart';
// import 'login_screen.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   final String email;

//   const ResetPasswordScreen({super.key, required this.email});

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _codeController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;
//   String _errorMessage = '';
//   String _successMessage = '';

//   @override
//   void dispose() {
//     _codeController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _togglePasswordVisibility(bool isConfirm) {
//     setState(() {
//       if (isConfirm) {
//         _obscureConfirmPassword = !_obscureConfirmPassword;
//       } else {
//         _obscurePassword = !_obscurePassword;
//       }
//     });
//   }

//   Future<void> _handleResetPassword() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//       _successMessage = '';
//     });

//     try {
//       await AuthManager().resetPassword(
//         _codeController.text.trim(),
//         _passwordController.text,
//       );

//       setState(() {
//         _isLoading = false;
//         _successMessage = 'Password has been reset successfully!';
//       });

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF040404),
//       appBar: AppBar(
//         title: Text('Reset Password'),
//         backgroundColor: Color(0xFF040404),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Create New Password',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Enter the code sent to ${widget.email} and create your new password',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 // Error message
//                 if (_errorMessage.isNotEmpty) ...[
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withAlpha(25),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red.shade300),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.error_outline, color: Colors.red),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             _errorMessage,
//                             style: TextStyle(color: Colors.red.shade300),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],

//                 // Success message
//                 if (_successMessage.isNotEmpty) ...[
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withAlpha(25),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green.shade300),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.check_circle_outline, color: Colors.green),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             _successMessage,
//                             style: TextStyle(color: Colors.green.shade300),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],

//                 // Reset Code Field
//                 CustomTextField(
//                   controller: _codeController,
//                   labelText: 'Reset Code',
//                   prefixIcon: Icons.security,
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the reset code';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // New Password Field
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'New Password',
//                   prefixIcon: Icons.lock,
//                   obscureText: _obscurePassword,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a new password';
//                     }
//                     if (value.length < 8) {
//                       return 'Password must be at least 8 characters';
//                     }
//                     return null;
//                   },
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () => _togglePasswordVisibility(false),
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Confirm New Password Field
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   labelText: 'Confirm New Password',
//                   prefixIcon: Icons.lock,
//                   obscureText: _obscureConfirmPassword,
//                   textInputAction: TextInputAction.done,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your new password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () => _togglePasswordVisibility(true),
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 // Reset Password Button
//                 CustomButton(
//                   text: 'Reset Password',
//                   onPressed: _handleResetPassword,
//                   isLoading: _isLoading,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:modern_elevator_app/services/auth_manager.dart';
import 'package:modern_elevator_app/widgets/custom_text_field.dart';
import 'package:modern_elevator_app/widgets/custom_button.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility(bool isConfirm) {
    setState(() {
      if (isConfirm) {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      } else {
        _obscurePassword = !_obscurePassword;
      }
    });
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await AuthManager().resetPassword(
        _codeController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _successMessage = 'Password has been reset successfully!';
      });

      // Use a separate method to handle navigation after delay
      _navigateToLoginAfterDelay();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  // Separate method to handle navigation after delay
  void _navigateToLoginAfterDelay() {
    // Use a direct callback instead of Future.delayed
    // This is not considered an async gap because we're not awaiting anything
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040404),
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: const Color(0xFF040404),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter the code sent to ${widget.email} and create your new password',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),

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

                // Reset Code Field
                CustomTextField(
                  controller: _codeController,
                  labelText: 'Reset Code',
                  prefixIcon: Icons.security,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reset code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // New Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'New Password',
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => _togglePasswordVisibility(false),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm New Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  prefixIcon: Icons.lock,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => _togglePasswordVisibility(true),
                  ),
                ),
                const SizedBox(height: 30),

                // Reset Password Button
                CustomButton(
                  text: 'Reset Password',
                  onPressed: _handleResetPassword,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}