import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/language/localization/app_localization_setup.dart';
import 'core/notification/push_notification_function.dart';
import 'core/routes/routes.dart';
import 'features/authentication/bloc/auth_cubit.dart';
import 'features/chatting/bloc/audiocall_provider.dart';
import 'features/chatting/bloc/chatting_provider.dart';
import 'features/chatting/bloc/vc_provider.dart';
import 'features/chatting/presentation/screen/chat_screen.dart';
import 'features/chatting/presentation/screen/pick_up_call_screen.dart';
import 'features/edit_profile/bloc/editprofile_cubit.dart';
import 'features/edit_profile/bloc/editprofile_provider.dart';
import 'features/home/bloc/detail_provider.dart';
import 'features/home/bloc/home_cubit.dart';
import 'features/home/bloc/home_provier.dart';
import 'features/language/bloc/language_cubit.dart';
import 'features/likematch/bloc/likematch_provider.dart';
import 'features/likematch/bloc/match_cubit.dart';
import 'features/likematch/bloc/match_provider.dart';
import 'features/onboarding/bloc/onbording_cubit.dart';
import 'features/onboarding/bloc/onbording_provider.dart';
import 'features/onboarding/data/firebase/auth_firebase.dart';
import 'features/premium/bloc/premium_bloc.dart';
import 'features/premium/bloc/premium_provider.dart';
import 'features/profile/bloc/profile_provider.dart';
import 'features/profile/presentation/screen/profile_screen.dart';
import 'features/theme/bloc/lite_dark_cubit.dart';
import 'features/theme/bloc/lite_dark_state.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  initPlatformState();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((event) {
    if (event.data["vcId"] != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => PickUpCallScreen(
                userData: event.data,
                isAudio: false,
              )));
    } else if (event.data["Audio"] != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => PickUpCallScreen(
                userData: event.data,
                isAudio: true,
              )));
    }
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  initializeNotifications();
  listenFCM();
  loadFCM();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => OnbordingCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => HomePageCubit()),
        BlocProvider(create: (context) => MatchCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
        BlocProvider(create: (context) => PremiumBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, languageState) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => DetailProvider()),
                  ChangeNotifierProvider(
                      create: (context) => ProfileProvider()),
                  ChangeNotifierProvider(
                      create: (context) => OnBordingProvider()),
                  ChangeNotifierProvider(
                      create: (context) => FirebaseAuthService()),
                  ChangeNotifierProvider(
                      create: (context) => EditProfileProvider()),
                  ChangeNotifierProvider(
                      create: (context) => PremiumProvider()),
                  ChangeNotifierProvider(create: (context) => MatchProvider()),
                  ChangeNotifierProvider(
                      create: (context) => LikeMatchProvider()),
                  ChangeNotifierProvider(
                      create: (context) => ChattingProvider()),
                  ChangeNotifierProvider(create: (context) => MatchProvider()),
                  ChangeNotifierProvider(create: (context) => HomeProvider()),
                  ChangeNotifierProvider(create: (context) => VcProvider()),
                  ChangeNotifierProvider(
                      create: (context) => AudioCallProvider()),
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: "/",
                  theme: theme.themeData,
                  navigatorKey: navigatorKey,
                  onGenerateRoute: Routes.onGenerateRoute,
                  supportedLocales: AppLocalizationSetup.supportedLanguage,
                  localizationsDelegates:
                      AppLocalizationSetup.localizationsDelegates,
                  localeResolutionCallback:
                      AppLocalizationSetup.localeResolutionCallback,
                  locale: languageState.locale,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
