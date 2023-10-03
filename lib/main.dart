import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cliq/local.dart';
import 'package:cliq/pages/game.dart';
import 'package:cliq/pages/start_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  GetStorage.init();
  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: const MyApp(),
    ),
  );
}

final Local _local = Local();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cliq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        fontFamily: GoogleFonts.audiowide().fontFamily,
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/mario_coin.png',
        backgroundColor: Vx.gray900,
        splashIconSize: 250,
        centered: true,
        screenFunction: () async {
          return _local.hasGameStarted ? const Game() : const StartMenu();
        },
      ),
    );
  }
}
