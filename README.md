TaskNotate 📋✨
<p align="center">
<img src="https://github.com/user-attachments/assets/c1ea1b69-76ea-4e86-9a35-c5393a96cd78" alt="TaskNotate Logo" width="150">
</p>
<p align="center">
<em>Your ultimate productivity companion with beautiful theme customization</em>
</p>
<div align="center">
![alt text](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)

![alt text](https://img.shields.io/badge/Dart-2.x-0175C2?style=for-the-badge&logo=dart)

![alt text](https://img.shields.io/badge/GetX-State%20Management-orange?style=for-the-badge)

![alt text](https://img.shields.io/badge/SQLite-3.x-003B57?style=for-the-badge&logo=sqlite&logoColor=white)

![alt text](https://img.shields.io/badge/Architecture-MVC-brightgreen?style=for-the-badge)

![alt text](https://img.shields.io/badge/Kotlin-Android%20Native-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white)

![alt text](https://img.shields.io/badge/Notifications-Firebase%20Cloud%20Messaging-FFCA28?style=for-the-badge&logo=firebase)

![alt text](https://img.shields.io/badge/Clean%20Architecture-Layers-6DB33F?style=for-the-badge)

![alt text](https://img.shields.io/badge/Clean%20Code-Principles-5C9EAD?style=for-the-badge)
</div>
🎨 Theme Showcase
Default Theme
<p align="center">
<img src="https://github.com/user-attachments/assets/2c93d080-c4d7-4c56-9634-e00ca499894f" alt="Default Home" width="200">
<img src="https://github.com/user-attachments/assets/bf83d76b-938c-4f65-9143-7d7159069337" alt="Default Category" width="200">
<img src="https://github.com/user-attachments/assets/aa6804c6-f52f-4f94-9671-1ec1395f2195" alt="Default Notes" width="200">
<img src="https://github.com/user-attachments/assets/424a0979-e330-4cae-b7ea-f02fdc9459c3" alt="Screenshot 1" width="200">
</p>
Additional Screenshots
<p align="center">
<img src="https://github.com/user-attachments/assets/fcf52824-5c8a-44a8-aa89-e18965c942b8" alt="Screenshot 2" width="200">
<img src="https://github.com/user-attachments/assets/308f7161-9d8f-44d8-9043-f1041d4a7b4c" alt="Screenshot 3" width="200">
<img src="https://github.com/user-attachments/assets/d9b499b4-6892-42c4-beb1-4744cd569459" alt="Screenshot 4" width="200">
<img src="https://github.com/user-attachments/assets/12cd8a00-601a-4d55-a7a8-0fe83dd9e052" alt="Screenshot 5" width="200">
<img src="https://github.com/user-attachments/assets/63be5816-b264-44ff-83ac-93909f3e8612" alt="Screenshot 6" width="200">
<img src="https://github.com/user-attachments/assets/9d8381e8-c85c-4cd2-b1d7-e1c9f636f5a1" alt="Screenshot 7" width="200">
<img src="https://github.com/user-attachments/assets/8ffe1e63-6ad0-4d41-bb0c-2bdbd34a483c" alt="Default Settings" width="200">
<img src="https://github.com/user-attachments/assets/cebc6f2b-7c7d-4b7c-a221-6efa81d24d90" alt="Screenshot 8" width="200">
</p>
✨ Core Features
🎯 General Features
🌈 20+ Color Themes: Switch between beautiful presets with one tap
☀️ Dark/Light Mode: Automatic system adaptation or manual selection
⚡ Simple & fast task management with built-in notes ✏️
🌍 Multi-Language: English, العربية, Español, Deutsch, 中文
✅ Advanced Task Management
🔔 Reminders & Deadlines: Set start/finish dates and get notifications
🧩 Nested Subtasks: Break tasks into smaller steps
🔄 Smart Sorting: Organize by date, priority, creation time, or status
📅 Timeline View: See your tasks in chronological order
📝 Elegant Note-Taking
🎨 Canvas Drawing: Sketch ideas with easy undo/redo
💾 Auto-saving: Never lose your work
✨ Minimal Interface: Focus on your content without distractions
🛠️ Technology Stack
Component	Technology
Framework	Flutter 3.x
Architecture	MVC with Clean Architecture
State Management	GetX
Local Database	SQLite
Notifications	Firebase Cloud Messaging
Native Features	Kotlin for Android integration
Drawing	Custom Canvas
Code Quality	Clean Code Principles
🚨 How the Alarm System Works
The alarm functionality in TaskNotate is a core feature designed to be highly reliable. To achieve this, it uses a hybrid approach, combining the power of native Android (Kotlin) with the flexibility of Flutter (Dart). This ensures that alarms can wake the device and display over the lock screen, a capability that requires native platform integration.
Here's a step-by-step breakdown of the architecture:
The Goal: A Reliable, Lock-Screen-Waking Alarm
When an alarm triggers, the app must:
Wake the device's screen if it's off.
Display the alarm UI even if the phone is locked.
Work reliably whether the app is in the foreground, background, or has been killed by the system.
The Hybrid Architecture
The system is split into two main parts that communicate via a MethodChannel.
Native Side (Android/Kotlin): MainActivity.kt handles direct interactions with the Android OS.
Flutter Side (Dart): A set of services (AppBootstrapService, AlarmService, AlarmDisplayStateService) manages the app's state and UI.
<p align="center">
<img src="https://user-images.githubusercontent.com/33890333/276993118-2f9547ea-561b-4357-94d3-0d3f27618210.png" alt="Alarm Flow Diagram" width="800">
</p>
The Flow: From Trigger to Display
The system handles two primary scenarios:
Scenario 1: App is Killed or in Background (Cold Start)
This is the most critical path, where the app is launched from scratch by the alarm.
Android Alarm Trigger: The Android AlarmManager fires a PendingIntent at the scheduled time. This intent is configured to launch our MainActivity.kt with a special action: com.megoabkm.tasknotate.ALARM_TRIGGER.
Native Wake-Up (MainActivity.kt):
MainActivity's onCreate method detects this special intent.
It immediately calls applyLockScreenFlags(), which uses Android's WindowManager to turn the screen on and show the activity over the lock screen.
Generated kotlin
// in MainActivity.kt
override fun onCreate(savedInstanceState: Bundle?) {
    // Apply flags BEFORE super.onCreate() to ensure they take effect immediately
    if (intent?.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
        applyLockScreenFlags()
    }
    super.onCreate(savedInstanceState)
    handleIntent(intent)
}

private fun applyLockScreenFlags() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
        setShowWhenLocked(true) // Show above the lock screen
        setTurnScreenOn(true)   // Wake the screen up
    } else {
        // Legacy flags for older Android versions
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
        )
    }
}
Use code with caution.
Kotlin
Data Transfer (MainActivity.kt -> AppBootstrapService.dart):
The handleIntent method in Kotlin extracts the alarmId and title from the intent and stores them.
When the Flutter engine starts, our AppBootstrapService runs. Its first job is to check for an alarm.
It calls a method on the MethodChannel to get the initial launch data from the native side.
Generated dart
// in AppBootstrapService.dart
static Future<Map<String, dynamic>?> _getInitialAlarmDataFromNative() async {
  try {
    // This invokes the 'getInitialIntent' method in MainActivity.kt
    final intentData = await _platform
        .invokeMethod<Map<dynamic, dynamic>>('getInitialIntent');
    if (intentData != null &&
        intentData['action'] == 'com.megoabkm.tasknotate.ALARM_TRIGGER') {
      return {'id': intentData['alarmId'], 'title': intentData['title']};
    }
  } catch (e) { /* ... */ }
  return null;
}
Use code with caution.
Dart
Initial Routing (AppBootstrapService.dart):
If _getInitialAlarmDataFromNative returns alarm data, the determineInitialRoute function immediately returns AppRoute.alarmScreen.
It also persists the alarm state in SharedPreferences using AlarmDisplayStateService. This ensures state consistency if the app is restarted.
Scenario 2: App is Already Running (Hot Start)
If the app is open when an alarm goes off, the flow is simpler and handled entirely within Dart.
Alarm Stream (AlarmService.dart):
The AlarmService listens to a stream from the package:alarm (Alarm.ringStream).
When an alarm rings, the _handleAlarmTrigger method is called.
State Update and Navigation (AlarmService.dart):
The service sets a global flag via AlarmDisplayStateService.to.setAlarmScreenActive(true).
It then uses Get.offAllNamed(AppRoute.alarmScreen) to immediately navigate the user to the alarm screen, passing the alarm's ID and title as arguments.
Generated dart
// in AlarmService.dart
void _handleAlarmTrigger(AlarmSettings alarmSettings) async {
    // ... get task title from SharedPreferences ...
    await AlarmDisplayStateService.to.setAlarmScreenActive(true);

    if (Get.currentRoute != AppRoute.alarmScreen) {
        await Get.offAllNamed(
          AppRoute.alarmScreen,
          arguments: {'id': alarmSettings.id, 'title': taskTitle},
        );
    }
}
Use code with caution.
Dart
Stopping the Alarm
Stopping the alarm is the reverse process of starting it.
Flutter UI Call: The user presses a "Stop" button on the AlarmScreen.
State Update (Dart):
AlarmDisplayStateService.to.setAlarmScreenActive(false) is called to update the global state and SharedPreferences.
The Alarm.stop() method from the package is called.
Native Flag Clearing (Dart -> Kotlin):
A method call is made over the MethodChannel to stopAlarm on the native side.
MainActivity.kt receives this call and executes clearLockScreenFlags(), which removes the special window flags. This allows the screen to turn off normally and brings back the standard lock screen.
Generated kotlin
// in MainActivity.kt - a method on the channel
methodChannel?.setMethodCallHandler { call, result ->
    when (call.method) {
        "stopAlarm" -> {
            Log.d("MainActivity", "MethodChannel: stopAlarm called by Flutter...")
            clearLockScreenFlags() // CRITICAL: Release the screen wake lock
            result.success(null)
        }
        // ... other methods
    }
}
Use code with caution.
Kotlin
This robust, multi-layered approach ensures that TaskNotate's alarms are both powerful and reliable, providing a seamless user experience.
🚀 Get Started in 3 Steps
Generated bash
# 1️⃣ Clone the repository
git clone https://github.com/MegoABKM/TaskNotate.git

# 2️⃣ Navigate to project
cd TaskNotate

# 3️⃣ Run the app
flutter pub get && flutter run
Use code with caution.
Bash
<div align="center"> <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome"> <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"> </div>
