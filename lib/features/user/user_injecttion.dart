import 'package:chat_application/features/user/data/data_source/user_remote_data_source.dart';
import 'package:chat_application/features/user/data/data_source/user_remote_data_source_impl.dart';
import 'package:chat_application/features/user/data/repository/repository_impl.dart';
import 'package:chat_application/features/user/domain/repository/user_repository.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/get_current_uid_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/is_sign_in_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/sign_in_with_phone_number_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/sign_out_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/verify_phone_number_usecsae.dart';
import 'package:chat_application/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/user/get_all_users_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/user/get_device_number_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:chat_application/main_injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> userInjection() async {
  // REPOSITORY & SOURCE ----------
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(supabase: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl.call()),
  );

  //  USECASE ---------------------
  sl.registerLazySingleton<GetCurrentUidUsecase>(
    () => GetCurrentUidUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<IsSignInUsecase>(
    () => IsSignInUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetAllUsersUseCase>(
    () => GetAllUsersUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetSingleUserUseCase>(
    () => GetSingleUserUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<SignInWithPhoneNumberUseCase>(
    () => SignInWithPhoneNumberUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
    () => VerifyPhoneNumberUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetDeviceNumberUseCase>(
    () => GetDeviceNumberUseCase(repository: sl.call()),
  );

  // CUBIT -------------------
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getCurrentUidUsecase: sl.call(),
      isSignInUsecase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );
  sl.registerFactory<UserCubit>(
    () =>
        UserCubit(getAllUsersUseCase: sl.call(), updateUserUseCase: sl.call()),
  );

  sl.registerFactory<GetSingleUserCubit>(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  sl.registerFactory<CredentialCubit>(
    () => CredentialCubit(
      createUserUseCase: sl.call(),
      signInWithPhoneNumberUseCase: sl.call(),
      verifyPhoneNumberUseCase: sl.call(),
    ),
  );

  sl.registerFactory<GetDeviceNumberCubit>(
    () => GetDeviceNumberCubit(getDeviceNumberUseCase: sl.call()),
  );
}
