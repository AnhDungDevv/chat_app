import 'package:chat_application/features/app/config/supabase_config.dart'
    as supabase_config;
import 'package:chat_application/features/app/home/home_page.dart';
import 'package:chat_application/features/app/splash/splash_screen.dart';
import 'package:chat_application/features/app/theme/app_theme.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/auth/auth_state.dart';
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

  await supabase_config.SupabaseConfig.init();

  await dependencies.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => dependencies.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (_) => dependencies.sl<CredentialCubit>()),
        BlocProvider(create: (_) => dependencies.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => dependencies.sl<UserCubit>()),
        BlocProvider(create: (_) => dependencies.sl<GetDeviceNumberCubit>()),
        BlocProvider(create: (_) => dependencies.sl<ChatCubit>()),
        BlocProvider(create: (_) => dependencies.sl<MessageCubit>()),
        BlocProvider(create: (_) => dependencies.sl<StatusCubit>()),
        BlocProvider(create: (_) => dependencies.sl<GetMyStatusCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage(userId: authState.uid);
                }
                return SplashScreen();
              },
            );
          },
        },
        onGenerateRoute: GenerateRoutes.router,
      ),
    );
  }
}
