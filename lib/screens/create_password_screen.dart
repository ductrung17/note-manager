import 'package:flutter/material.dart';
import 'package:flutter_note_manager/services/firestore_service.dart';

import 'package:google_fonts/google_fonts.dart' show GoogleFonts; // For utf8 encoding

class CreatePasswordScreen extends StatefulWidget {
  final String noteId;

  const CreatePasswordScreen({super.key, required this.noteId});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _setPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Hash the password before storing it
      final password = _passwordController.text;
      // final hashedPassword = _hashPassword(password);

      // Call Firestore to set the hashed password
      await FirestoreService.protectNote(widget.noteId, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password set successfully')),
      );
      Navigator.pop(context); // Close the screen
    }
  }


  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
title: Text(
          'Set Password', // App name above the icon
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w400,
            color: Colors.black, 
          ),
        ),           centerTitle: true,
     backgroundColor: const Color(0xFFFFFACD), // Light Yellow Background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Tiêu đề cảnh báo
                  Text(
                    'Please set a password to protect your note.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Button
                  ElevatedButton(
                    onPressed: _setPassword,
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
      )
    ;
  }
}