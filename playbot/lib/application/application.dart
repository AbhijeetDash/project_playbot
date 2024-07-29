import 'package:flutter/material.dart';
import 'package:playbot/application/application_providers.dart';
import 'package:playbot/screens/splash.dart';
import 'package:playbot/utilities/util_colors.dart';

class Playbot extends StatefulWidget {
  const Playbot({super.key});

  @override
  State<Playbot> createState() => _PlaybotState();
}

class _PlaybotState extends State<Playbot> {
  @override
  Widget build(BuildContext context) {
    return PlaybotProviders(child:  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: PlayColors.backgroundYellow,
        colorScheme: ColorScheme.fromSeed(seedColor: PlayColors.backgroundYellow),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    ));
  }
}