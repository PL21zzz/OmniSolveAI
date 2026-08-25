# 🚀 OmniSolve AI – All-in-One AI Learning Ecosystem & STEM Error Debugger

**OmniSolve AI** là một ứng dụng di động đa nền tảng được phát triển bằng **Flutter**, kết hợp với sức mạnh của **Google Gemini Vision & Text AI API**, mang đến một hệ sinh thái học tập toàn diện cho học sinh, sinh viên và lập trình viên.

Ứng dụng không chỉ đóng vai trò giải bài tập thông thường mà còn đóng vai trò như một **Gia sư Socratic**, phát hiện chính xác **bước bị tính sai trong bài làm viết tay**, cung cấp gợi ý nhiều cấp độ, tạo thẻ ôn tập Flashcard tự động và phân tích tiến độ năng lực qua biểu đồ trực quan.

---

## ✨ Tính Năng Nổi Bật (Key Features)

### 📸 1. AI Homework Scanner & Handwriting Debugger (Chẩn đoán Lỗi sai Bài viết tay)
* **Vision OCR & Diagnostics:** Chụp hoặc tải ảnh bài làm tay (Toán, Lý, Hóa, Tích phân, Ma trận,...).
* **Target Step Pinpointing:** Khoanh vùng chính xác bước tính toán hoặc logic bị sai (Ví dụ: *"Lỗi ở Bước 2: Quên đổi dấu khi áp dụng tích phân từng phần"*).
* **Socratic Hint System:** Cung cấp Gợi ý Cấp 1, Gợi ý Cấp 2 và Lời giải chi tiết theo từng nấc tư duy.
* **Practice Generator:** Tự động tạo bài tập tương tự để luyện tập củng cố kiến thức.

### 💬 2. AI Tutor Chatbot 24/7 (Gia sư Trò chuyện Đa môn học)
* Hỗ trợ hỏi đáp 24/7 theo môn học (Toán học, Vật Lý, Hóa Học, Lập Trình, Tiếng Anh).
* Tích hợp các nút gợi ý nhanh (*"Giải thích đơn giản hơn"*, *"Cho ví dụ thực tế"*, *"Tóm tắt công thức"*).
* Hỗ trợ đính kèm hình ảnh trực tiếp vào khung chat.

### 🎴 3. AI Quiz & Spaced Repetition Flashcards (Bộ thẻ Ghi nhớ Thông minh)
* Tự động tạo thẻ ghi nhớ Flashcard từ các bài tập hay làm sai.
* Hiệu ứng lật thẻ 3D mượt mà cùng hệ thống đánh giá mức độ thuộc lòng (*Chưa thuộc 🔴*, *Khá thuộc 🟡*, *Thuộc lòng 🟢*).
* Thuật toán lặp lại ngắt quãng (Spaced Repetition) nhắc nhở thời điểm ôn tập tối ưu.

### 📊 4. Analytics & Weakness Heatmap (Thống kê Năng lực Trực quan)
* Biểu đồ thời lượng học tập trong tuần được dựng bằng `fl_chart`.
* Thống kê tổng số bài đã giải, chuỗi ngày học liên tục (Streak 🔥) và tỷ lệ làm đúng.
* Thanh đo độ thành thạo theo từng môn học giúp học sinh khắc phục điểm yếu.

### 🌓 5. Dynamic Light & Dark Mode System (Hệ thống Theme Sáng / Tối 1-Touch)
* Thiết kế chuẩn Material 3 dựa trên palette **Electric Teal (`#0D9488`)** sang trọng.
* Nền sáng trắng xám tinh tế (`#F8FAFC`) và Nền tối Slate Onyx (`#0F172A`) bảo vệ thị giác khi học ban đêm.
* Chuyển đổi Theme 1 chạm mượt mà duy trì qua `SharedPreferences`.

### 🔐 6. Google Sign-In & Firebase Integration (Quản lý Tài khoản)
* Giao diện đăng nhập Google Auth 1-click chuẩn Firebase.
* Lưu trữ và đồng bộ hóa lịch sử bài giải, bộ thẻ học tập lên mây.

---

## 🛠️ Công Nghệ Sử Dụng (Tech Stack)

* **Core Framework:** Flutter 3.29.0 / Dart 3.7.0
* **State Management:** Riverpod (`flutter_riverpod: ^2.6.1`)
* **AI & Intelligence:** Google Generative AI SDK (`google_generative_ai: ^0.4.7`) - Gemini 1.5/2.0 Flash
* **Typography & Math:** Google Fonts (`google_fonts`), LaTeX Rendering (`flutter_math_fork`)
* **Data Visualization:** FL Chart (`fl_chart: ^0.70.2`)
* **Animations:** Flutter Animate (`flutter_animate: ^4.5.2`)
* **Media & Storage:** Image Picker (`image_picker`), SharedPreferences (`shared_preferences`)

---

## 🏗️ Kiến Trúc Mã Nguồn (Clean Architecture)

```text
lib/
├── app/
│   ├── theme/               # Light/Dark Theme System & Color Palette
│   └── constants/           # Constants
├── features/
│   ├── home/                # Home Dashboard & Floating Navigation Bar
│   ├── scanner/             # AI Camera Scanner, Error Debugger & Solution View
│   ├── ai_chat/             # 24/7 AI Tutor Chatbot Interface
│   ├── flashcards/          # Interactive Flashcard Flip Deck & Quizzes
│   ├── analytics/           # fl_chart Study Performance & Mastery Heatmap
│   └── auth/                # Google Sign-in & Profile Account Details
├── shared/                  # Reusable Custom Widgets & Models
└── main.dart                # App Entry Point & ProviderScope
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng (Getting Started)

1. **Clone repository về máy:**
   ```bash
   git clone https://github.com/your-username/omni_solve_ai.git
   cd omni_solve_ai
   ```

2. **Cài đặt các gói phụ thuộc (Dependencies):**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng trên Thiết bị/Giả lập (Emulator or Browser):**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Tác Giả (Author)

* **Phong Lang** - Flutter & Mobile Developer
* **Repository:** OmniSolve AI - STEM Homework & AI Study Ecosystem
