import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    required super.phoneVerified,
    required super.phoneVerifiedAt,

    super.name,
    super.surname,
    super.fullName,
    super.email,

    required super.emailVerified,
    required super.emailVerifiedAt,

    super.docIdent,
    super.docIdentType,

    required super.completeStatus,

    required super.newsletter,
    required super.notifications,

    required super.profilePicture,
    required super.country,

    required super.lastLogin,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return UserModel(
      id: json['id'],

      phoneNumber: json['phone_number'] ?? '',
      phoneVerified: json['phone_verified'] == true,
      phoneVerifiedAt: parseDate(json['phone_verified_at']),

      name: json['name'],
      surname: json['surname'],
      fullName: json['full_name'],
      email: json['email'],

      emailVerified: json['email_verified'] == true,
      emailVerifiedAt: parseDate(json['email_verified_at']),

      docIdent: json['doc_ident'],
      docIdentType: json['doc_ident_type'],

      completeStatus: json['complete_status'] == true,

      newsletter: json['newsletter'] == true,
      notifications: json['notifications'] == true,

      profilePicture: json['profile_picture'] ??
          'https://bagaer.nyc3.digitaloceanspaces.com/profile-pictures/blank-profile-picture.png',

      country: json['country'],

      lastLogin: parseDate(json['last_login']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}