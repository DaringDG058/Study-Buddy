import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:study_buddy/providers/auth_provider.dart';
import 'package:study_buddy/providers/image_storage_provider.dart';
import 'package:study_buddy/providers/study_provider.dart';
import 'package:study_buddy/providers/theme_provider.dart';
import 'package:study_buddy/screens/splash_screen.dart';
import 'package:study_buddy/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => StudyProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ImageStorageProvider(prefs)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Study Buddy',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}