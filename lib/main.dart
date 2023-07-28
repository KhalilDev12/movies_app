import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/Pages/homePage.dart';
import 'package:movies_app/Pages/splashPage.dart';

void main() {
  runApp(
    // Run Splash App first
    SplashPage(
        key: UniqueKey(),
        onInitializationComplete: () {
          // After Complete Run the Main App
          runApp(ProviderScope(child: const MyApp()));
        }),
  );
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flicker",
      initialRoute: "home",
      routes: {
        "home": (BuildContext _context) => HomePage(),
      },
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
