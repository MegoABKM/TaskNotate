// package me.azeznasser.alarm;

// import android.content.Intent;
// import android.os.Bundle;
// import android.view.WindowManager;
// import androidx.appcompat.app.AppCompatActivity;
// import com.example.tasknotate.MainActivity;

// public class AlarmActivity extends AppCompatActivity {
//     @Override
//     protected void onCreate(Bundle savedInstanceState) {
//         super.onCreate(savedInstanceState);
//         // Turn on the screen and show when locked
//         getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
//                              WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON |
//                              WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

//         // Launch Flutter AlarmScreen
//         Intent intent = new Intent(this, MainActivity.class);
//         intent.putExtra("route", "/alarm_screen");
//         startActivity(intent);
//         finish();
//     }
// }