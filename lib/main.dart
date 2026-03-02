import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _status = 'Enter a number';
  Color _themeColor = Colors.blue;

  final TextEditingController _controller = TextEditingController();

  void _handleInput() {
    final value = _controller.text;

    setState(() {
      final int? inputNum = int.tryParse(value);

      if (value == 'Vitalik') {
        _counter = 0;
        _status = 'System reset by magic!';
        _themeColor = Colors.blue;
      } else if (inputNum != null) {
        _counter += inputNum;
        _status = 'Added $inputNum to the counter';
        _themeColor = Colors.blue;
      } else if (value.isEmpty) {
        _status = 'Input is empty';
        _themeColor = Colors.red;
      } else {
        _status = '"$value" is not a number or command';
        _themeColor = Colors.red;
      }

      _controller.clear();
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
      _status = 'Counter decreased by 1';
      _themeColor = Colors.blue;
    });
  }

  void _fullReset() {
    setState(() {
      _counter = 0;
      _status = 'Full system reset';
      _themeColor = Colors.blue;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColor.withValues(alpha: 0.2),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: _themeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: _themeColor, width: 2),
                ),
                child: Text(
                  '$_counter',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _themeColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: _themeColor,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  hintText: 'Number or magic command',
                  prefixIcon: Icon(Icons.edit, color: _themeColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _handleInput,
                    child: const Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: _decrement,
                    child: const Text('-1'),
                  ),
                  ElevatedButton(
                    onPressed: _fullReset,
                    child: const Text('Full Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
