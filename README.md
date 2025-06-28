TaskNotate 📋✨

  



  Your ultimate productivity companion with beautiful theme customization







🎨 Theme Showcase
Default Theme

  
  
  
  


Additional Screenshots

  
  
  
  
  
  
  
  



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



Component
Technology



Framework
Flutter 3.x


Architecture
MVC with Clean Architecture


State Management
GetX


Local Database
SQLite


Notifications
Firebase Cloud Messaging


Native Features
Kotlin for Android integration


Drawing
Custom Canvas


Code Quality
Clean Code Principles



🚀 Get Started in 3 Steps
# 1️⃣ Clone the repository
git clone https://github.com/MegoABKM/TaskNotate.git

# 2️⃣ Navigate to project
cd TaskNotate

# 3️⃣ Run the app
flutter pub get && flutter run


  
  



🚨 How the Alarm System Works

Click to expand: Alarm System Architecture and Flow

TaskNotate's alarm system is designed for reliability, ensuring alarms trigger even when the device is locked or the app is not running. It leverages a hybrid approach, combining native Android (Kotlin) for system-level control and Flutter (Dart) for state management and UI. The system uses the alarm package (package:alarm) to schedule and trigger alarms, ensuring a seamless user experience.
🎯 The Goal
The alarm system must:

Wake the device’s screen if it’s off.
Display the alarm UI over the lock screen.
Work reliably whether the app is in the foreground, background, or terminated.

🛠️ Hybrid Architecture
The system is split into two components communicating via a MethodChannel:

Native Android (Kotlin): MainActivity.kt handles Android system interactions, such as waking the device and managing lock screen flags.
Flutter (Dart): Services (AppBootstrapService, AlarmService, AlarmDisplayStateService) manage app state, navigation, and UI rendering.


  


🔄 The Flow: From Trigger to Display
Scenario 1: App is Terminated or in Background (Cold Start)
This is the critical path where the app launches from scratch due to an alarm.

Alarm Trigger:

The alarm package schedules alarms and fires a PendingIntent with the action com.megoabkm.tasknotate.ALARM_TRIGGER, targeting MainActivity.kt.
This intent includes alarmId and title as extras.


Native Wake-Up (MainActivity.kt):

In onCreate or onNewIntent, the ALARM_TRIGGER action is detected, and applyLockScreenFlags() is called to:
Turn on the screen (setTurnScreenOn(true)).
Show the activity over the lock screen (setShowWhenLocked(true)).
Keep the screen on temporarily (FLAG_KEEP_SCREEN_ON for older Android versions).



override fun onCreate(savedInstanceState: Bundle?) {
    if (intent?.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
        Log.d("MainActivity", "ALARM_TRIGGER intent found. Applying lock screen flags.")
        applyLockScreenFlags()
    } else {
        clearLockScreenFlags()
    }
    super.onCreate(savedInstanceState)
    handleIntent(intent)
}

