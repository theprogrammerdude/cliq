import 'package:get_storage/get_storage.dart';

class Local {
  static final box = GetStorage();

  Future setGameStarted() async {
    return await box.write('hasGameStarted', true);
  }

  Future saveCoins(num coins) async {
    return await box.write('coins', coins);
  }

  Future saveMultiplier(num multiplier) async {
    return await box.write('multiplier', multiplier);
  }

  Future saveCost(num cost) async {
    return await box.write('cost', cost);
  }

  Future saveCost1(num cost1) async {
    return await box.write('cost1', cost1);
  }

  Future setIsMute(bool isMute) async {
    return await box.write('isMute', isMute);
  }

  Future setHighScore(num highScore) async {
    return await box.write('highScore', highScore);
  }

  Future setCharacter(String character) async {
    return await box.write('character', character);
  }

  Future loadCharacters(List<dynamic> c) async {
    return await box.write('characters', c);
  }

  num get coins => box.read('coins') ?? 0;
  num get multiplier => box.read('multiplier') ?? .1;
  num get cost => box.read('cost') ?? 100;
  num get cost1 => box.read('cost1') ?? 100;
  bool get isMute => box.read('isMute') ?? false;
  bool get hasGameStarted => box.read('hasGameStarted') ?? false;
  num get highScore => box.read('highScore') ?? 0;
  String get character => box.read('character') ?? 'mario';
  List<dynamic> get characters => box.read('characters') ?? [];
  List<List<Map<String, dynamic>>> get achievements =>
      box.read('achievements') ?? [];

  Future get clean => box.erase();
}
