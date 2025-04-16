import 'package:chat_application/features/app/home/home_page.dart';
import 'package:chat_application/features/app/splash/splash_screen.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await supabase.Supabase.initialize(
    url: 'https://gboeisktatdumeolpreu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdib2Vpc2t0YXRkdW1lb2xwcmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3MzkzODksImV4cCI6MjA2MDMxNTM4OX0.zwO-xpnVCAttNGvGPHoOFoM4NaddvAuWgD3TCIB1CfA',
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => dependencies.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider(create: (context) => dependencies.sl<CredentialCubit>()),
        BlocProvider(
          create: (context) => dependencies.sl<GetSingleUserCubit>(),
        ),
        BlocProvider(create: (context) => dependencies.sl<UserCubit>()),
        BlocProvider(
          create: (context) => dependencies.sl<GetDeviceNumberCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: tabColor,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(color: appBarColor),
          dialogTheme: DialogThemeData(backgroundColor: appBarColor),
        ),
        onGenerateRoute: GenerateRoutes.router,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage(uid: authState.uid);
                }
                return SplashScreen();
              },
            );
          },
        },
      ),
    );
  }
}
