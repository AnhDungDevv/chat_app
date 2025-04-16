import 'package:chat_application/features/user/user_injecttion.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  await userInjection();
}
