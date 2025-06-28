# 🚀 TaskNotate

<p align="center">
  <img src="https://github.com/user-attachments/assets/c1ea1b69-76ea-4e86-9a35-c5393a96cd78" alt="TaskNotate Logo" width="150">
</p>

<p align="center"><em>Your ultimate productivity companion with beautiful theme customization and powerful task reminders ⏰📝</em></p>

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-2.x-0175C2?style=for-the-badge&logo=dart)
![GetX](https://img.shields.io/badge/GetX-State%20Management-orange?style=for-the-badge)
![SQLite](https://img.shields.io/badge/SQLite-Embedded%20DB-003B57?style=for-the-badge&logo=sqlite)
![Local Notifications](https://img.shields.io/badge/Local%20Notifications-Flutter%20Local%20Notifications-blueviolet?style=for-the-badge&logo=bell)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-green?style=for-the-badge)
![Kotlin](https://img.shields.io/badge/Kotlin-Android%20Native-7F52FF?style=for-the-badge&logo=kotlin)

</div>

---

## 🎨 Theme Showcase

### 🌈 Default Theme
<p align="center">
  <img src="https://github.com/user-attachments/assets/2c93d080-c4d7-4c56-9634-e00ca499894f" width="200">
  <img src="https://github.com/user-attachments/assets/bf83d76b-938c-4f65-9143-7d7159069337" width="200">
  <img src="https://github.com/user-attachments/assets/aa6804c6-f52f-4f94-9671-1ec1395f2195" width="200">
  <img src="https://github.com/user-attachments/assets/424a0979-e330-4cae-b7ea-f02fdc9459c3" width="200">
</p>

### 📱 Additional Screens
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

## ✨ Features

### ✅ Task Management
- 📝 Create, edit, and delete tasks with ease
- 🗂 Sort by due date, priority, or title
- 📆 Timeline View & Calendar Integration

### 🔔 Local Notifications
- Uses `flutter_local_notifications`
- ⏰ Schedule alarms that trigger at exact time
- 🔒 Works in background & locked screen
- 💤 Persistent alarm screen until dismissed

### 🎨 Themes & UI
- 🎨 20+ Color Themes (switch anytime)
- 🌙 System-based Light/Dark mode
- 🌐 Supports English, العربية, Español, Deutsch, 中文

### 🖌️ Notes & Drawing
- ✍️ Handwritten notes via canvas
- 📁 Auto-save notes locally
- 🧼 Clean, minimal layout

---

## 🧱 Tech Stack

| 🔧 Component        | 🚀 Technology                   |
|---------------------|-------------------------------|
| Framework           | Flutter 3.x                   |
| Architecture        | Clean + MVC                   |
| State Management    | GetX                          |
| Local DB            | SQLite                        |
| Alarm Scheduling    | `package:alarm` + LocalNotif  |
| Platform Integration| Kotlin                        |
| Drawing Engine      | Flutter CustomPaint           |

---

## 🔔 Alarm System Overview

TaskNotate integrates precise local alarms with custom native Android UI for a seamless reminder experience.

```mermaid
graph TD
    A[Alarm Plugin] --> B[Kotlin Handler]
    B --> C[MethodChannel]
    C --> D[Flutter AlarmService]
    D --> E[Alarm State Controller]
    E --> F[Alarm UI Screen]
```

### 📌 Features
- 🔓 Wake device + show over lockscreen
- 🔄 Reliable after reboots
- 🔕 Manual and auto-dismiss
- 📡 Built with `flutter_local_notifications`

---

## 🧩 Sample Code

### 📱 Native Android (Kotlin)

```kotlin
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
```

### 🔁 Flutter Integration

```dart
void _handleAlarmTrigger(AlarmSettings settings) async {
  await AlarmDisplayStateService.to.setAlarmScreenActive(true);
  Get.offAllNamed(AppRoute.alarmScreen, arguments: {
    'id': settings.id,
    'title': 'Task Reminder'
  });
}
```

```dart
await Alarm.stop(alarmId);
await AlarmDisplayStateService.to.setAlarmScreenActive(false);
```

---

## 🧪 Try It Out

```bash
# 1. Clone the repo
git clone https://github.com/MegoABKM/TaskNotate.git

# 2. Navigate into it
cd TaskNotate

# 3. Install dependencies & run
flutter pub get
flutter run
```

---

## ❤️ Support & License

<div align="center">
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge">
</div>

> Built with love using Flutter 💙  
> Contributions are welcome!

