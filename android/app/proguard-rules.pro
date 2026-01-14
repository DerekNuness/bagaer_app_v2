# =======================================================
# REGRAS DE PRESERVAÇÃO PARA FLUTTER, FIREBASE E PIGEON
# Salve em: android/app/proguard-rules.pro
# =======================================================

# -------------------- 1. FLUTTER CORE & METHOD CHANNELS --------------------
# Regras essenciais para o funcionamento dos Method Channels e do motor Flutter
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Preservar todas as implementações de FlutterPlugin e ActivityAware
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.embedding.engine.plugins.activity.ActivityAware { *; }
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }


# -------------------- 2. FIREBASE & PIGEON (SOLUÇÃO PARA O SEU ERRO) --------------------
# A regra mais CRÍTICA: Preservar o código gerado pelo PIGEON, usado pelo firebase_core.
# Isso deve resolver diretamente o erro "dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi"
-keep class dev.flutter.pigeon.** { *; }
-keep class * implements dev.flutter.pigeon.FirebaseCoreHostApi { *; }
-keep class * implements dev.flutter.pigeon.FirebaseCoreHostApi$Result { *; }

# Preservar todo o código base do Google Services, Firebase e GMS
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**

# Firebase Messaging (FCM)
-keep class com.google.firebase.iid.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# Firebase Analytics
-keep class com.google.android.gms.measurement.** { *; }
-dontwarn com.google.android.gms.measurement.**


# -------------------- 3. OUTRAS DEPENDÊNCIAS COMUNS --------------------
# flutter_local_notifications (Preserva classes necessárias para notificações de fundo)
-keep class com.dexterous.flutterlocalnotifications.receivers.** { *; }
-keep class com.dexterous.flutterlocalnotifications.NotificationResponse { *; }

# MAPBOX (Se estiver usando)
-keep class com.mapbox.** { *; }
-dontwarn com.mapbox.**

# Kotlin Reflection/Metadata (Para garantir que classes Kotlin não sejam danificadas)
-keep class kotlin.Metadata { *; }

# -------------------- 4. GOOGLE PLAY CORE & SPLIT INSTALL (NOVO ERRO) --------------------
# Regras essenciais para as bibliotecas Google Play Core.
# Isso resolve o erro "Missing class com.google.android.play.core..."
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

#ffmpeg_kit
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class org.ffmpeg.** { *; }
-dontwarn com.arthenica.ffmpegkit.**
-dontwarn org.ffmpeg.**
-keep class com.antonkarpenko.ffmpegkit.** { *; }