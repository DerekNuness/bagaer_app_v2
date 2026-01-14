part of 'register_bloc.dart';

enum RegisterStep {
  phone,
  code,
  createUser,
  userCreated,
  profileData,        // country + dados pessoais
  travelPrefs,
  mealPrefs,
  uploadPhoto,
  done,
}

enum RegisterStatus { idle, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStep step;
  final RegisterStatus status;

  final String? phoneNumber;
  final AuthSession? session;         // quando existir
  final RegisterFailure? failure;

  const RegisterState({
    required this.step,
    required this.status,
    this.phoneNumber,
    this.session,
    this.failure,
  });

  factory RegisterState.initial() => const RegisterState(
    step: RegisterStep.phone,
    status: RegisterStatus.idle,
  );

  RegisterState copyWith({
    RegisterStep? step,
    RegisterStatus? status,
    String? phoneNumber,
    AuthSession? session,
    RegisterFailure? failure,
    bool clearFailure = false,
  }) {
    return RegisterState(
      step: step ?? this.step,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      session: session ?? this.session,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [step, status, phoneNumber, session, failure];
}