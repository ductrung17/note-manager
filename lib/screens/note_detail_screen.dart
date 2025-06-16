import 'package:flutter/material.dart';
import 'package:flutter_note_manager/services/firestore_service.dart';
import '../models/note.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
  final updatedNote = Note(
    id: widget.note?.id ?? const Uuid().v4(),
    title: _titleController.text,
    content: _contentController.text,
    timestamp: DateTime.now(),
    isProtected: widget.note?.isProtected ?? false,
    password: widget.note?.password,
  );

  if (widget.note == null) {
    await FirestoreService.addNote(updatedNote);
  } else {
    await FirestoreService.updateNote(updatedNote);
  }

  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 23, color: Colors.black), // App name above the icon
        ),
        backgroundColor: Color(0xFFFFFACD), // Light Yellow color for the app bar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
            children: [
              // Title input field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Content input field with multiple lines
              TextField(
                controller: _contentController,
                maxLines: null, // Allow infinite lines
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save button with consistent theme
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFACD), // Light Yellow color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
