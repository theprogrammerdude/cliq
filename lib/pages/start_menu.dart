import 'package:cliq/local.dart';
import 'package:cliq/pages/game.dart';
import 'package:cliq/pages/settings.dart';
import 'package:cliq/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:velocity_x/velocity_x.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  final Local _local = Local();

  quit() {
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      blur: 3,
      title: const Text('Quiting too soon'),
      content: const Text('Are you sure to quit cliq'),
      actions: [
        TextButton(
          child: const Text('QUIT'),
          onPressed: () => SystemNavigator.pop(),
        ),
        TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context)),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/mario_coin.png',
                height: 250,
              ),
              'MARIO CLIQ'.text.headline5(context).make(),
              'an idle increamental game made using flutter, entirely out of dart'
                  .text
                  .gray500
                  .center
                  .make()
                  .pOnly(bottom: 50),
              CustomButton(
                onPressed: () => Get.offAll(() => const Game()),
                label: _local.hasGameStarted ? 'RESUME GAME' : 'START GAME',
              ),
              CustomButton(
                onPressed: () => Get.to(() => const Settings()),
                label: 'SETTINGS',
              ),
              CustomButton(
                onPressed: () => quit(),
                label: 'QUIT',
              ),
              'made with ❤️ by theprogrammerdude'.text.make().pSymmetric(v: 30),
            ],
          ).p12(),
        ),
      ),
    );
  }
}
