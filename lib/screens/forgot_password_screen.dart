import 'package:flutter/material.dart';
import 'package:modern_elevator_app/services/auth_manager.dart';
import 'package:modern_elevator_app/widgets/custom_text_field.dart';
import 'package:modern_elevator_app/widgets/custom_button.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await AuthManager().forgotPassword(_emailController.text.trim());

      setState(() {
        _isLoading = false;
        _successMessage = 'If your email exists in our system, you will receive a password reset code.';
      });
      
      // Optionally navigate to a verification screen or reset password screen
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: _emailController.text.trim(),
            ),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // We don't want to show specific errors for security reasons
        _successMessage = 'If your email exists in our system, you will receive a password reset code.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040404),
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Color(0xFF040404),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Enter your email and we\'ll send you a code to reset your password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),

                // Error message
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

                // Success message
                if (_successMessage.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _successMessage,
                            style: TextStyle(color: Colors.green.shade300),
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
                  textInputAction: TextInputAction.done,
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
                SizedBox(height: 30),

                // Submit Button
                CustomButton(
                  text: 'Send Reset Code',
                  onPressed: _handleForgotPassword,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 20),

                // Back to login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: Color(0xFFF7D104),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}