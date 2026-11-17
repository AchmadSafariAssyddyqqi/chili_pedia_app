import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi ke Portrait untuk kenyamanan petani di lapangan
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appState = AppState();
  await appState.initialize();

  runApp(ChiliPediaApp(appState: appState));
}

class ChiliPediaApp extends StatelessWidget {
  final AppState appState;

  const ChiliPediaApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'ChiliPedia',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(appState: appState),
        );
      },
    );
  }
}
