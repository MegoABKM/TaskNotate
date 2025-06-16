package com.megoabkm.tasknotate // Replace with your actual package name

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL_NAME = "com.megoabkm.tasknotate/alarm"
    private var methodChannel: MethodChannel? = null
    private var initialIntentData: Map<String, Any?>? = null

    private fun applyLockScreenFlags() {
        Log.d("MainActivity", "Applying lock screen flags (showWhenLocked, turnScreenOn)")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            // Optional: Dismiss keyguard. Test this behavior carefully.
            // The alarm package's fullScreenIntent should ideally handle this.
            // val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            // if (keyguardManager.isKeyguardSecure && keyguardManager.isKeyguardLocked) {
            //    keyguardManager.requestDismissKeyguard(this, null)
            // }
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED //or
                       // WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD // Use with caution
            )
        }
    }

    private fun clearLockScreenFlags() {
        Log.d("MainActivity", "Clearing lock screen flags (showWhenLocked, turnScreenOn)")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            window.clearFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED //or
                        // WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Apply/Clear window flags BEFORE super.onCreate()
        if (intent?.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
            Log.d("MainActivity", "onCreate: ALARM_TRIGGER intent found. Applying lock screen flags.")
            applyLockScreenFlags()
        } else {
            Log.d("MainActivity", "onCreate: Normal launch or non-alarm intent. Clearing lock screen flags.")
            clearLockScreenFlags() // Ensure flags are cleared on normal startup
        }

        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "onCreate complete. Intent action: ${intent?.action}")
        handleIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("MainActivity", "configureFlutterEngine called.")

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialIntent" -> {
                    Log.d("MainActivity", "MethodChannel: getInitialIntent called by Flutter. Data: $initialIntentData")
                    result.success(initialIntentData)
                    // initialIntentData = null // Optional: clear after sending
                }
                "stopAlarm" -> {
                    val alarmId = call.argument<Int>("alarmId")
                    Log.d("MainActivity", "MethodChannel: stopAlarm called by Flutter for ID $alarmId. Clearing lock screen flags.")
                    clearLockScreenFlags() // IMPORTANT: Clear flags when alarm is stopped
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("MainActivity", "onNewIntent called. New Intent action: ${intent.action}")
        super.onNewIntent(intent)
        setIntent(intent) // Update the activity's intent to be the new one

        if (intent.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
            Log.d("MainActivity", "onNewIntent: ALARM_TRIGGER intent. Applying lock screen flags.")
            applyLockScreenFlags()
        } else {
            // If the activity is brought to front for a non-alarm reason
            Log.d("MainActivity", "onNewIntent: Non-ALARM_TRIGGER intent. Clearing lock screen flags.")
            clearLockScreenFlags()
        }
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent?.action == "com.megoabkm.tasknotate.ALARM_TRIGGER") {
            val alarmId = intent.getIntExtra("alarmId", -1)
            val title = intent.getStringExtra("title")
            Log.d("MainActivity", "handleIntent: ALARM_TRIGGER received. ID: $alarmId, Title: $title")

            if (alarmId != -1 && title != null) {
                initialIntentData = mapOf(
                    "action" to "com.megoabkm.tasknotate.ALARM_TRIGGER",
                    "alarmId" to alarmId,
                    "title" to title
                )
                // The AppBootstrapService will use this data for initial routing
            } else {
                Log.w("MainActivity", "handleIntent: ALARM_TRIGGER missing alarmId or title.")
                initialIntentData = mapOf("action" to "com.megoabkm.tasknotate.ALARM_TRIGGER", "error" to "Missing data")
            }
        } else if (intent != null) {
            initialIntentData = mapOf("action" to intent.action, "data" to intent.dataString)
            Log.d("MainActivity", "handleIntent: Normal intent. Action: ${intent.action}")
        } else {
            initialIntentData = null
        }
    }

    override fun onDestroy() {
        Log.d("MainActivity", "onDestroy called.")
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        super.onDestroy()
    }
}