import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.tokenType,
    required super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return AuthSessionModel(
      accessToken: json['access_token'] ?? token!,
      tokenType: json['token_type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user']),
    );
  }
}