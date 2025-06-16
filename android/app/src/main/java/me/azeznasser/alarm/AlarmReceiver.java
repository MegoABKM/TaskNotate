// package me.azeznasser.alarm;

// import android.content.BroadcastReceiver;
// import android.content.Context;
// import android.content.Intent;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.embedding.engine.dart.DartExecutor;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.view.FlutterMain;

// public class AlarmReceiver extends BroadcastReceiver {
//     @Override
//     public void onReceive(Context context, Intent intent) {
//         String action = intent.getAction();
//         if ("android.intent.action.BOOT_COMPLETED".equals(action) || 
//             "android.intent.action.LOCKED_BOOT_COMPLETED".equals(action)) {
//             // Reschedule alarms (call Flutter method to reschedule)
//             FlutterMain.startInitialization(context);
//             FlutterEngine flutterEngine = new FlutterEngine(context);
//             DartExecutor dartExecutor = flutterEngine.getDartExecutor();
//             MethodChannel channel = new MethodChannel(dartExecutor, "com.example.tasknotate/alarm");
//             channel.invokeMethod("rescheduleAlarms", null);
//         } else if ("com.example.tasknotate.ALARM_ACTION".equals(action)) {
//             // Launch AlarmActivity
//             Intent alarmIntent = new Intent(context, AlarmActivity.class);
//             alarmIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
//             context.startActivity(alarmIntent);
//         }
//     }
// }