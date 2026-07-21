# WorkManager / Room
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.InputMerger
-keepclassmembers class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context,androidx.work.WorkerParameters);
}
-keep class * extends androidx.room.RoomDatabase {
    <init>(...);
}

# Flutter Workmanager plugin (callbackDispatcher se invoca por reflexión)
-keep class dev.fluttercommunity.workmanager.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# Google Sign-In / Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
