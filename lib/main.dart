import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'splash_screen.dart';

void main() {
  // Initialize theme provider with system brightness before running the app
  final themeProvider = ThemeProvider();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Initialize theme on first build with system brightness
    // Using context is safe here as it's called during normal widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!themeProvider.isInitialized) {
        final brightness = MediaQuery.of(context).platformBrightness;
        themeProvider.initTheme(brightness);
      }
    });

    return MaterialApp(
      title: 'User Directory',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
