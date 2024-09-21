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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _currentNumber = 0;

  int _triesCount = 0;

  final _formKey = GlobalKey<FormState>();

  void _numberGuessed(value) {
    setState(() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _triesCount++;
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
                // TODO validar con regrex el string
                if (value == '111') {
                  return 'El valor debe ser un entero';
                }
              },
              onFieldSubmitted: _numberGuessed,
            ),
            Text("Intentos: $_triesCount"),
            const Card(
              child: Column(
                children: [
                  Text('Mayor que'),
                  Text('1'),
                  Text('2'),
                ],
              ),
            ),
            const Card(
              child: Column(
                children: [
                  Text('Mayor que'),
                  Text('1'),
                  Text('2'),
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
