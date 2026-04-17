import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ParkingSlots {
  const ParkingSlots({required this.free, required this.occupied});

  final int free;
  final int occupied;
}

class MqttService {
  MqttService({
    required this.brokerIp,
    this.tcpPort = 1883,
    this.wsPort = 9001,
    this.wsPath = '/mqtt',
  });

  final String brokerIp;
  final int tcpPort;
  final int wsPort;
  final String wsPath;

  static const _clientId = 'flutter_smartpark';
  static const _slotsTopic = 'esp8266/free_slots';
  static const _alarmTopic = 'esp8266/alarm';
  MqttClient? _client;
  final _slotsController = StreamController<ParkingSlots>.broadcast();
  final _alarmController = StreamController<bool>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<ParkingSlots> get onSlotsChanged => _slotsController.stream;
  Stream<bool> get onAlarm => _alarmController.stream;
  Stream<bool> get onConnectionChanged => _connectionController.stream;
  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<bool> connect() async {
    // Ensure a fresh client and unique ID; some brokers reject duplicate IDs.
    _client?.disconnect();
    final clientId = '$_clientId-${DateTime.now().millisecondsSinceEpoch}';
    _client = _buildClient(clientId);

    final connMsg = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client!.connectionMessage = connMsg;

    try {
      await _client!.connect();
    } catch (e) {
      debugPrint('MQTT connect error: $e');
      _client!.disconnect();
      _connectionController.add(false);
      return false;
    }

    if (!isConnected) {
      final status = _client!.connectionStatus;
      debugPrint(
        'MQTT not connected. state=${status?.state} code=${status?.returnCode}',
      );
      _connectionController.add(false);
      return false;
    }

    _client!.subscribe(_slotsTopic, MqttQos.atMostOnce);
    _client!.subscribe(_alarmTopic, MqttQos.atMostOnce);
    _client!.updates?.listen(_onMessage);
    _connectionController.add(true);
    return true;
  }

  MqttClient _buildClient(String clientId, {String? webPath}) {
    if (kIsWeb) {
      final path = webPath ?? wsPath;
      debugPrint('MQTT transport: websocket (ws://$brokerIp:$wsPort$path)');
      // Use withPort constructor to properly set up WS connection
      final client = MqttBrowserClient.withPort('ws://$brokerIp$path', clientId, wsPort);
      return client
        ..websocketProtocols = const ['mqtt', 'mqttv3.1']
        ..autoReconnect = true
        ..keepAlivePeriod = 20
        ..logging(on: false)
        ..onConnected = _onConnected
        ..onDisconnected = _onDisconnected;
    }

    debugPrint('MQTT transport: tcp ($brokerIp:$tcpPort)');
    return MqttServerClient(brokerIp, clientId)
      ..port = tcpPort
      ..autoReconnect = true
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected;
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final msg in messages) {
      final payload = (msg.payload as MqttPublishMessage).payload.message;
      final raw = MqttPublishPayload.bytesToStringAsString(payload);

      if (msg.topic == _slotsTopic) {
        _handleSlots(raw);
      } else if (msg.topic == _alarmTopic) {
        _alarmController.add(raw == 'PARKING_FULL');
      }
    }
  }

  void _handleSlots(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _slotsController.add(
        ParkingSlots(
          free: json['free_slots'] as int,
          occupied: json['occupied_slots'] as int,
        ),
      );
    } catch (_) {}
  }

  void _onConnected() {
    debugPrint('MQTT connected');
    _connectionController.add(true);
  }

  void _onDisconnected() {
    debugPrint('MQTT disconnected');
    _connectionController.add(false);
    _alarmController.add(false);
  }

  void disconnect() {
    _client?.disconnect();
    _connectionController.add(false);
  }
}
