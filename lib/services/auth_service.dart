import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note_manager/services/firestore_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  // Đăng ký tài khoản + Gửi email xác thực
  static Future<void> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Gửi email xác thực
    await userCredential.user?.sendEmailVerification();
    
    // Cập nhật trạng thái xác minh email
    final userId = userCredential.user?.uid;
    if (userId != null) {
      await FirestoreService.updateIsVerified(userId, false);
    }
  }

  // Đăng nhập + Kiểm tra email xác thực
  static Future<void> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Nếu email chưa xác thực, không cho login
    if (!(userCredential.user?.emailVerified ?? false)) {
      // Đăng xuất luôn nếu chưa xác thực
      await signOut();
      throw Exception('Email not verified. Please verify your email before logging in.');
    }

    // Cập nhật trạng thái xác minh email sau khi login thành công
    final userId = userCredential.user?.uid;
    if (userId != null) {
      await FirestoreService.updateIsVerified(userId, true);
    }
  }

  // Đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Đổi mật khẩu tài khoản (sau khi xác thực lại mật khẩu cũ)
  static Future<void> changeAccountPassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    // Reauthenticate
    await user.reauthenticateWithCredential(cred);

    // Update new password
    await user.updatePassword(newPassword);
  }

    // Gửi email đặt lại mật khẩu
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Error sending password reset email: $e");
      throw Exception('Error sending password reset email: $e');
    }
  }
}
