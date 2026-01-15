import 'package:bagaer/feature/notifications/domain/entities/push_notification.dart';

/// Decide o que fazer com a notificação recebida.
/// Retorna true se a notificação deve ser exibida localmente, false caso contrário.
class HandleIncomingMessageUseCase {
  HandleIncomingMessageUseCase();

  Future<bool> call(PushNotification notification) async {
    // Exemplo simples: se existir campo `show_alert` no data e for '1', mostra.
    final data = notification.data ?? {};
    print("data no HandleIncomingMessageUseCase: $data");
    if (data['show_alert'] == '1' || data['show_alert'] == 1) return true;

    // Caso o payload contenha rota, decidimos navegar ao invés de exibir alerta.
    if (data['route'] != null) return false;

    // Padrão: mostrar.
    return true;
  }
}
