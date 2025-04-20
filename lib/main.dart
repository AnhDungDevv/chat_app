import 'package:chat_application/features/app/config/supabase_config.dart'
    as supabaseConfig;
import 'package:chat_application/features/app/root_page/root_page.dart';
import 'package:chat_application/features/app/theme/app_theme.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/routes/generate_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/main_injection.dart' as dependencies;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");

  await supabaseConfig.SupabaseConfig.init();

  await dependencies.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildBlocProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        onGenerateRoute: GenerateRoutes.router,
        initialRoute: "/",
        home: const RootPage(),
      ),
    );
  }

  List<BlocProvider> _buildBlocProviders() {
    return [
      BlocProvider(create: (_) => dependencies.sl<AuthCubit>()..appStarted()),
      BlocProvider(create: (_) => dependencies.sl<CredentialCubit>()),
      BlocProvider(create: (_) => dependencies.sl<GetSingleUserCubit>()),
      BlocProvider(create: (_) => dependencies.sl<UserCubit>()),
      BlocProvider(create: (_) => dependencies.sl<GetDeviceNumberCubit>()),
      BlocProvider(create: (_) => dependencies.sl<ChatCubit>()),
      BlocProvider(create: (_) => dependencies.sl<MessageCubit>()),
      BlocProvider(create: (_) => dependencies.sl<StatusCubit>()),
      BlocProvider(create: (_) => dependencies.sl<GetMyStatusCubit>()),
    ];
  }
}
