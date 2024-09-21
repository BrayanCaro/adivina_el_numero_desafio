import 'dart:math';

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
  // https://api.dart.dev/stable/3.5.3/dart-math/Random-class.html
  // Entero de [1, 21)
  int _currentNumber = Random(32).nextInt(20) + 1;

  var _failedTries = <int>[];

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
      _currentNumber = _getRandomNumber();
    });
  }

  int _getRandomNumber() {
    return Random(32).nextInt(20) + 1;
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
            Text("Intentos: ${_failedTries.length}"),
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
          ],
        ),
      ),
    );
  }
}
