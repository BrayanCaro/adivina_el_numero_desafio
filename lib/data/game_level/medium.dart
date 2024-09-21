import 'package:adivina_el_numero_desafio/data/game_level/game_level.dart';

class Medium extends GameLevel {
  @override
  int maxRandomValue() {
    return 20;
  }

  @override
  int maxTries() {
    return 8;
  }

}