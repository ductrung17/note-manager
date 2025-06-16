import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart'; // Thêm package crypto để mã hóa mật khẩu
import 'dart:convert'; // Để chuyển đổi mật khẩu sang dạng bytes

import '../models/note.dart';

class FirestoreService {
  static final _notesRef = FirebaseFirestore.instance.collection('notes');
  static final _usersRef = FirebaseFirestore.instance.collection('users'); // thêm collection users

  // Mã hóa mật khẩu trước khi lưu vào Firestore
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Cập nhật trạng thái xác minh email
  static Future<void> updateIsVerified(String userId, bool isVerified) async {
    try {
      await _usersRef.doc(userId).update({
        'isVerified': isVerified,
      });
      print("User verification status updated.");
    } catch (e) {
      print("Error updating user verification status: $e");
    }
  }

  // Lấy tất cả ghi chú của người dùng
  static Stream<List<Note>> getUserNotes() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return _notesRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Note.fromMap(doc.data(), doc.id)).toList();
        });
  }

  static Future<void> addNote(Note note) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final newNote = _notesRef.doc(note.id);
  await newNote.set({
    ...note.toMap(),
    'userId': userId,
  });
}

static Future<void> updateNote(Note note) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  // Lấy dữ liệu gốc để giữ lại password/isProtected nếu không truyền lại
  final existing = await _notesRef.doc(note.id).get();
  if (!existing.exists) return;

  final oldData = existing.data()!;
  final updatedData = {
    ...oldData,
    ...note.toMap(), // Ghi đè title, content, timestamp mới
    'userId': userId,
  };

  await _notesRef.doc(note.id).set(updatedData);
}

  // Xóa ghi chú
  static Future<void> deleteNote(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _notesRef.doc(id).delete();

   
  }

  // Cập nhật mật khẩu cho ghi chú (Khi bảo vệ ghi chú)
  static Future<void> protectNote(String noteId, String password) async {
    try {
      final hashedPassword = _hashPassword(password);
      await _notesRef.doc(noteId).update({
        'isProtected': true,
        'password': hashedPassword,
      });
    } catch (e) {
      print("Error protecting note: $e");
    }
  }

  // Loại bỏ mật khẩu bảo vệ ghi chú
  static Future<void> removePassword(String noteId, String enteredPassword) async {
    try {
      DocumentSnapshot noteDoc = await _notesRef.doc(noteId).get();
      if (noteDoc.exists) {
        String storedPassword = noteDoc['password'];

        if (_hashPassword(enteredPassword) == storedPassword) {
          await _notesRef.doc(noteId).update({
            'isProtected': false,
            'password': null,
          });
          print("Password removed successfully");
        } else {
          throw Exception("Incorrect password");
        }
      } else {
        throw Exception("Note not found");
      }
    } catch (e) {
      print("Error removing password: $e");
      rethrow;
    }
  }

  // Cập nhật mật khẩu bảo vệ ghi chú
  static Future<void> changePassword(String noteId, String enteredPassword, String newPassword) async {
    try {
      DocumentSnapshot noteDoc = await _notesRef.doc(noteId).get();
      if (noteDoc.exists) {
        String storedPassword = noteDoc['password'];

        if (_hashPassword(enteredPassword) == storedPassword) {
          final hashedNewPassword = _hashPassword(newPassword);
          await _notesRef.doc(noteId).update({
            'password': hashedNewPassword,
          });
          print("Password changed successfully");
        } else {
          throw Exception("Incorrect password");
        }
      } else {
        throw Exception("Note not found");
      }
    } catch (e) {
      print("Error changing password: $e");
      rethrow;
    }
  }

  // Xác minh mật khẩu
  static Future<bool> verifyPassword(String noteId, String enteredPassword) async {
    try {
      DocumentSnapshot noteDoc = await _notesRef.doc(noteId).get();
      if (noteDoc.exists && noteDoc['password'] != null) {
        String storedPassword = noteDoc['password'];

        if (_hashPassword(enteredPassword) == storedPassword) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Note not found or no password set');
      }
    } catch (e) {
      print("Error verifying password: $e");
      return false;
    }
  }
}
