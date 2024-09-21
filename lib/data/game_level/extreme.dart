import 'package:adivina_el_numero_desafio/data/game_level/game_level.dart';

class Extreme extends GameLevel {
  @override
  int maxRandomValue() {
    return 1000;
  }

  @override
  int maxTries() {
    return 25;
  }

}