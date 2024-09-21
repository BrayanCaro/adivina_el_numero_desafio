import 'dart:math';

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

  int _triesCount = 0;

  final _failedTries = <int>[];

  final _formKey = GlobalKey<FormState>();

  void _numberGuessed(value) {
    setState(() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      var numberGuessed = int.parse(value);

      if (numberGuessed != _currentNumber) {
        _triesCount++;
        _failedTries.add(numberGuessed);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text("Intentos: $_triesCount"),
            Card(
              child: Column(
                children: [
                  const Text('Mayor que'),
                  // TODO usar valor calculado greaterThan
                  for (var i in _failedTries) Text(i.toString()),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('Mayor que'),
                  // TODO usar valor calculado lessThan
                  for (var i in _failedTries) Text(i.toString()),
                ],
              ),
            ),
            const Card(
              child: Column(
                children: [
                  Text('Historial'),
                  Text('1'),
                  Text('2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
