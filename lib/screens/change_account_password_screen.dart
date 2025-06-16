import 'package:flutter/material.dart';
import 'package:flutter_note_manager/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeAccountPasswordScreen extends StatefulWidget {
  const ChangeAccountPasswordScreen({super.key});

  @override
  _ChangeAccountPasswordScreenState createState() => _ChangeAccountPasswordScreenState();
}

class _ChangeAccountPasswordScreenState extends State<ChangeAccountPasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await AuthService.changeAccountPassword(
          _currentPasswordController.text.trim(),
          _newPasswordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFACD),
        title: const Text('Change Account Password'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change your account password securely.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('Current Password', 'Enter your current password'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter current password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('New Password', 'Enter new password'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter new password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('Confirm Password', 'Confirm new password'),
                    validator: (value) => (value != _newPasswordController.text) ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                ],
              
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
