import 'package:chat_application/features/chat/data/repository/chat_reponsitory_impl.dart';
import 'package:chat_application/features/chat/data/source/remote/chat_remote_data_source.dart';
import 'package:chat_application/features/chat/data/source/remote/chat_remote_data_source_impl.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';
import 'package:chat_application/features/chat/domain/usecases/delete_message_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/delete_my_chat_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:chat_application/main_injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> chatInjection() async {
  //  REPONSITORY & SOURCE INJECTION
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<ChatReponsitory>(
    () => ChatReponsitoryImpl(chatRemoteDataSource: sl.call()),
  );
  // USECASE INJECTION

  sl.registerLazySingleton<DeleteMessageUsecase>(
    () => DeleteMessageUsecase(reponsitory: sl.call()),
  );
  sl.registerLazySingleton<DeleteMyChatUsecase>(
    () => DeleteMyChatUsecase(reponsitory: sl.call()),
  );
  sl.registerLazySingleton<GetMessageUsecase>(
    () => GetMessageUsecase(reponsitory: sl.call()),
  );
  sl.registerLazySingleton<GetMyChatUsecase>(
    () => GetMyChatUsecase(reponsitory: sl.call()),
  );
  sl.registerLazySingleton<SendMessageUsecase>(
    () => SendMessageUsecase(reponsitory: sl.call()),
  );

  // CUBIT INJECTION
  sl.registerLazySingleton<ChatCubit>(
    () =>
        ChatCubit(getMyChatUsecase: sl.call(), deleteMyChatUsecase: sl.call()),
  );
  sl.registerLazySingleton(
    () => MessageCubit(
      deleteMessageUsecase: sl.call(),
      sendMessageUsecase: sl.call(),
      getMessageUsecase: sl.call(),
    ),
  );
}
