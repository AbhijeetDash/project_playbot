import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playbot/screens/connect.dart';
import 'package:playbot/utilities/util_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToConnect() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ConnectScreen()));
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      // Allow it all the time. I'm the only user now.
      Permission.bluetoothScan.request().then((val) {
        Permission.bluetoothConnect.request().then((onValue) {
          _navigateToConnect();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 180.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: AspectRatio(
                aspectRatio: 0.9,
                child: Image.asset(PlayAssets.robot),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                      child: const Text(
                        "PLAYBOT",
                        style: TextStyle(
                            letterSpacing: 12.0,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 150,
                height: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.black),
                child: const Text(
                  "CARDS",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 12.0,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
