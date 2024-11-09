 
import 'package:date_app/features/home/presentation/screen/detail_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../features/authentication/presentation/screens/auth_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/edit_profile/presentation/screen/edit_screen.dart';
import '../../features/likematch/presentation/screen/match_screen.dart';
import '../../features/notification/presentation/screen/notification_screen.dart';
import '../../features/onboarding/presentation/screens/onbording_screens.dart';
import '../../features/plan/presentation/screen/plan_screen.dart';
import '../../features/premium/presentation/screen/premium_screen.dart';
import '../../features/profile/presentation/screen/faq_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/step_account/presentation/screens/create_step_screen.dart';
import '../../widget/bottom_bar.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return CupertinoPageRoute(builder: (_) => const SplashScreen());

      case "/OnBoardingScreen":
        return CupertinoPageRoute(builder: (_) => const OnBoardingScreen());

      case "/recoverEmail":
        return CupertinoPageRoute(builder: (_) => Container());

      case "/creatSteps":
        return CupertinoPageRoute(builder: (_) => const CreateStepScreen());

      case "/authScreen":
        return CupertinoPageRoute(builder: (_) => const AuthScreen());
      case "/login":
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case "/bottombar":
        return CupertinoPageRoute(builder: (_) => const BottomBar());
      case "/faqPage":
        return CupertinoPageRoute(builder: (_) => const FaqScreen());
      case "/editPage":
        return CupertinoPageRoute(builder: (_) => const EditScreen());
      case "/planScreen":
        return CupertinoPageRoute(builder: (_) => const PlanScreen());
      case "/premiumScreen":
        return CupertinoPageRoute(builder: (_) => const PremiumScreen());
      case "/notificationScreen":
        return CupertinoPageRoute(builder: (_) => const NotificationScreen());
      case "/likeMatchScreen":
        return CupertinoPageRoute(builder: (_) => const MatchScreen());
      case '/detailScreen':
        return CupertinoPageRoute(builder: (_) => const DetailScreen());

      default:
        return CupertinoPageRoute(builder: (_) => Container());
    }
  }
}
