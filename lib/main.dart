import 'package:adivina_el_numero_desafio/data/game_level/advanced.dart';
import 'package:adivina_el_numero_desafio/data/game_level/easy.dart';
import 'package:adivina_el_numero_desafio/data/game_level/extreme.dart';
import 'package:adivina_el_numero_desafio/data/game_level/game_level.dart';
import 'package:adivina_el_numero_desafio/data/game_level/medium.dart';
import 'package:adivina_el_numero_desafio/data/game_result.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el Número'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentNumber = Easy().getRandomNumber();

  var _failedTries = <int>[];

  GameLevel _gameLevel = Easy();

  double _currentSliderValue = 0;

  final _previousGamesResults = <GameResult>[];

  get _failedTriesLessThanCurrent =>
      _failedTries.where((n) => n < _currentNumber);

  get _failedTriesGreaterThanCurrent =>
      _failedTries.where((n) => n > _currentNumber);

  final _formKey = GlobalKey<FormState>();

  void _numberGuessed(value) {
    setState(() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      var numberGuessed = int.parse(value);

      if (numberGuessed != _currentNumber) {
        _failedTries.add(numberGuessed);
        return;
      }

      _previousGamesResults.add(GameResult(
        isWinner: true,
        numberGuessed: numberGuessed,
      ));

      _newGame();
    });
  }

  void _newGame() {
    // TODO verificar si hay efectos al hacer setState 2 veces
    setState(() {
      _failedTries = [];
      _currentNumber = _gameLevel.getRandomNumber();
    });
  }

  void _updateGameLevel(double value) {
    setState(() {
      _currentSliderValue = value;

      switch (value.round()) {
        case 1:
          _gameLevel = Medium();
        case 2:
          _gameLevel = Advanced();
        case 3:
          _gameLevel = Extreme();
        default:
          _gameLevel = Easy();
      }

      _newGame();
    });
  }

  String _getLevelLabel() {
    switch (_gameLevel) {
      case Medium():
        return 'Medio';
      case Advanced():
        return 'Avanzado';
      case Extreme():
        return 'Extremo';
      default:
        return 'Fácil';
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "Adivina número:"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Favor de introducir un número';
                }

                final alphanumeric = RegExp(r'^[0-9]+$');
                if (!alphanumeric.hasMatch(value)) {
                  return 'Se debe introducir un número entero';
                }

                return null;
              },
              onFieldSubmitted: _numberGuessed,
            ),
            Text(
                "Intentos: ${_failedTries.length} de ${_gameLevel.maxTries()}"),
            Card(
              child: Column(
                children: [
                  const Text('Mayor que'),
                  for (var i in _failedTriesGreaterThanCurrent)
                    Text(i.toString()),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('Menor que'),
                  for (var i in _failedTriesLessThanCurrent) Text(i.toString()),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('Historial'),
                  for (var result in _previousGamesResults)
                    Text(
                      '${result.numberGuessed}',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: result.isWinner ? Colors.green : Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            Slider(
              value: _currentSliderValue,
              max: 3,
              divisions: 3,
              label: _getLevelLabel(),
              onChanged: _updateGameLevel,
            ),
          ],
        ),
      ),
    );
  }
}
