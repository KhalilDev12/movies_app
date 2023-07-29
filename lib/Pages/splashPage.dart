import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/configModel.dart';
import 'package:movies_app/Services/httpService.dart';
import 'package:movies_app/Services/moviesService.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  SplashPage({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  Future<void> _setup(BuildContext context) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle
        .loadString("assets/config/main.json"); // Read the config json File
    final configData =
        jsonDecode(configFile); // Get the data from the config Json File

    // Test if The Config Model Singleton is Already registered
    if (!getIt.isRegistered<ConfigModel>()) {
      getIt.registerSingleton<ConfigModel>(ConfigModel(
          API_Key: configData['API_Key'],
          BASE_API_URL: configData['BASE_API_URL'],
          BASE_IMAGE_API_URL: configData[
              'BASE_IMAGE_API_URL'])); // Register a Singleton of ConfigModel in GetIt
    } else {
      print("Config Model Already Registered");
    }
    if (!getIt.isRegistered<HttpService>()) {
      getIt.registerSingleton<HttpService>(
        HttpService(),
      ); // Register a Singleton of HttpService in GetIt
    } else {
      print("HttpService Already Registered");
    }

    if (!getIt.isRegistered<MoviesService>()) {
      getIt.registerSingleton<MoviesService>(
        MoviesService(),
      ); // Register a Singleton of MoviesService in GetIt
    } else {
      print("MoviesService Already Registered");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then(
      (value) => _setup(context).then(   // Setup Services for the App
        (value) => widget.onInitializationComplete(), // go to Home Page
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flicked",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
        ),
      ),
    );
  }
}
