import 'package:chat_application/features/call/data/repository/call_repository_impl.dart';
import 'package:chat_application/features/call/data/source/remote/call_remote_data_source.dart';
import 'package:chat_application/features/call/data/source/remote/call_remote_data_source_impl.dart';
import 'package:chat_application/features/call/domain/repository/call_repository.dart';
import 'package:chat_application/features/call/domain/usecases/get_call_channel_id_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/get_user_calling_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/make_call_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/update_call_history_status_usecase.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_cubit.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_cubit.dart';
import 'package:chat_application/features/call/presentation/cubit/my_call_history/my_call_history_cubit.dart';
import 'package:chat_application/main_injection.dart';

import 'domain/usecases/end_call_usecase.dart';
import 'domain/usecases/get_my_call_history_usecase.dart';
import 'domain/usecases/save_call_history_usecase.dart';

Future<void> callInjectionContainer() async {
  //  REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<CallRepository>(
    () => CallRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<CallRemoteDataSource>(
    () => CallRemoteDataSourceImpl(supabase: sl.call()),
  );
  //  USE CASES INJECTION

  sl.registerLazySingleton<GetMyCallHistoryUseCase>(
    () => GetMyCallHistoryUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<EndCallUseCase>(
    () => EndCallUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<SaveCallHistoryUseCase>(
    () => SaveCallHistoryUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<MakeCallUseCase>(
    () => MakeCallUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetUserCallingUseCase>(
    () => GetUserCallingUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetCallChannelIdUseCase>(
    () => GetCallChannelIdUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateCallHistoryStatusUseCase>(
    () => UpdateCallHistoryStatusUseCase(repository: sl.call()),
  );

  // CUBITS INJECTION

  sl.registerFactory<CallCubit>(
    () => CallCubit(
      endCallUseCase: sl.call(),
      getUserCallingUseCase: sl.call(),
      makeCallUseCase: sl.call(),
      saveCallHistoryUseCase: sl.call(),
      updateCallHistoryStatusUseCase: sl.call(),
    ),
  );

  sl.registerFactory<MyCallHistoryCubit>(
    () => MyCallHistoryCubit(getMyCallHistoryUseCase: sl.call()),
  );

  sl.registerLazySingleton<AgoraCubit>(() => AgoraCubit());
}
