import 'package:flutter/material.dart';
import 'package:flutter_note_manager/models/note.dart';
import 'package:flutter_note_manager/services/firestore_service.dart'; // Assuming FirestoreService is already set up
import 'package:flutter_note_manager/screens/note_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts; // Import the note detail screen

class PasswordConfirmationScreen extends StatefulWidget {
  final Note note;  // Define the note parameter

  const PasswordConfirmationScreen({super.key, required this.note});

  @override
  _PasswordConfirmationScreenState createState() =>
      _PasswordConfirmationScreenState();
}

class _PasswordConfirmationScreenState
    extends State<PasswordConfirmationScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Function to verify the password entered by the user
  Future<void> _verifyPassword() async {
    String enteredPassword = _passwordController.text;

    try {
      // Call FirestoreService to verify password
      bool isPasswordCorrect = await FirestoreService.verifyPassword(
        widget.note.id, // Access note using widget.note
        enteredPassword,
      );

      // If the password is correct, navigate to the NoteDetailScreen
      if (isPasswordCorrect) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NoteDetailScreen(note: widget.note)),
        );
      } else {
        // If the password is incorrect, show a SnackBar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } catch (e) {
      // If there is an error, show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify password. Please try a gain.'),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
title: Text(
          'Password Confirmation', // App name above the icon
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w400,
            color: Colors.black, 
          ),
        ),              centerTitle: true,
   backgroundColor: const Color(0xFFFFFACD), // Vàng nhạt
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning text (có thể bỏ nếu không cần)
                  Text(
                    'Please confirm your password to continue.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      hintText: 'Confirm your password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: _verifyPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            
          ),
        ),
      ),
    );
  }}