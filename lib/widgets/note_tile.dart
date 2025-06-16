import 'package:flutter/material.dart';
import 'package:flutter_note_manager/models/note.dart';
import 'package:flutter_note_manager/screens/note_detail_screen.dart';
import 'package:flutter_note_manager/screens/password_confirmation_screen.dart'; // Màn hình nhập mật khẩu
import 'package:flutter_note_manager/screens/create_password_screen.dart';
import 'package:flutter_note_manager/screens/change_password_screen.dart';  
import 'package:flutter_note_manager/screens/remove_password_screen.dart';
import 'package:flutter_note_manager/services/firestore_service.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  const NoteTile({super.key, required this.note});

  // Method to show confirmation dialog before deleting a note
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String noteId) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
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
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await FirestoreService.deleteNote(noteId); // Delete the note
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted successfully')),
                );
              },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.black87),  // Correct color specification
            ),              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Nền trắng toàn bộ
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            note.isProtected
                ? const Text("Content is protected", style: TextStyle(fontStyle: FontStyle.italic))
                : Text(
                      note.content,
                      maxLines: 3,  // Giới hạn chỉ hiển thị 2 dòng
                      overflow: TextOverflow.ellipsis,  // Thêm dấu "..." khi nội dung vượt quá 2 dòng
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

            const SizedBox(height: 5), // Thêm khoảng cách giữa nội dung và thời gian
            Align(
              alignment: Alignment.bottomLeft, // Căn văn bản "Created at" sang bên phải
              child: Text(
                'Last updated: ${DateFormat('dd-MM-yyyy HH:mm').format(note.timestamp.toLocal())}',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'protect') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePasswordScreen(noteId: note.id)),
              );
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(context, note.id);
            } else if (value == 'change_password') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen(noteId: note.id)),
              );
            } else if (value == 'remove_password') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RemovePasswordScreen(noteId: note.id)),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> menuItems = [
              if (note.isProtected)
                PopupMenuItem<String>(
                  value: 'remove_password',
                  child: Row(
                    children: [
                      Icon(Icons.lock_open, size: 18),
                      SizedBox(width: 8),
                      Text('Remove Password'),
                    ],
                  ),
                ),
              if (!note.isProtected)
                PopupMenuItem<String>(
                  value: 'protect',
                  child: Row(
                    children: [
                      Icon(Icons.lock, size: 18),
                      SizedBox(width: 8),
                      Text('Protect'),
                    ],
                  ),
                ),
              if (note.isProtected)
                PopupMenuItem<String>(
                  value: 'change_password',
                  child: Row(
                    children: [
                      Icon(Icons.password, size: 18),
                      SizedBox(width: 8),
                      Text('Change Password'),
                    ],
                  ),
                ),
              PopupMenuItem<String>(
                value: 'delete',
                enabled: !note.isProtected,
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: note.isProtected ? Colors.grey : null),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: note.isProtected ? Colors.grey : null)),
                  ],
                ),
              ),
            ];

            return menuItems;
          },
        ),
        onTap: () {
          if (note.isProtected) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PasswordConfirmationScreen(note: note),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoteDetailScreen(note: note),
              ),
            );
          }
        },
      ),
    );
  }
}
