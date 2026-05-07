import 'package:flashlight_plugin/flashlight_plugin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashlightExampleApp());
}

class FlashlightExampleApp extends StatefulWidget {
  const FlashlightExampleApp({super.key});

  @override
  State<FlashlightExampleApp> createState() => _FlashlightExampleAppState();
}

class _FlashlightExampleAppState extends State<FlashlightExampleApp> {
  bool _isOn = false;
  String _status = 'Long press the avatar or use the button below.';

  Future<void> _toggle() async {
    try {
      final isOn = await FlashlightPlugin.toggle();
      if (!mounted) return;
      setState(() {
        _isOn = isOn;
        _status = isOn ? 'Flashlight is on' : 'Flashlight is off';
      });
    } on UnsupportedError catch (error) {
      if (!mounted) return;
      setState(() => _status = error.message ?? error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flashlight plugin demo')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_isOn ? Icons.flash_on : Icons.flash_off, size: 72),
              const SizedBox(height: 16),
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _toggle,
                child: const Text('Toggle flashlight'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
