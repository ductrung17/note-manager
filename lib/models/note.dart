import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final String? password;
  final bool isProtected; // Thêm biến isProtected

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.password,
    this.isProtected = false, // Mặc định là false
  });

  factory Note.fromMap(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      password: data['password'],
      isProtected: data['isProtected'] ?? false, // Nếu không có isProtected, mặc định là false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'password': password,
      'isProtected': isProtected, // Lưu giá trị isProtected vào Firestore
    };
  }
}
