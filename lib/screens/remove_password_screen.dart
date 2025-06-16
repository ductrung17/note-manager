import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:flutter_note_manager/services/firestore_service.dart'; // Import FirestoreService

class RemovePasswordScreen extends StatefulWidget {
  final String noteId;

  const RemovePasswordScreen({super.key, required this.noteId});

  @override
  _RemovePasswordScreenState createState() => _RemovePasswordScreenState();
}

class _RemovePasswordScreenState extends State<RemovePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Method to show confirmation dialog
  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal'),
          content: const Text('Are you sure you want to remove the password?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),  // Correct color specification
            ),              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _removePassword(); // Call the remove password function
              },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.black87),  // Correct color specification
            ),              ),
          ],
        );
      },
    );
  }

  Future<void> _removePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String enteredPassword = _currentPasswordController.text;

        // Call Firestore to remove the password
        await FirestoreService.removePassword(widget.noteId, enteredPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password removed successfully')),
        );
        Navigator.pop(context); // Close the screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove password. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
title: Text(
          'Remove Password', // App name above the icon
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w400,
            color: Colors.black, 
          ),
        ),               centerTitle: true,
  backgroundColor: const Color(0xFFFFFACD), // Light Yellow Background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
              children: [
                // Warning title
                Text(
                  'Please enter the current password to remove it.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),

                // Current Password input field
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    hintText: 'Enter current password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Remove Password button with ElevatedButton
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showConfirmationDialog, // Show confirmation dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFACD), // Light Yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Remove Password',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
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
