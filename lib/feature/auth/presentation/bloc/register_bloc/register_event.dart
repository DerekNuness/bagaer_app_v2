part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}


class SendToProfileDataStep extends RegisterEvent {
  final AuthSession session;

  const SendToProfileDataStep({required this.session});  

  @override
  List<Object?> get props => [session];
}

class RegisterBackToPhone extends RegisterEvent {}

class RegisterSendCodeRequested extends RegisterEvent {
  final String phoneNumber;
  final String autoCompleteCode;
  const RegisterSendCodeRequested({required this.phoneNumber, required this.autoCompleteCode});

  @override
  List<Object?> get props => [phoneNumber, autoCompleteCode];
}

class RegisterResendCodeRequested extends RegisterEvent {
  final String phoneNumber;
  final String autoCompleteCode;
  const RegisterResendCodeRequested({required this.phoneNumber, required this.autoCompleteCode});

  @override
  List<Object?> get props => [phoneNumber, autoCompleteCode];
}

class RegisterVerifyCodeRequested extends RegisterEvent {
  final String phoneNumber;
  final String code;
  const RegisterVerifyCodeRequested({required this.phoneNumber, required this.code});

  @override
  List<Object?> get props => [phoneNumber, code];
}

class RegisterCreateUserRequested extends RegisterEvent {
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final bool newsletter;
  final bool notifications;

  const RegisterCreateUserRequested({
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    required this.newsletter,
    required this.notifications,
  });

  @override
  List<Object?> get props => [phoneNumber, password, passwordConfirmation, newsletter, notifications];
}

class RegisterGoToProfileData extends RegisterEvent {}

class RegisterSubmitProfileRequested extends RegisterEvent {
  final int countryId;
  final String name;
  final String surname;
  final String email;
  final String docIdent;
  final String docIdentType;
  final bool newsletter;
  final String appVersion;
  final String deviceOs;

  /// token pode vir do session, então não precisa ser passado
  const RegisterSubmitProfileRequested({
    required this.countryId,
    required this.name,
    required this.surname,
    required this.email,
    required this.docIdent,
    required this.docIdentType,
    required this.newsletter,
    required this.appVersion,
    required this.deviceOs,
  });

  @override
  List<Object?> get props => [
    countryId, name, surname, email, docIdent, docIdentType, newsletter, appVersion, deviceOs
  ];
}

class RegisterSubmitTravelPrefsRequested extends RegisterEvent {
  final List<int> preferenceIds;
  const RegisterSubmitTravelPrefsRequested(this.preferenceIds);

  @override
  List<Object?> get props => [preferenceIds];
}

class RegisterSubmitMealPrefsRequested extends RegisterEvent {
  final List<int> preferenceIds;
  const RegisterSubmitMealPrefsRequested(this.preferenceIds);

  @override
  List<Object?> get props => [preferenceIds];
}

class RegisterUploadProfilePictureRequested extends RegisterEvent {
  final String filePath;
  const RegisterUploadProfilePictureRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class RegisterResetRequested extends RegisterEvent {}