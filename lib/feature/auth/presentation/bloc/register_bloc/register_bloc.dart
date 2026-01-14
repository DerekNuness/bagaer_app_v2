import 'package:bagaer/core/errors/register/register_failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/register_send_code_usecase.dart';
import '../../../domain/usecases/register_check_code_usecase.dart';
import '../../../domain/usecases/register_create_user_usecase.dart';
import '../../../domain/usecases/set_user_country_usecase.dart';
import '../../../domain/usecases/add_user_data_usecase.dart';
import '../../../domain/usecases/set_travel_preferences_usecase.dart';
import '../../../domain/usecases/set_meal_preferences_usecase.dart';
import '../../../domain/usecases/upload_profile_picture_usecase.dart';


part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterSendCodeUseCase sendCode;
  final RegisterCheckCodeUseCase checkCode;
  final RegisterCreateUserUseCase createUser;

  final SetUserCountryUseCase setUserCountry;
  final AddUserDataUseCase addUserData;

  final SetTravelPreferencesUseCase setTravelPrefs;
  final SetMealPreferencesUseCase setMealPrefs;
  final UploadProfilePictureUseCase uploadProfilePicture;

  AuthSession? _session;

  RegisterBloc({
    required this.sendCode,
    required this.checkCode,
    required this.createUser,
    required this.setUserCountry,
    required this.addUserData,
    required this.setTravelPrefs,
    required this.setMealPrefs,
    required this.uploadProfilePicture,
  }) : super(RegisterState.initial()) {
    on<RegisterBackToPhone>((event, emit) {
      emit(
        state.copyWith(
          step: RegisterStep.phone,
          status: RegisterStatus.idle,
          clearFailure: true,
        ),
      );
    });
    on<RegisterSendCodeRequested>(_onSendCode);
    on<RegisterResendCodeRequested>(_onResendCode);
    on<RegisterVerifyCodeRequested>(_onVerifyCode);
    on<RegisterCreateUserRequested>(_onCreateUser);
    on<RegisterGoToProfileData>((event, emit) {
      emit(state.copyWith(
        step: RegisterStep.profileData,
        status: RegisterStatus.success,
      ));
    });

    on<SendToProfileDataStep>((event, emit) {
      emit(state.copyWith(
        step: RegisterStep.profileData,
        status: RegisterStatus.success,
        session: event.session
      ));
      _session = event.session;
    });

    on<RegisterSubmitProfileRequested>(_onSubmitProfile); 
    on<RegisterSubmitTravelPrefsRequested>(_onTravelPrefs);
    on<RegisterSubmitMealPrefsRequested>(_onMealPrefs);
    on<RegisterUploadProfilePictureRequested>(_onUploadPhoto);

    on<RegisterResetRequested>((event, emit) {
      _session = null;
      emit(RegisterState.initial());
    });
  }

  Future<void> _onSendCode(RegisterSendCodeRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      await sendCode(phoneNumber: event.phoneNumber, autoCompleteCode: event.autoCompleteCode);

      emit(state.copyWith(
        step: RegisterStep.code,
        status: RegisterStatus.success,
        phoneNumber: event.phoneNumber,
      ));
    } on UserAlreadyRegistered catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onResendCode(RegisterResendCodeRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      await sendCode(phoneNumber: event.phoneNumber, autoCompleteCode: event.autoCompleteCode);

      emit(state.copyWith(
        status: RegisterStatus.success,
      ));
      
    } on UserAlreadyRegistered catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onVerifyCode(RegisterVerifyCodeRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      await checkCode(phoneNumber: event.phoneNumber, code: event.code);

      emit(state.copyWith(
        step: RegisterStep.createUser,
        status: RegisterStatus.success,
        phoneNumber: event.phoneNumber,
      ));

    } on InvalidRegisterCode catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on NoMoreAttempts catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on CodeExpired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onCreateUser(RegisterCreateUserRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      final session = await createUser(
        phoneNumber: event.phoneNumber,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        newsletter: event.newsletter,
        notifications: event.notifications,
      );

      _session = session;

      emit(state.copyWith(
        step: RegisterStep.userCreated,
        status: RegisterStatus.success,
        session: session,
        phoneNumber: event.phoneNumber,
      ));
      
    } on PasswordFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on PasswordDoesntMatch catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on PhoneNotVerified catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on SessionExpired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    } 
  }

  /// ✅ Country + Dados pessoais juntos
  Future<void> _onSubmitProfile(RegisterSubmitProfileRequested event, Emitter<RegisterState> emit,) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    print("emitiu o loading");
    try {
      final realToken = state.session?.accessToken;
      final token = _session?.accessToken;
      print("realToken?: $realToken");
      print("token?: $token");

      if (token == null) {
        emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
        return;
      }

      // 1) country
      await setUserCountry(token: token, countryId: event.countryId);

      // 2) dados pessoais (retorna session atualizada)
      final updated = await addUserData(
        token: token,
        name: event.name,
        surname: event.surname,
        email: event.email,
        docIdent: event.docIdent,
        docIdentType: event.docIdentType,
        newsletter: event.newsletter,
        appVersion: event.appVersion,
        deviceOs: event.deviceOs,
      );

      _session = updated;

      emit(state.copyWith(
        step: RegisterStep.travelPrefs,
        status: RegisterStatus.success,
        session: updated,
      ));
    } on EmailAlreadyInUse catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on DocumentAlreadyInUse catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on NameRequired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on SurnameRequired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on EmailRequired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on DocIdentRequired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on DocTypeRequired catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onTravelPrefs(RegisterSubmitTravelPrefsRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      final token = _session?.accessToken;
      if (token == null) {
        emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
        return;
      }

      await setTravelPrefs(token: token, travelPreferences: event.preferenceIds);

      emit(state.copyWith(step: RegisterStep.mealPrefs, status: RegisterStatus.success));
      
    } on UserUnathenticated catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onMealPrefs(
    RegisterSubmitMealPrefsRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      final token = _session?.accessToken;
      if (token == null) {
        emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
        return;
      }

      await setMealPrefs(token: token, mealPreferences: event.preferenceIds);

      emit(state.copyWith(step: RegisterStep.uploadPhoto, status: RegisterStatus.success));

    } on UserUnathenticated catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } on RegisterNetworkFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  Future<void> _onUploadPhoto(RegisterUploadProfilePictureRequested event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    print("Status loading");
    try {
      final token = _session?.accessToken;
      if (token == null) {
        print("Token null = erro");
        emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
        return;
      }

      final updated = await uploadProfilePicture(token: token, filePath: event.filePath);
      _session = updated;

      emit(state.copyWith(step: RegisterStep.done, status: RegisterStatus.success, session: updated));

    } on RegisterFailure catch (f) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: f));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: RegisterStatus.failure, failure: RegisterUnknownAuthFailure()));
    }
  }

  /// expose session para UI se precisar
  AuthSession? get currentSession => _session;
}