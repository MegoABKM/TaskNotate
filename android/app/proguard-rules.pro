## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

## Play Store SplitCompat
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

## Get
-keep class com.github.alexjlockwood.kyrie.** { *; }
-dontwarn com.github.alexjlockwood.kyrie.**

## Supabase
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

## Audioplayers
-keep class com.lucierking.audioplayers.** { *; }
-dontwarn com.lucierking.audioplayers.**

## Image Picker
-keep class com.imagepicker.** { *; }
-dontwarn com.imagepicker.**

## Lottie
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

## Alarm
-keep class com.better.alarm.** { *; }
-dontwarn com.better.alarm.**

## Signature
-keep class com.github.gcacace.signaturepad.** { *; }
-dontwarn com.github.gcacace.signaturepad.**

## Shared Preferences
-keep class androidx.preference.** { *; }
-dontwarn androidx.preference.**

## Connectivity Plus
-keep class com.connectivity_plus.** { *; }
-dontwarn com.connectivity_plus.**

## Package Info Plus
-keep class com.package_info_plus.** { *; }
-dontwarn com.package_info_plus.**

## Font Awesome Flutter
-keep class com.fontawesome.** { *; }
-dontwarn com.fontawesome.**

## Timeline Tile
-keep class com.github.vipulasri.timelineview.** { *; }
-dontwarn com.github.vipulasri.timelineview.**

## SQLite
-keep class com.sqlite.** { *; }
-dontwarn com.sqlite.**

## General AndroidX
-keep class androidx.** { *; }
-dontwarn androidx.**