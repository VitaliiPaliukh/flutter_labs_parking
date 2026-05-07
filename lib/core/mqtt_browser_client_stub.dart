import 'package:mqtt_client/mqtt_server_client.dart';

class MqttBrowserClient extends MqttServerClient {
  MqttBrowserClient.withPort(
    super.server,
    super.clientIdentifier,
    super.port,
  ) : super.withPort();
}
