import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/configModel.dart';

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

    // Test if The Singleton is Already registered
    if (!getIt.isRegistered<ConfigModel>()) {
      getIt.registerSingleton<ConfigModel>(ConfigModel(
          API_Key: configData['API_Key'],
          BASE_API_URL: configData['BASE_API_URL'],
          BASE_IMAGE_API_URL: configData[
              'BASE_IMAGE_API_URL'])); // Register a Singleton of ConfigModel in GetIt
    } else {
      print("Already Registered");
    }
  }

  @override
  void initState() {
    super.initState();
    _setup(context).then((value) =>
        widget.onInitializationComplete()); // get information from config.json
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setup(context);
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
