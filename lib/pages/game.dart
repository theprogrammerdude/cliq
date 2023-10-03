import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cliq/classes/characters_list.dart';
import 'package:cliq/classes/mint_list.dart';
import 'package:cliq/classes/multiplier_list.dart';
import 'package:cliq/local.dart';
import 'package:cliq/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Local _local = Local();
  final player = AudioPlayer();

  num coins = 0;
  num mintCoinsPerTap = 1;
  num multiplier = .1;
  num cost = 100;
  num cost1 = 100;

  final formatter = NumberFormat.compact(
    locale: 'en_US',
    explicitSign: false,
  );
  String currentCharacter = 'mario';
  List<dynamic> cccc = []; // Characters list
  List<dynamic> myc = []; // my characters list

  // int resumeTime = 0;
  // int leaveTime = 0;

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);

    coins = _local.coins;
    multiplier = _local.multiplier;
    cost = _local.cost;
    cost1 = _local.cost1;
    currentCharacter = _local.character;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        coins = coins + multiplier;
      });

      _local.saveCoins(coins);
      if (_local.highScore < coins) {
        _local.setHighScore(coins);
      }
    });

    if (!_local.hasGameStarted) {
      _local.setGameStarted();
    }

    if (cccc.isEmpty) {
      _local.loadCharacters(characters);
      cccc = characters;
    } else {
      _local.loadCharacters(cccc);
      cccc = _local.characters;
    }

    super.initState();
  }

  shop() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront_outlined).pOnly(right: 5),
                'SHOP'.text.headline6(context).make(),
              ],
            ).pSymmetric(v: 15),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    multiplierSheet();
                  },
                  leading: const Icon(Icons.close),
                  title: 'BUY MULTIPLIER'.text.make(),
                  subtitle: 'multiplier per second'.text.make(),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    mintSheet();
                  },
                  leading: const Icon(Icons.add),
                  title: 'INCREASE COIN MINT'.text.make(),
                  subtitle: 'coins minted on tap per second'.text.make(),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    characterSheet();
                  },
                  leading: const Icon(Icons.person),
                  title: 'CHARACTERS'.text.make(),
                  subtitle: 'buy new characters'.text.make(),
                ),
              ],
            ),
          ],
        ).p12();
      },
    );
  }

  multiplierSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'INCREASE MULTIPLIER'
                .text
                .headline6(context)
                .make()
                .pSymmetric(v: 15),
            ListView(
              shrinkWrap: true,
              children: multipliers.map((e) {
                return ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    increaseMultiplier(
                      m: e['m'],
                      c: e['m'] * cost1,
                    );
                  },
                  leading: e['leading'].toString().text.make(),
                  title: e['title'].toString().text.make(),
                  subtitle: e['subtitle'].toString().text.make(),
                  dense: true,
                  trailing: cost1 < 10000
                      ? '${e['m'] * cost1} coins'.text.make()
                      : '${formatter.format(e['m'] * cost1)} coins'.text.make(),
                );
              }).toList(),
            ),
          ],
        ).p12();
      },
    );
  }

  mintSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'INCREASE COIN MINT'
                .text
                .headline6(context)
                .make()
                .pSymmetric(v: 15),
            ListView(
              shrinkWrap: true,
              children: mints.map((e) {
                return ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    increaseMintCoinsPerTap(
                      m: e['m'],
                      c: e['m'] * cost,
                    );
                  },
                  dense: true,
                  leading: e['leading'].toString().text.make(),
                  title: e['title'].toString().text.make(),
                  subtitle: e['subtitle'].toString().text.make(),
                  trailing: cost < 10000
                      ? '${e['m'] * cost} coins'.text.make()
                      : '${formatter.format(e['m'] * cost)} coins'.text.make(),
                );
              }).toList(),
            ),
          ],
        ).p12();
      },
    );
  }

  characterSheet() {
    cccc.removeWhere((e) => e['cost'] == 0);
    cccc.sort((a, b) => a['cost'].compareTo(b['cost']));

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'BUY NEW CHARACTERS'
                  .text
                  .headline6(context)
                  .make()
                  .pSymmetric(v: 15),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: cccc.map((e) {
                  return ListTile(
                    onTap: e['unlocked']
                        ? () {
                            Navigator.pop(context);
                            VxToast.show(
                              context,
                              msg: 'Character already unlocked',
                            );
                          }
                        : () {
                            Navigator.pop(context);
                            buyCharacter(name: e['name'], c: e['cost']);
                          },
                    enabled: e['cost'] <= coins ?? !e['unlocked'],
                    leading: Image.asset(e['img']).cornerRadius(50),
                    title: e['name'].toString().text.uppercase.make(),
                    dense: true,
                    subtitle: e['desc'].toString().text.make(),
                    trailing:
                        '${formatter.format(e['cost'])} coins'.text.make(),
                  );
                }).toList(),
              ),
            ],
          ).p12(),
        );
      },
    );
  }

  myCharacters() {
    myc = [];

    for (var element in cccc) {
      if (element['unlocked'] == true) {
        myc.add(element);
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'MY CHARACTERS'.text.headline6(context).make().pSymmetric(v: 15),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: myc.map((e) {
                  return ListTile(
                    onTap: () {},
                    leading: Image.asset(e['img']).cornerRadius(50),
                    title: e['name'].toString().text.uppercase.make(),
                    dense: true,
                    subtitle: e['desc'].toString().text.make(),
                    trailing:
                        '${formatter.format(e['cost'])} coins'.text.make(),
                  );
                }).toList(),
              ),
            ],
          ).p12(),
        );
      },
    );
  }

  increaseMintCoinsPerTap({required int m, required num c}) {
    if (coins >= c) {
      setState(() {
        coins = coins - c;
        mintCoinsPerTap = mintCoinsPerTap * m;
        cost = cost * 1.5;
      });

      _local.saveCost(cost);
      VxToast.show(context, msg: '${m}x coins will mint per click');
    } else {
      VxToast.show(context, msg: 'NOT ENOUGH COINS');
    }
  }

  increaseMultiplier({required int m, required num c}) {
    if (coins >= c) {
      setState(() {
        coins = coins - c;
        multiplier = multiplier * m;
        cost1 = cost1 * 1.5;
      });

      _local.saveMultiplier(multiplier);
      _local.saveCost1(cost1);
      VxToast.show(context, msg: 'multiplier increased by $m times');
    } else {
      VxToast.show(context, msg: 'NOT ENOUGH COINS');
    }
  }

  buyCharacter({required String name, required num c}) {
    if (coins >= c) {
      setState(() {
        coins = coins - c;
        currentCharacter = name;
      });

      _local.setCharacter(currentCharacter);

      List<Map<String, dynamic>> ch = [];
      for (var element in cccc) {
        if (element['name'] == currentCharacter) {
          element['unlocked'] = true;
        }

        ch.add(element);
      }
      _local.loadCharacters(ch);

      VxToast.show(context, msg: 'new character unlocked');
    } else {
      VxToast.show(context, msg: 'NOT ENOUGH COINS');
    }
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state != AppLifecycleState.resumed) {
  //     setState(() {
  //       leaveTime = DateTime.now().millisecondsSinceEpoch;
  //       resumeTime = 0;
  //     });
  //   } else {
  //     setState(() {
  //       resumeTime = DateTime.now().millisecondsSinceEpoch;
  //     });
  //   }

  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => shop(),
            icon: const Icon(Icons.storefront_outlined),
          ),
          IconButton(
            onPressed: () => Get.to(() => const Settings()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => myCharacters(),
            icon: Image.asset(
              'assets/characters/mario.jpg',
              height: 30,
            ).cornerRadius(25),
          ),
          Row(
            children: [
              'HIGH SCORE -'.text.make().pOnly(right: 5),
              formatter.format(_local.highScore).text.make(),
            ],
          ),
        ],
      ).px8().py4(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            'x$multiplier/sec'.text.headline6(context).make(),
            Image.asset(
              'assets/characters/$currentCharacter.jpg',
              height: 200,
            ).cornerRadius(100).pSymmetric(v: 25),
            coins < 10000
                ? 'COINS - ${coins.toStringAsFixed(1)}'
                    .text
                    .center
                    .headline4(context)
                    .make()
                    .pOnly(bottom: 20)
                : 'COINS - ${formatter.format(coins)}'
                    .text
                    .center
                    .headline4(context)
                    .make()
                    .pOnly(bottom: 20),
            ElevatedButton(
              onPressed: () {
                player.play(AssetSource('audio/click.wav'));

                setState(() {
                  coins = coins + mintCoinsPerTap;
                });
              },
              child: mintCoinsPerTap < 10000
                  ? 'mint coins +$mintCoinsPerTap'.text.uppercase.make()
                  : 'mint coins +${formatter.format(mintCoinsPerTap)}'
                      .text
                      .uppercase
                      .make(),
            ),
          ],
        ).p12(),
      ),
    );
  }
}
