import 'dart:async';

import 'package:bagaer/feature/notifications/data/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagaer/feature/notifications/domain/entities/push_notification.dart';
import 'package:bagaer/feature/notifications/domain/usecases/get_device_token.dart';
import 'package:bagaer/feature/notifications/domain/usecases/initialize_notifications.dart';
import 'package:bagaer/feature/notifications/domain/usecases/request_permission.dart';
import 'package:bagaer/feature/notifications/domain/usecases/handle_incoming_message.dart';
import 'package:bagaer/feature/notifications/presentation/services/local_notification_service.dart';
import 'package:bagaer/feature/notifications/domain/repositories/notification_repository.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final InitializeNotificationsUseCase initialize;
  final RequestPermissionUseCase requestPermission;
  final GetDeviceTokenUseCase getDeviceToken;
  final NotificationRepository repository;
  final LocalNotificationService localNotificationService;
  final HandleIncomingMessageUseCase handleIncomingMessage;

  StreamSubscription<PushNotification>? _sub;

  NotificationBloc({
    required this.initialize,
    required this.requestPermission,
    required this.getDeviceToken,
    required this.repository,
    required this.localNotificationService,
    required this.handleIncomingMessage,
  }) : super(NotificationInitial()) {
    on<InitializeNotificationsEvent>(_onInitialize);
    on<RequestPermissionEvent>(_onRequestPermission);
    on<IncomingNotificationEvent>(_onIncomingNotification);
    on<DeviceTokenLoadedEvent>(_onDeviceTokenLoaded);
  }

  // Future<void> _onInitialize(InitializeNotificationsEvent event, Emitter<NotificationState> emit) async {
  //   emit(NotificationLoading());
  //   final res = await initialize.call();
  //   res.match(
  //     (l) => emit(NotificationFailureState(l.message ?? 'Erro desconhecido')),
  //     (r) async {
  //       emit(NotificationPermissionGranted());
  //       final tokenRes = await getDeviceToken.call();
  //       tokenRes.match(
  //         (l) => emit(NotificationFailureState(l.message ?? 'Erro ao obter token')),
  //         (token) {
  //           print('ESSE É O TOKEN DO USUÁRIO: ${token ?? 'null'}');
  //           add(DeviceTokenLoadedEvent(token));
  //         },
  //       );

  //       // Listen to incoming messages
  //       _sub = repository.onMessageStream.listen((notification) async {
  //         final shouldShow = await handleIncomingMessage.call(notification);
  //         if (shouldShow) {
  //           print("[NotificationBloc] Showing local notification for incoming message");
  //           await localNotificationService.showNotification(
  //               id: notification.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
  //               title: notification.title,
  //               body: notification.body,
  //               data: notification.data);
  //         } else {
  //           print("NotificationBloc] Not showing local notification, dispatching IncomingNotificationEvent");
  //           add(IncomingNotificationEvent(notification));
  //         }
  //       });
  //     },
  //   );
  // }
  Future<void> _onInitialize(
    InitializeNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    
    // 1. Inicializa o Firebase
    final res = await initialize.call();
    
    await res.match(
      (l) async => emit(NotificationFailureState(l.message ?? 'Erro desconhecido')),
      (r) async {
        emit(NotificationPermissionGranted());

        // 2. Pega o Token
        final tokenRes = await getDeviceToken.call();
        tokenRes.match(
          (l) => emit(NotificationFailureState(l.message ?? 'Erro ao obter token')),
          (token) {
            print('ESSE É O TOKEN DO USUÁRIO: ${token ?? 'null'}');
            add(DeviceTokenLoadedEvent(token));
          },
        );

        // ==============================================================================
        //  NOVAS IMPLEMENTAÇÕES (Clique na Notificação)
        // ==============================================================================

        // A. App estava FECHADO (Terminated) e foi aberto pelo clique
        final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          print("App abriu com a notificação em terminated");
          _handleMessageInteraction(initialMessage);
        }

        // B. App estava em BACKGROUND (Minimizado) e foi aberto pelo clique
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          print("App abriu com a notificação em background");
          _handleMessageInteraction(message);
        });

        // ==============================================================================
        //  FIM DAS NOVAS IMPLEMENTAÇÕES
        // ==============================================================================

        // 3. Ouve mensagens chegando com o app ABERTO (Foreground)
        _sub = repository.onMessageStream.listen((notification) async {
          // Verifica se deve mostrar o banner (Use Case)
          final shouldShow = await handleIncomingMessage.call(notification);
          
          if (shouldShow) {
            print("[NotificationBloc] Showing local notification for incoming message");
            await localNotificationService.showNotification(
              id: notification.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: notification.title,
              body: notification.body,
              data: notification.data,
            );
          } else {
            // Se não for para mostrar banner, processa a lógica (ex: navegação imediata)
            print("[NotificationBloc] Not showing local notification, dispatching IncomingNotificationEvent");
            add(IncomingNotificationEvent(notification));
          }
        });
      },
    );
  }

  // --- Método Auxiliar para tratar o clique ---
  void _handleMessageInteraction(RemoteMessage message) {
    print('[NotificationBloc] Usuário clicou na notificação: ${message.data}');

    // Converte o RemoteMessage (do Firebase) para o seu NotificationModel (do App)
    final notificationModel = NotificationModel(
      id: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      sentTime: message.sentTime,
    );

    // Despacha o evento para que a UI ou o Bloc tomem a ação (ex: Navegar)
    // Estou reutilizando o IncomingNotificationEvent, mas você pode criar um NotificationOpenedEvent se preferir
    add(IncomingNotificationEvent(notificationModel));
  }

  Future<void> _onRequestPermission(RequestPermissionEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    final res = await requestPermission.call();
    res.match(
      (l) => emit(NotificationPermissionDenied()),
      (r) => emit(NotificationPermissionGranted()),
    );
  }

  Future<void> _onIncomingNotification(IncomingNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationReceivedState(event.notification));
  }

  Future<void> _onDeviceTokenLoaded(
      DeviceTokenLoadedEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationTokenLoaded(event.token));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
