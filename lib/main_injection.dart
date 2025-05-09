import 'package:chat_application/features/chat/chat_injection.dart';
import 'package:chat_application/features/status/status_injection.dart';
import 'package:chat_application/features/user/user_injecttion.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  await userInjection();
  await chatInjection();
  await statusInjection();
}
