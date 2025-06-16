# 📒 Flutter Note Manager

Ứng dụng quản lý ghi chú cá nhân được phát triển bằng Flutter, tích hợp Firebase Authentication, Firestore và Cloud Functions. 
Hỗ trợ ghi chú, mã hóa ghi chú bằng mật khẩu, và cập nhật tự động thông tin người dùng thông qua Cloud Function.
Ứng dụng có thể chạy được trên android/web.

---

## 📁 Cấu trúc dự án

Toàn bộ mã nguồn được nén trong file `source.zip`. Sau khi giải nén, bạn sẽ thấy các thư mục:

```
source/
├── lib/                # Source code chính (Flutter)
├── android/            # Cấu hình Android
├── ios/                # Cấu hình iOS
├── functions/          # Firebase Cloud Functions (Node.js)
├── pubspec.yaml        # Cấu hình package Flutter
└── firebase.json       # Cấu hình dự án Firebase
```

---

## 🚀 Yêu cầu môi trường

| Thành phần              | Phiên bản khuyến nghị |
|------------------------|------------------------|
| **Flutter SDK**        | >= 3.7.2               |
| **Dart SDK**           | Theo Flutter           |
| **Node.js**            | v18.x (LTS)            |
| **Firebase CLI**       | >= 12.0.0              |
| **Android Studio / Xcode** | Dùng để chạy emulator nếu cần |

Cài Firebase CLI:
```bash
npm install -g firebase-tools
```

---

## 🔧 Thiết lập ban đầu

### 1. Giải nén mã nguồn

### 2. Cài đặt các package Flutter

```bash
flutter pub get
```

---

## 🔥 Cấu hình Firebase (đã liên kết sẵn)

- Firebase đã được tích hợp thông qua `google-services.json` (Android) và `firebase_core`.
- **Không cần tạo lại Firebase project**.
- Firebase Authentication và Firestore đã bật.
- Cloud Functions được sử dụng để ghi thông tin người dùng khi đăng ký.

---

## 🧠 Cloud Function 

- File `functions/index.js` có chứa hàm:

```js
exports.onNewUserSignup = functions.auth.user().onCreate((user) => { ... });
```

➡ Hàm này sẽ **tự động ghi thông tin người dùng mới vào Firestore**, và là một **thành phần bắt buộc để ứng dụng hoạt động đúng**.

---

## ⚙️ Deploy Cloud Functions

```bash
cd functions
npm install
firebase login
firebase use --add  # nếu bạn chưa liên kết project local (hoặc liên hệ chủ project để được add vào firebase)
firebase deploy --only functions
```

---

## 📱 Chạy ứng dụng Flutter

```bash
cd ..
flutter run
```

---
