<div align="center">

# 📚 Study Buddy

### Your All-in-One Academic Companion

*A beautifully crafted Flutter application designed to help students organize their academic life — track study sessions, manage documents, stay on top of assignments, and more.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## ✨ Features

### 🎯 Study Tracker
- **Stopwatch & Timer modes** — use a free-running stopwatch or set a custom countdown timer (e.g., Pomodoro-style 25 min sessions)
- **Per-subject tracking** — add, select, and manage subjects; all sessions are logged per subject
- **Focus statistics** — view total study time filtered by Today, Yesterday, Last 7 Days, Last 30 Days, or Overall
- **Haptic feedback** on timer completion

### ✅ Attendance Portal
- **Quick-access link** to your institution's attendance portal — opens directly in the browser
- **Editable URL** — set and update the attendance link anytime

### 🗓️ Timetable
- **Upload your timetable** as an image directly from your gallery
- **Pinch-to-zoom** viewing powered by `photo_view` for a detailed look at your schedule
- **Replace anytime** with a single tap

### 📁 Documents
- **Photo-based document storage** — capture and store notes, receipts, ID cards, and more
- **Grid view** with image thumbnails for easy browsing
- **Full-screen viewer** for detailed inspection
- **Rename & delete** documents with long-press options

### 📚 Study Materials (Link Manager)
- **Bookmark important links** — save URLs for lecture notes, online resources, and reference material
- **Tap to open** any link directly in the browser
- **Rename & delete** saved links with long-press options

### 📝 Assignment Reminders
- **Create reminders** with a title and due date
- **Date picker** for easy due-date selection
- **Auto-sorted** by date so upcoming deadlines appear first
- **Swipe to delete** completed reminders

### 💡 Motivation Bar
- A curated collection of **inspirational quotes** to keep you going when the grind gets tough!

### 👤 Account Management
- **Profile picture** — upload and change your profile photo from the gallery
- **Edit username & password** — update credentials with built-in validation
- **Logout** functionality

### ⚙️ Settings
- **Dark / Light mode** toggle — theme persists across sessions
- **Custom app display name** — personalize the app title shown in the header

---

## 📸 Screenshots

> *Coming soon — screenshots of the app in both light and dark themes!*

<!-- 
Uncomment and add your screenshots:
<div align="center">
  <img src="screenshots/home.png" width="250" alt="Home Screen" />
  <img src="screenshots/tracker.png" width="250" alt="Study Tracker" />
  <img src="screenshots/documents.png" width="250" alt="Documents" />
</div>
-->

---

## 🏗️ Architecture

The project follows a **clean, provider-based architecture** for state management:

```
lib/
├── main.dart                  # App entry point with MultiProvider setup
├── assets/                    # Fonts, images & static resources
├── models/
│   └── study_session.dart     # Study session data model
├── providers/
│   ├── auth_provider.dart     # Authentication & credentials management
│   ├── image_storage_provider.dart  # Image, document, link & timetable storage
│   ├── study_provider.dart    # Study sessions & subject management
│   └── theme_provider.dart    # Dark/Light theme management
├── screens/
│   ├── splash_screen.dart     # Animated splash screen
│   ├── home_screen.dart       # Main scaffold with bottom navigation
│   ├── image_confirm_screen.dart  # Safe image confirmation screen
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main/                  # Bottom navigation tabs
│   │   ├── attendance_screen.dart
│   │   ├── timetable_screen.dart
│   │   ├── study_tracker_screen.dart
│   │   ├── documents_screen.dart
│   │   └── study_materials_screen.dart
│   └── drawer/                # Navigation drawer screens
│       ├── account_screen.dart
│       ├── assignment_reminders_screen.dart
│       ├── motivation_screen.dart
│       └── settings_screen.dart
├── utils/
│   └── themes.dart            # App theme definitions
└── widgets/
    ├── app_drawer.dart        # Navigation drawer widget
    └── document_viewer_screen.dart
```

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.8+ |
| **State Management** | Provider |
| **Local Storage** | SharedPreferences |
| **Typography** | Google Fonts, Segoe Print, Arial Rounded |
| **Image Handling** | image_picker, photo_view, path_provider |
| **External Links** | url_launcher |
| **Date Formatting** | intl |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- Android Studio / VS Code with Flutter extension
- An Android or iOS device/emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/study_buddy.git
   cd study_buddy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build for release** *(optional)*
   ```bash
   flutter build apk --release        # Android
   flutter build ios --release         # iOS
   ```

---

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ and Flutter**

*If you found this project helpful, consider giving it a ⭐!*

</div>
