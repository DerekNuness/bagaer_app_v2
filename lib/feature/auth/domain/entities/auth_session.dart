import 'package:bagaer/feature/auth/domain/entities/user_entity.dart';

class AuthSession {
  final String accessToken;
  final String tokenType; // "Bearer"
  final UserEntity user;

  const AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  String get bearerToken => '$tokenType $accessToken';
}