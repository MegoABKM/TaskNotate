# TaskNotate 📋✨

<p align="center">
  <img src="https://github.com/user-attachments/assets/c1ea1b69-76ea-4e86-9a35-c5393a96cd78" alt="TaskNotate Logo" width="150">
</p>

<p align="center">
  <em>Your ultimate productivity companion with beautiful theme customization</em>
</p>

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-2.x-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-orange?style=for-the-badge)](https://pub.dev/packages/get)
[![SQLite](https://img.shields.io/badge/SQLite-3.x-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org/index.html)
[![MVC](https://img.shields.io/badge/Architecture-MVC-brightgreen?style=for-the-badge)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android%20Native-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white)](https://kotlinlang.org)
[![Notifications](https://img.shields.io/badge/Notifications-Firebase%20Cloud%20Messaging-FFCA28?style=for-the-badge&logo=firebase)](https://firebase.google.com/docs/cloud-messaging)
[![Clean Architecture](https://img.shields.io/badge/Clean%20Architecture-Layers-6DB33F?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![Clean Code](https://img.shields.io/badge/Clean%20Code-Principles-5C9EAD?style=for-the-badge)](https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29)

</div>

---

## 🎨 Theme Showcase

### Default Theme
<p align="center">
  <img src="https://github.com/user-attachments/assets/2c93d080-c4d7-4c56-9634-e00ca499894f" width="200">
  <img src="https://github.com/user-attachments/assets/bf83d76b-938c-4f65-9143-7d7159069337" width="200">
  <img src="https://github.com/user-attachments/assets/aa6804c6-f52f-4f94-9671-1ec1395f2195" width="200">
  <img src="https://github.com/user-attachments/assets/424a0979-e330-4cae-b7ea-f02fdc9459c3" width="200">
</p>

### Additional Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/fcf52824-5c8a-44a8-aa89-e18965c942b8" width="200">
  <img src="https://github.com/user-attachments/assets/308f7161-9d8f-44d8-9043-f1041d4a7b4c" width="200">
  <img src="https://github.com/user-attachments/assets/d9b499b4-6892-42c4-beb1-4744cd569459" width="200">
  <img src="https://github.com/user-attachments/assets/12cd8a00-601a-4d55-a7a8-0fe83dd9e052" width="200">
  <img src="https://github.com/user-attachments/assets/63be5816-b264-44ff-83ac-93909f3e8612" width="200">
  <img src="https://github.com/user-attachments/assets/9d8381e8-c85c-4cd2-b1d7-e1c9f636f5a1" width="200">
  <img src="https://github.com/user-attachments/assets/8ffe1e63-6ad0-4d41-bb0c-2bdbd34a483c" width="200">
  <img src="https://github.com/user-attachments/assets/cebc6f2b-7c7d-4b7c-a221-6efa81d24d90" width="200">
</p>

---

## ✨ Core Features

### 🎯 General Features
- 🌈 **20+ Color Themes** with one-tap switching
- ☀️ **Dark/Light Mode** based on system or manual toggle
- ⚡ **Simple & Fast Task Management**
- 🌍 **Multi-language**: English, العربية, Español, Deutsch, 中文

### ✅ Advanced Task Management
- 🔔 **Reminders & Deadlines** with notifications
- 🧩 **Nested Subtasks**
- 🔄 **Smart Sorting** (date, priority, etc.)
- 📅 **Timeline View**

### 📝 Elegant Note-Taking
- 🎨 **Canvas Drawing**
- 💾 **Auto-saving**
- ✨ **Minimal Interface**

---

## 🛠️ Technology Stack

| Component        | Technology                    |
|------------------|-------------------------------|
| Framework        | Flutter 3.x                   |
| Architecture     | MVC + Clean Architecture      |
| State Management | GetX                          |
| Local Database   | SQLite                        |
| Notifications    | Firebase Cloud Messaging      |
| Native Features  | Kotlin for Android            |
| Drawing          | Custom Canvas                 |
| Code Quality     | Clean Code Principles         |
| Alarm System     | `package:alarm` 4.1.1         |

---

## 🚨 Alarm System Implementation

<details>
<summary><b>Click to expand: Alarm System Architecture and Flow</b></summary>

### 🔧 Technical Overview

TaskNotate’s alarm system leverages `package:alarm 4.1.1` combined with native Android integration for reliable alarm functionality.

```mermaid
graph TD
    A[package:alarm] --> B[Kotlin MainActivity]
    B --> C[MethodChannel]
    C --> D[Flutter AlarmService]
    D --> E[AlarmDisplayState]
    E --> F[AlarmScreen UI]
✅ Key Requirements
Wake device screen when alarm triggers

Display over lock screen

Work in all app states (foreground/background/terminated)

Survive device reboots

🔄 Workflow Breakdown
1️⃣ Native Layer (Kotlin)
kotlin
Copy
Edit
override fun onCreate(savedInstanceState: Bundle?) {
    if (intent?.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
            )
        }
    }
    super.onCreate(savedInstanceState)
}
2️⃣ Flutter-Dart Layer
dart
Copy
Edit
void _handleAlarmTrigger(AlarmSettings settings) async {
  await AlarmDisplayStateService.to.setAlarmScreenActive(true);
  Get.offAllNamed(AppRoute.alarmScreen, arguments: {
    'id': settings.id,
    'title': 'Task Reminder'
  });
}
🛑 Stopping Alarms
dart
Copy
Edit
await Alarm.stop(alarmId);
await AlarmDisplayStateService.to.setAlarmScreenActive(false);
🔒 State Persistence
Uses SharedPreferences to store alarm state

Ensures consistency across app restarts

</details>
🚀 Get Started in 3 Steps
bash
Copy
Edit
# 1️⃣ Clone the repository
git clone https://github.com/MegoABKM/TaskNotate.git

# 2️⃣ Navigate to project
cd TaskNotate

# 3️⃣ Run the app
flutter pub get && flutter run
<div align="center"> <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge"> <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge"> </div> ```
