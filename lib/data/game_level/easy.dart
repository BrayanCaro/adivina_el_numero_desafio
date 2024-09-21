import 'package:adivina_el_numero_desafio/data/game_level/game_level.dart';

class Easy extends GameLevel {
  @override
  int maxTries() {
    return 5;
  }
  
  @override
  int maxRandomValue() {
    return 10;
  }
}