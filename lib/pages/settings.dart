import 'package:cliq/local.dart';
import 'package:cliq/pages/start_menu.dart';
import 'package:cliq/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:velocity_x/velocity_x.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Local _local = Local();

  bool? isMute;

  @override
  void initState() {
    isMute = _local.isMute;
    super.initState();
  }

  reset() {
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      blur: 3,
      title: const Text('Reset the game.'),
      content: const Text(
        'Are you sure you want to reset, you will lose all your progress.',
      ),
      actions: [
        TextButton(
          child: const Text('Yes, I\'m sure.'),
          onPressed: () {
            _local.clean;
            Navigator.pop(context);

            VxToast.show(context, msg: 'Game has been reset');
          },
        ),
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
      ],
    ).show(context);
  }

  quitToMainMenu() {
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      blur: 3,
      title: const Text('Quit to main menu'),
      content: const Text('Are you sure you want to quit the game'),
      actions: [
        TextButton(
          child: const Text('QUIT'),
          onPressed: () => Get.offAll(() => const StartMenu()),
        ),
        TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context)),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    var info = AppInfo.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            'SETTINGS'.text.headline4(context).make(),
            'change game settings from this page'
                .text
                .gray500
                .make()
                .pOnly(bottom: 45),
            CustomIconButton(
              icon: isMute!
                  ? const Icon(Icons.volume_up_rounded)
                  : const Icon(Icons.volume_off_rounded),
              onPressed: () {
                setState(() {
                  isMute = !isMute!;
                });
              },
              label: isMute! ? 'UNMUTE' : 'MUTE',
            ),
            CustomIconButton(
              icon: const Icon(Icons.restore),
              onPressed: () => reset(),
              label: 'RESET',
            ),
            CustomIconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        'CLIQ APP INFO'
                            .text
                            .headline6(context)
                            .make()
                            .pSymmetric(v: 15),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.onetwothree_rounded),
                              title: 'App Version'.text.make(),
                              subtitle: info.package.versionWithoutBuild
                                  .toString()
                                  .text
                                  .make(),
                            ),
                          ],
                        )
                      ],
                    ).p12();
                  },
                );
              },
              label: 'APP INFO',
            ),
            CustomIconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => quitToMainMenu(),
              label: 'QUIT TO MAIN MENU',
            ),
          ],
        ).p12(),
      ),
    );
  }
}
