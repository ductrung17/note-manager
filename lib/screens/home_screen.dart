import 'package:flutter/material.dart';
import 'package:flutter_note_manager/screens/change_account_password_screen.dart';
import 'package:flutter_note_manager/services/firestore_service.dart';
import 'package:flutter_note_manager/services/auth_service.dart';
import 'package:flutter_note_manager/screens/note_detail_screen.dart';
import 'package:flutter_note_manager/widgets/note_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import 'login_screen.dart'; // Màn hình Login

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Hàm lấy lời chào theo thời gian trong ngày
String _getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good morning!';
  } else if (hour < 18) {
    return 'Good afternoon!';
  } else {
    return 'Good evening!';
  }
}

// Hàm lấy ngày tháng và ngày trong tuần
String _getFormattedDate() {
  final now = DateTime.now();
  final weekday = _getWeekday(now.weekday); // Lấy ngày trong tuần
  return '$weekday, ${now.day}-${now.month}-${now.year}'; // Format ngày
}

// Chuyển đổi số ngày trong tuần thành tên ngày (Mon, Tue, ...)
String _getWeekday(int weekday) {
  switch (weekday) {
    case 1: return 'Mon';
    case 2: return 'Tue';
    case 3: return 'Wed';
    case 4: return 'Thu';
    case 5: return 'Fri';
    case 6: return 'Sat';
    case 7: return 'Sun';
    default: return '';
  }
}
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false, // Không tự động hiển thị nút back

        backgroundColor: const Color(0xFFFFFACD), 
        title: Text(
          'Note Manager', // App name above the icon
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w400,
            color: Colors.black, 
          ),
        ),
        centerTitle: true,
    ),
      body: Column(
        children: [
          // Header with greeting and today label
          // Thêm vào widget AppBar
Padding(
  padding: const EdgeInsets.only(left: 22.0, right: 25.0, top: 23.0, bottom: 10.0), // Lùi vào một chút từ lề trái
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Row chứa cả lời chào và PopupMenuButton
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Căn lề trái cho lời chào, phải cho nút menu
        children: [
          // Lời chào
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getFormattedDate(), // Hiển thị ngày trong tuần và ngày tháng
                style: GoogleFonts.poppins(
                  fontSize: 17,  // Kích thước chữ
                  fontWeight: FontWeight.w600, // Độ đậm chữ
                  color: Colors.black87, // Màu chữ
                ),
              ),
              Text(
                _getGreeting(), // Hiển thị lời chào
                style: GoogleFonts.poppins(
                  fontSize: 17,  // Kích thước chữ
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400, // Độ đậm chữ
                  color: Colors.black87, // Màu chữ
                ),
              ),
            ],
          ),
          // PopupMenuButton nằm ngang hàng với lời chào, căn phải
     PopupMenuButton<String>(
  color: Colors.white,
  icon: const Icon(
    Icons.person,
    size: 50.0,  // Thay đổi kích thước biểu tượng
    color: Color(0xFFFFE135),
  ),
  onSelected: (value) {
    if (value == 'change_account_password') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChangeAccountPasswordScreen()),
      );
    } else if (value == 'logout') {
      // Hiển thị hộp thoại xác nhận trước khi đăng xuất
      _showLogoutDialog(context);
     
  }
  },
  itemBuilder: (context) => [
    const PopupMenuItem<String>(
      value: 'change_account_password',
      child: Text('Change Account Password'),
    ),
    const PopupMenuItem<String>(
      value: 'logout',
      child: Text('Logout'),
    ),
   
  ],
)

// Hàm hiển thị hộp thoại xác nhận đăng xuất

],
      ),
    ],
  ),
),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NoteDetailScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Color(0xFFFFFACD),  // Màu nền của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),  // Bo góc
                ),
              ),
              child: Text(
                'New Note',  // Nội dung nút
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),            ),   
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: FirestoreService.getUserNotes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final notes = snapshot.data!;
                if (notes.isEmpty) return const Center(child: Text("No notes yet!", style: TextStyle(fontSize: 18)));
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notes.length,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: NoteTile(note: notes[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
     
    );
  }
  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              // Đóng hộp thoại và không làm gì
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),  // Correct color specification
            ),          ),
          TextButton(
            onPressed: () {
              // Đăng xuất và chuyển hướng đến màn hình đăng nhập
              AuthService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
child: const Text(
  'Yes',
  style: TextStyle(color: Colors.black87),  // Correct color specification
),          ),
        ],
      );
    },
  );
}

}
