import 'package:bagaer/core/ffmpeg/ffmpeg_runner.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/network/api_client.dart';
import 'package:bagaer/core/network/api_constants.dart';
import 'package:bagaer/core/network/api_endpoints.dart';
import 'package:bagaer/core/storage/shared_preferences_token_storage.dart';
import 'package:bagaer/core/storage/token_storage.dart';
import 'package:bagaer/feature/app_version/data/datasources/app_version_datasource.dart';
import 'package:bagaer/feature/app_version/data/datasources/app_version_datasource_impl.dart';
import 'package:bagaer/feature/app_version/data/repositories/app_version_repository_impl.dart';
import 'package:bagaer/feature/app_version/domain/repositories/app_version_repository.dart';
import 'package:bagaer/feature/app_version/domain/usecases/get_app_version_info.dart';
import 'package:bagaer/feature/app_version/presentation/bloc/app_version_bloc.dart';
import 'package:bagaer/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:bagaer/feature/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:bagaer/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bagaer/feature/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:bagaer/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:bagaer/feature/auth/domain/repositories/auth_repository.dart';
import 'package:bagaer/feature/auth/domain/usecases/add_user_data_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/delete_account_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/direct_login_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/get_cached_token_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/login_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/register_check_code_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/register_create_user_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/register_send_code_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/set_meal_preferences_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/set_travel_preferences_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/set_user_country_usecase.dart';
import 'package:bagaer/feature/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/language/presentation/bloc/language/bloc/language_bloc.dart';
import 'package:bagaer/feature/meal_preference/data/datasources/meal_preferences_remote_datasource.dart';
import 'package:bagaer/feature/meal_preference/data/datasources/meal_preferences_remote_datasource_impl.dart';
import 'package:bagaer/feature/meal_preference/data/repositories/meal_preferences_repository_impl.dart';
import 'package:bagaer/feature/meal_preference/domain/repositories/meal_preferences_repository.dart';
import 'package:bagaer/feature/meal_preference/domain/usecases/get_meal_preferences_usecase.dart';
import 'package:bagaer/feature/meal_preference/presentation/cubit/meal_preferences_cubit.dart';
import 'package:bagaer/feature/media/data/datasources/camera_datasource.dart';
import 'package:bagaer/feature/media/data/datasources/camera_datasource_impl.dart';
import 'package:bagaer/feature/media/data/datasources/ffmpeg_datasource.dart';
import 'package:bagaer/feature/media/data/datasources/ffmpeg_datasource_impl.dart';
import 'package:bagaer/feature/media/data/datasources/gallery_datasource.dart';
import 'package:bagaer/feature/media/data/datasources/gallery_datasource_impl.dart';
import 'package:bagaer/feature/media/data/datasources/media_local_datasource.dart';
import 'package:bagaer/feature/media/data/datasources/media_local_datasource_impl.dart';
import 'package:bagaer/feature/media/data/repositories/media_repository_impl.dart';
import 'package:bagaer/feature/media/domain/repositories/media_repository.dart';
import 'package:bagaer/feature/media/domain/usecases/capture_media.dart';
import 'package:bagaer/feature/media/domain/usecases/delete_media.dart';
import 'package:bagaer/feature/media/domain/usecases/list_media.dart';
import 'package:bagaer/feature/media/domain/usecases/process_media.dart';
import 'package:bagaer/feature/media/domain/usecases/save_media_to_bucket.dart';
import 'package:bagaer/feature/media/presentation/bloc/media_capture_bloc/media_capture_bloc.dart';
import 'package:bagaer/feature/media/presentation/bloc/media_library_bloc/media_library_bloc.dart';
import 'package:bagaer/feature/notifications/data/datasources/notification_local_data_source.dart';
import 'package:bagaer/feature/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:bagaer/feature/notifications/data/repositories/notification_repository_impl.dart';
import 'package:bagaer/feature/notifications/domain/repositories/notification_repository.dart';
import 'package:bagaer/feature/notifications/domain/usecases/get_device_token.dart';
import 'package:bagaer/feature/notifications/domain/usecases/initialize_notifications.dart';
import 'package:bagaer/feature/notifications/domain/usecases/request_permission.dart';
import 'package:bagaer/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:bagaer/feature/notifications/domain/usecases/handle_incoming_message.dart';
import 'package:bagaer/feature/notifications/presentation/services/local_notification_service.dart';
import 'package:bagaer/feature/permissions/data/datasources/permission_datasource.dart';
import 'package:bagaer/feature/permissions/data/datasources/permission_datasource_impl.dart';
import 'package:bagaer/feature/permissions/data/repositories/permission_repository_impl.dart';
import 'package:bagaer/feature/permissions/domain/repositories/permission_repository.dart';
import 'package:bagaer/feature/permissions/domain/usecases/ensure_camera_permission_usecase.dart';
import 'package:bagaer/feature/permissions/domain/usecases/ensure_microphone_permission_usecase.dart';
import 'package:bagaer/feature/travel_preferences/data/datasources/travel_preferences_remote_datasource.dart';
import 'package:bagaer/feature/travel_preferences/data/datasources/travel_preferences_remote_datasource_impl.dart';
import 'package:bagaer/feature/travel_preferences/data/repositories/travel_preferences_repository_impl.dart';
import 'package:bagaer/feature/travel_preferences/domain/repositories/travel_preferences_repository.dart';
import 'package:bagaer/feature/travel_preferences/domain/usecases/get_travel_preferences_usecase.dart';
import 'package:bagaer/feature/travel_preferences/presentation/cubit/travel_preferences_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// =====================
  /// Core
  /// =====================

  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  sl.registerLazySingleton<TokenStorage>(
    () => SharedPreferencesTokenStorage(sl()),
  );

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
      ),
    ),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      dio: sl(),
      apiKey: ApiConstants.apiKey,
    ),
  );

  sl.registerLazySingleton<FfmpegRunner>(() => const FfmpegRunner());

  /// =====================
  /// Notifications
  /// ====================
  // FirebaseMessaging
  if (!sl.isRegistered<FirebaseMessaging>()) {
    sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  }

  // Data sources
  if (!sl.isRegistered<NotificationRemoteDataSource>()) {
    sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl<FirebaseMessaging>()));
  }
  if (!sl.isRegistered<NotificationLocalDataSource>()) {
    sl.registerLazySingleton<NotificationLocalDataSource>(
        () => NotificationLocalDataSourceImpl(sl<SharedPreferences>()));
  }

  // Repository
  if (!sl.isRegistered<NotificationRepository>()) {
    sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(remote: sl(), local: sl()));
  }

  // Usecases
  if (!sl.isRegistered<RequestPermissionUseCase>()) {
    sl.registerLazySingleton(() => RequestPermissionUseCase(sl()));
  }
  if (!sl.isRegistered<GetDeviceTokenUseCase>()) {
    sl.registerLazySingleton(() => GetDeviceTokenUseCase(sl()));
  }
  if (!sl.isRegistered<InitializeNotificationsUseCase>()) {
    sl.registerLazySingleton(() => InitializeNotificationsUseCase(sl()));
  }

  // Local notification service (async factory)
  if (!sl.isRegistered<LocalNotificationService>()) {
    // Note: creating synchronously here isn't possible; register factory that creates when needed
    sl.registerFactoryAsync<LocalNotificationService>(() async => await LocalNotificationService.create());
  }

  // Notifications usecases without deps
  if (!sl.isRegistered<HandleIncomingMessageUseCase>()) {
    sl.registerLazySingleton(() => HandleIncomingMessageUseCase());
  }

  // Notification BLoC (depends on async LocalNotificationService)
  if (!sl.isRegistered<NotificationBloc>()) {
    sl.registerFactoryAsync<NotificationBloc>(() async {
      final local = await sl.getAsync<LocalNotificationService>();
      return NotificationBloc(
        initialize: sl(),
        requestPermission: sl(),
        getDeviceToken: sl(),
        repository: sl(),
        localNotificationService: local,
        handleIncomingMessage: sl(),
      );
    });
  }


  // /// Rive
  // sl.registerLazySingleton(
  //   () => RiveNative.init(),
  // );


  /// =====================
  /// App Language
  /// =====================
  sl.registerLazySingleton<LanguageBloc>(() => LanguageBloc());

  /// =====================
  /// App Version
  /// =====================

  sl.registerLazySingleton<AppVersionRemoteDatasource>(
    () => AppVersionRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AppVersionRepository>(
    () => AppVersionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetAppVersionInfo(sl()),
  );

  sl.registerFactory(
    () => AppVersionBloc(getAppVersionInfo: sl()),
  );

  /// =====================
  /// Auth Datasources
  /// =====================

  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl(),
      local: sl(),
    ),
  );

  /// =====================
  /// Auth UseCases 
  /// =====================

  sl.registerLazySingleton(() => GetCachedTokenUseCase(sl()));
  sl.registerLazySingleton(() => DirectLoginUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));

  sl.registerLazySingleton(() => RegisterSendCodeUseCase(sl()));
  sl.registerLazySingleton(() => RegisterCheckCodeUseCase(sl()));
  sl.registerLazySingleton(() => RegisterCreateUserUseCase(sl()));
  sl.registerLazySingleton(() => SetUserCountryUseCase(sl()));
  sl.registerLazySingleton(() => AddUserDataUseCase(sl()));
  sl.registerLazySingleton(() => SetTravelPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => SetMealPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfilePictureUseCase(sl()));

  /// =====================
  /// BLOCS
  /// =====================

  /// Auth (GLOBAL)
  sl.registerLazySingleton(
    () => AuthBloc(
      getCachedToken: sl(),
      directLogin: sl(),
      logout: sl(),
    ),
  );

  /// Login
  sl.registerFactory(
    () => LoginBloc(
      getCachedToken: sl(),
      directLogin: sl(),
      login: sl(),
      logout: sl(),
      deleteAccount: sl(),
    ),
  );

  /// Register
  sl.registerFactory(
    () => RegisterBloc(
      sendCode: sl(),
      checkCode: sl(),
      createUser: sl(),
      setUserCountry: sl(),
      addUserData: sl(),
      setTravelPrefs: sl(),
      setMealPrefs: sl(),
      uploadProfilePicture: sl(),
    ),
  );

  /// Travel Preferences
  sl.registerLazySingleton<TravelPreferencesRemoteDatasource>(
    () => TravelPreferencesRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<TravelPreferencesRepository>(
    () => TravelPreferencesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetTravelPreferences(sl()),
  );

  sl.registerFactory(
    () => TravelPreferencesCubit(sl()),
  );

  /// Meal Preferences
  sl.registerLazySingleton<MealPreferencesRemoteDatasource>(
    () => MealPreferencesRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<MealPreferencesRepository>(
    () => MealPreferencesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetMealPreferences(sl()),
  );

  sl.registerFactory(
    () => MealPreferencesCubit(sl()),
  );
  
  // ===================
  // PERMISSIONS
  // ===================
  sl.registerLazySingleton<PermissionDataSource>(
    () => PermissionDataSourceImpl(),
  );

   sl.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(sl()),
  );

  // ===================
  // PERMISSIONS – USE CASES
  // ===================
  sl.registerFactory(() => EnsureCameraPermissionUseCase(sl()));
  sl.registerFactory(() => EnsureMicrophonePermissionUseCase(sl()));


  // ===================
  // MEDIA – DATASOURCES
  // ===================
  sl.registerLazySingleton<CameraDataSource>(
    () => CameraDataSourceImpl(),
  );

  sl.registerLazySingleton<FfmpegDataSource>(
    () => FfmpegDataSourceImpl(
      runner: sl<FfmpegRunner>(),
    ),
  );

  sl.registerLazySingleton<GalleryDataSource>(
    () => GalleryDataSourceImpl(),
  );

  sl.registerLazySingleton<MediaLocalDataSource>(
    () => MediaLocalDataSourceImpl(),
  );

  // ===================
  // MEDIA – REPOSITORY
  // ===================
  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(
      cameraDataSource: sl(),
      ffmpegDataSource: sl(),
      galleryDataSource: sl(),
      mediaLocalDataSource: sl(),
    ),
  );

  // ===================
  // MEDIA – USE CASES
  // ===================
  sl.registerFactory(() => CaptureMedia(sl()));
  sl.registerFactory(() => ProcessMedia(sl()));
  sl.registerFactory(() => SaveMediaToBucket(sl()));
  sl.registerFactory(() => ListMedia(sl()));
  sl.registerFactory(() => DeleteMedia(sl()));

  // ===================
  // MEDIA – BLOCS
  // ===================
  sl.registerFactory(
    () => MediaCaptureBloc(
      cameraPermission: sl(),
      microphonePermission: sl(),
      captureMedia: sl(),
      processMedia: sl(),
      saveMediaToBucket: sl(),
    ),
  );

  sl.registerFactory(
    () => MediaLibraryBloc(
      listMedia: sl(),
      deleteMedia: sl(),
    ),
  );
}

Future<void> registerBackgroundHandler(Future<void> Function(RemoteMessage) handler) async {
  final remote = sl<NotificationRemoteDataSource>();
  await remote.setBackgroundHandler(handler);
}
