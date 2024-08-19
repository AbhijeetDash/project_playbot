import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:playbot/application/application_providers.dart';
import 'package:playbot/screens/splash.dart';
import 'package:playbot/services/bluetooth_service.dart';
import 'package:playbot/utilities/util_colors.dart';

final locator = GetIt.instance;

class Playbot extends StatefulWidget {
  const Playbot({super.key});

  @override
  State<Playbot> createState() => _PlaybotState();
}

class _PlaybotState extends State<Playbot> {

  @override
  void initState() {
    locator.registerSingleton<BluetoothService>(BluetoothServiceImpl()); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlaybotProviders(child:  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: PlayColors.backgroundYellow,
        colorScheme: ColorScheme.fromSeed(seedColor: PlayColors.backgroundYellow),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5
          )
        )
      ),
      home: const SplashScreen(),
    ));
  }
}