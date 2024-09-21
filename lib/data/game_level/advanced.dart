import 'package:adivina_el_numero_desafio/data/game_level/game_level.dart';

class Advanced extends GameLevel {
  @override
  int maxRandomValue() {
    return 100;
  }

  @override
  int maxTries() {
    return 15;
  }
}