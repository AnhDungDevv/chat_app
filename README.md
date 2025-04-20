# 📱 **Chat App**

Ứng dụng nhắn tin này được xây dựng với **Clean Architecture** để đảm bảo tính mở rộng, bảo trì và testability cao. Nó cung cấp các tính năng nhắn tin, cuộc gọi video và âm thanh, chia sẻ trạng thái, và xác thực qua OTP, sử dụng **Supabase** như backend.

---

## 🔥 Tính năng chính

- 💬 Nhắn tin văn bản, hình ảnh, video, GIF và tin nhắn thoại.
- 📸 Chia sẻ và xem trạng thái (stories) của bạn bè.
- 📞 Gọi thoại và gọi video real-time với chất lượng cao.
- 🟢 Trạng thái online và "last seen".
- 🔐 Xác thực người dùng bằng OTP qua số điện thoại sử dụng Supabase.

## 🧱 Kiến trúc dự án

Dự án này được tổ chức theo kiến trúc **Clean Architecture**, giúp dễ dàng quản lý, mở rộng và kiểm thử ứng dụng. Các module và thư mục được chia rõ ràng theo các lớp khác nhau:

### **Cấu trúc thư mục**

```

lib/
├── routes/
├── features/
│   ├── app/
│       ├── config/
│       ├── constants/
│       ├── global/
│       ├── helpers/
│       ├── home/
│       ├── splash/
│       ├── storage/
│       ├── theme/
│       ├── welcome/
│   ├── call/
│   ├── chat/
│   ├── status/
│   ├── user/
│       ├── data/
│       │   ├── model/
│       │   ├── source/
│       │   └── repo_impl/
│       ├── domain/
│       │   ├── entity/
│       │   ├── repository/
│       │   └── usecase/
│       └── presentation/
│           ├── pages/
│           └── widget/
│           └── cubit/
```

### **Các thành phần chính trong Clean Architecture:**

1. **Data Layer**

   - Giao tiếp với Supabase (Auth, DB, Realtime)
   - Models chuyển đổi giữa JSON ↔ Entity
   - Repository implementation

2. **Domain Layer**

   - Entity cốt lõi`
   - Interface Repository
   - Usecase thực thi logic

3. **Presentation Layer**
   - UI (Pages + Widgets)
   - Cubit/BLoC để xử lý logic và emit trạng thái

---

## ⚙️ Công nghệ sử dụng

🐦 Flutter

💙 BLoC / Cubit (flutter_bloc) – Quản lý trạng thái

🔥 Supabase – Auth, Realtime Database, Storage

🌐 WebSocket – Realtime với Supabase

🛠 Clean Architecture – Tổ chức code rõ ràng, tách biệt trách nhiệm

📞 Agora SDK – Gọi video và âm thanh chất lượng cao

🔔 Firebase Messaging – Gửi thông báo đẩy (Push Notifications)

---

## 🚀 Cài đặt và chạy dự án

````bash
git clone https://github.com/AnhDungDevv/chat_app.git
cd chat_app
flutter pub get
flutter run

## 🧪 Testing

```bash
flutter test
````

---
