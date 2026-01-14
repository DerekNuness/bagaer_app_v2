class UserEntity {
  final int id;

  final String phoneNumber;
  final bool phoneVerified;
  final DateTime? phoneVerifiedAt;

  final String? name;
  final String? surname;
  final String? fullName;
  final String? email;

  final bool emailVerified;
  final DateTime? emailVerifiedAt;

  final String? docIdent;
  final String? docIdentType;

  final bool completeStatus;

  final bool newsletter;
  final bool notifications;

  final String profilePicture;
  final dynamic country;

  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.phoneVerified,
    required this.phoneVerifiedAt,

    this.name,
    this.surname,
    this.fullName,
    this.email,

    required this.emailVerified,
    required this.emailVerifiedAt,

    this.docIdent,
    this.docIdentType,

    required this.completeStatus,

    required this.newsletter,
    required this.notifications,

    required this.profilePicture,
    required this.country,

    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasRequiredProfileData =>
      (name != null && name!.trim().isNotEmpty) &&
      (surname != null && surname!.trim().isNotEmpty) &&
      (email != null && email!.trim().isNotEmpty) &&
      (docIdent != null && docIdent!.trim().isNotEmpty) &&
      (docIdentType != null && docIdentType!.trim().isNotEmpty);

  /// Regra para detectar cadastro incompleto (vai pra etapa 4)
  bool get needsProfileData => name == null || name!.trim().isEmpty;
}