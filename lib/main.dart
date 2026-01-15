import 'package:bagaer/app.dart';
import 'package:bagaer/core/di/injection_container.dart' as di;
import 'package:bagaer/feature/notifications/presentation/services/background_handler.dart';
import 'package:bagaer/feature/notifications/presentation/services/local_notification_service.dart';
import 'package:bagaer/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:bagaer/feature/notifications/presentation/bloc/notification_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart' as rive;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('[main] app startup - ${DateTime.now().toIso8601String()}');

  // Inicializa o Firebase
  print('[main] initializing Firebase...');
  await Firebase.initializeApp();
  print('[main] Firebase initialized');

  // Inicializa o Rive
  print('[main] initializing Rive...');
  await rive.RiveNative.init();
  print('[main] Rive initialized');

  // Inicializa o Service Locator / Injeção de Dependências
  print('[main] initializing DI (injection_container)...');
  await di.init();
  print('[main] DI initialized');

  // Registra o handler de background (deve ser top-level e anotado com @pragma)
  // Registre antes do runApp e preferencialmente logo após o setupLocator.
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  print('[main] registered background handler');

  // WARM-UP: aguarda a criação assíncrona do LocalNotificationService
  try {
    print('[main] warming up LocalNotificationService...');
    final localService = await di.sl.getAsync<LocalNotificationService>();
    print('[main] LocalNotificationService ready');
    await localService.createNotificationChannel(); 
    print('[main] LocalNotificationService ready and channel created');
    // await di.sl.getAsync<NotificationBloc>();
    // print('[main] NotificationBloc ready');
  } catch (e, st) {
    print('[main] LocalNotificationService warm-up failed: $e');
    print(st);
  }

  // Inicializa o NotificationBloc (obter instância assíncrona e disparar evento)
  // NOTE: não disparar automaticamente a solicitação de permissão ao iniciar o app.
  // Se quiser inicializar notificações mais tarde (por exemplo ao entrar em uma tela de configurações),
  // obtenha o bloc via GetIt/BlocProvider e dispare InitializeNotificationsEvent ou RequestPermissionEvent.
  try {
    print('[main] obtaining NotificationBloc and dispatching InitializeNotificationsEvent...');
    final bloc = await di.sl.getAsync<NotificationBloc>();
    bloc.add(InitializeNotificationsEvent());
    print('[main] InitializeNotificationsEvent dispatched');
  } catch (e, st) {
    print('[main] NotificationBloc initialization failed: $e');
    print(st);
  }

  print('[main] running app');
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const App()
    )
  );
}
