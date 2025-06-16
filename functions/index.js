const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Cloud Function khi người dùng mới đăng ký
exports.onNewUserSignup = functions.auth.user().onCreate(async (user) => {
  // Kiểm tra xem user có tồn tại và có email không
  if (user && user.email) {
    const email = user.email;
    console.log(`New user signed up with email: ${email}`);
    
    try {
      // Lưu thông tin người dùng vào Firestore trong collection 'users'
      await admin.firestore().collection('users').doc(user.uid).set({
        email: email,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isVerified: false,  // Đánh dấu là chưa xác thực email
      });

      console.log("User information saved successfully");

      // Gửi email xác thực nếu chưa có
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        console.log("Verification email sent.");
      }
    } catch (error) {
      console.error("Error saving user information or sending verification email: ", error);
    }
  } else {
    console.log("Error: User or email is undefined.");
    return null; // Hoặc trả về một hành động tùy chọn khi `user` không hợp lệ
  }
});
