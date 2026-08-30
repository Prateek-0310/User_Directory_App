import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Read system brightness via MediaQuery to handle inverted initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = MediaQuery.of(context).platformBrightness;
      themeProvider.initTheme(brightness);
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
