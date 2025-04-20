import 'package:chat_application/features/status/data/repository/status_repository_impl.dart';
import 'package:chat_application/features/status/data/source/remote/status_remote_data_source.dart';
import 'package:chat_application/features/status/data/source/remote/status_remote_data_source_impl.dart';
import 'package:chat_application/features/status/domain/repository/status_repository.dart';
import 'package:chat_application/features/status/domain/usecases/create_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/delete_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/get_my_status_future_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/get_my_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/get_statuses_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/seen_status_update_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/update_only_image_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/update_status_usecase.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:chat_application/main_injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> statusInjection() async {
  // REPOSITORY & SOURCE ----------
  sl.registerLazySingleton<StatusRemoteDataSource>(
    () => StatusRemoteDataSourceImpl(supabase: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<StatusRepository>(
    () => StatusRepositoryImpl(remoteDataSource: sl.call()),
  );

  //  USECASE ---------------------
  sl.registerLazySingleton<CreateStatusUsecase>(
    () => CreateStatusUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<DeleteStatusUsecase>(
    () => DeleteStatusUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetMyStatusFutureUseCase>(
    () => GetMyStatusFutureUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetMyStatusUseCase>(
    () => GetMyStatusUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetStatusesUseCase>(
    () => GetStatusesUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<SeenStatusUpdateUseCase>(
    () => SeenStatusUpdateUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateOnlyImageStatusUseCase>(
    () => UpdateOnlyImageStatusUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateStatusUseCase>(
    () => UpdateStatusUseCase(repository: sl.call()),
  );
  // CUBIT -------------------

  sl.registerLazySingleton<StatusCubit>(
    () => StatusCubit(
      createStatusUseCase: sl.call(),
      deleteStatusUseCase: sl.call(),
      updateOnlyImageStatusUseCase: sl.call(),
      updateStatusUseCase: sl.call(),
      getStatusesUseCase: sl.call(),
      seenStatusUpdateUseCase: sl.call(),
    ),
  );
  sl.registerLazySingleton<GetMyStatusCubit>(
    () => GetMyStatusCubit(getMyStatusUseCase: sl.call()),
  );
}