private fun applyLockScreenFlags() {
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


Data Transfer to Flutter:

The handleIntent method extracts alarmId and title from the intent and stores them in initialIntentData.
A MethodChannel (com.megoabkm.tasknotate/alarm) exposes this data to Flutter via the getInitialIntent method.

methodChannel?.setMethodCallHandler { call, result ->
    when (call.method) {
        "getInitialIntent" -> {
            Log.d("MainActivity", "getInitialIntent called. Data: $initialIntentData Ascending



Data: $initialIntentData")               result.success(initialIntentData)           }       }   }

4. **Initial Routing (`AppBootstrapService.dart`)**:
- On app startup, `AppBootstrapService.determineInitialRoute` checks for alarm data via `_getInitialAlarmDataFromNative`.
- If alarm data is present, it persists the state in `SharedPreferences` (via `AlarmDisplayStateService`) and navigates to `AppRoute.alarmScreen`.
```dart
static Future<String> determineInitialRoute(SharedPreferences prefs) async {
    final alarmData = await _getInitialAlarmDataFromNative();
    if (alarmData != null) {
        await prefs.setInt('current_alarm_id', alarmData['id']);
        await prefs.setString('alarm_${alarmData['id']}_title', alarmData['title']);
        await AlarmDisplayStateService.to.setAlarmScreenActive(true);
        return AppRoute.alarmScreen;
    }
    // ... other routing logic
}

Scenario 2: App is Running (Hot Start)
When the app is already open, the flow is handled within Flutter.

Alarm Stream (AlarmService.dart):

AlarmService listens to Alarm.ringStream from the alarm package.
When an alarm triggers, _handleAlarmTrigger retrieves the alarmId and title from SharedPreferences.

_alarmSubscription = Alarm.ringStream.stream.listen(_handleAlarmTrigger);

void _handleAlarmTrigger(AlarmSettings alarmSettings) async {
    final prefs = await SharedPreferences.getInstance();
    final taskTitle = prefs.getString('alarm_${alarmSettings.id}_title');
    if (taskTitle != vars) {
        await AlarmDisplayStateService.to.setAlarmScreenActive(true);
        await prefs.setInt('current_alarm_id', alarmSettings.id);
        if (Get.currentRoute != AppRoute.alarmScreen) {
            await Get.offAllNamed(AppRoute.alarmScreen,
                arguments: {'id': alarmSettings.id, 'title': taskTitle});
        }
    }
}


State Management:

AlarmDisplayStateService updates the isAlarmScreenActive flag in both memory (via RxBool) and SharedPreferences for persistence.

class AlarmDisplayStateService extends GetxService {
    final RxBool isAlarmScreenActive = false.obs;
    Future<void> setAlarmScreenActive(bool isActive) async {
        isAlarmScreenActive.value = isActive;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(prefsKeyIsAlarmScreenActive, isActive);
    }
}


Navigation:

If not already on AppRoute.alarmScreen, Get.offAllNamed navigates to the alarm screen, passing alarmId and title as arguments.



Stopping the Alarm

User Interaction:

The user taps "Stop" on the AlarmScreen, triggering a call to Alarm.stop() from the ` increasinglypackage.


State Update:

AlarmDisplayStateService.to.setAlarmScreenActive(false) clears the active alarm flag.
SharedPreferences is updated to remove alarm-related data (current_alarm_id, is_alarm_triggered).


Native Flag Clearing:

The Flutter UI invokes the stopAlarm method via the MethodChannel.
MainActivity.kt clears lock screen flags to restore normal screen behavior.

methodChannel?.setMethodCallHandler { call, result ->
    when (call.method) {
        "stopAlarm" -> {
            Log.d("MainActivity", "stopAlarm called by Flutter.")
            clearLockScreenFlags()
            result.success(null)
        }
    }
}

private fun clearLockScreenFlags() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
        setShowWhenLocked(false)
        setTurnScreenOn(false)
    } else {
        window.clearFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
        )
    }
}



🔒 State Persistence

AlarmDisplayStateService uses SharedPreferences to persist the alarm state (isAlarmScreenActive, current_alarm_id, alarm_<id>_title).
This ensures the alarm screen can be restored on app restart, preventing missed alarms due to process termination.

🛡️ Middleware Protection (Mymiddleware.dart)

The Mymiddleware class checks the app’s state (AppSecurityService.isEnabledKey) before allowing navigation.
If the app is disabled, it redirects to AppRoute.disabled, except for AppRoute.alarmScreen and AppRoute.splashScreen, ensuring alarms remain accessible.

class Mymiddleware extends GetMiddleware {
    @override
    RouteSettings? redirect(String? route) {
        final prefs = Get.find<StorageService>().sharedPreferences;
        final isAppEnabledCached = prefs.getBool(AppSecurityService.isEnabledKey) ?? true;
        if (!isAppEnabledCached && route != AppRoute.disabled && route != AppRoute.splashScreen && route != AppRoute.alarmScreen) {
            return const RouteSettings(name: AppRoute.disabled);
        }
        return null;
    }
}

🌟 Key Features

Reliability: Alarms trigger even if the app is killed, thanks to the alarm package’s integration with native Android scheduling.
Lock Screen Support: The alarm UI appears over the lock screen without requiring user unlock.
State Consistency: SharedPreferences ensures alarm state persists across app restarts.
Seamless Navigation: GetX routing ensures the alarm screen is displayed promptly and consistently.

This hybrid, multi-layered approach ensures TaskNotate’s alarms are robust, user-friendly, and reliable, delivering a seamless experience for task reminders.
