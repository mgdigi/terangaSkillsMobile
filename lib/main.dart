import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes.dart';
import 'modules/auth/controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init local storage
  await GetStorage.init();

  // Configure timeago for French
  timeago.setLocaleMessages('fr', timeago.FrMessages());

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TerangaSkillsApp());
}

class TerangaSkillsApp extends StatelessWidget {
  const TerangaSkillsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final token = storage.read<String>(AppConstants.accessTokenKey);
    final isFirstLaunch = storage.read<bool>('isFirstLaunch') ?? true;
    
    String initialRoute;
    if (isFirstLaunch) {
      initialRoute = AppRoutes.onboarding;
    } else if (token != null && token.isNotEmpty) {
      initialRoute = AppRoutes.home;
    } else {
      initialRoute = AppRoutes.login;
    }

    return GetMaterialApp(
      title: 'TerangaSkills',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: (storage.read<bool>('isDarkMode') ?? false) ? ThemeMode.dark : ThemeMode.light,

      // Routing
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),

      // Locale
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
    );
  }
}
