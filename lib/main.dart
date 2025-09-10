import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/theme.dart';
import 'core/utils/localization/spacex_localization.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const SpaceXApp());
}

class SpaceXApp extends StatefulWidget {
  const SpaceXApp({super.key});

  @override
  State<SpaceXApp> createState() => _SpaceXAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _SpaceXAppState? state = context.findAncestorStateOfType<_SpaceXAppState>();
    state?.setLocale(newLocale);
  }
}

class _SpaceXAppState extends State<SpaceXApp> {
  Locale _locale = const Locale('en', 'US');
  late LanguageProvider _languageProvider;

  @override
  void initState() {
    super.initState();
    _languageProvider = LanguageProvider();
    _initializeLanguage();
  }

  Future<void> _initializeLanguage() async {
    await _languageProvider.initializeLanguage();
    if (mounted) {
      setState(() {
        _locale = _languageProvider.locale;
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => _languageProvider),
        // TODO: Add other providers as you implement them
        // ChangeNotifierProvider(create: (_) => MissionProvider()),
        // ChangeNotifierProvider(create: (_) => RocketProvider()),
        // ChangeNotifierProvider(create: (_) => LaunchProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return GetMaterialApp(
                title: 'SpaceX Flutter App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                locale: _locale,
                localizationsDelegates: const [
                  SpaceXLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('fr', 'FR'),
                ],
                home: const SplashScreen(),
                getPages: [
                  GetPage(name: '/', page: () => const SplashScreen()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
