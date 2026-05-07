import 'package:mqtt_client/mqtt_server_client.dart';

class MqttBrowserClient extends MqttServerClient {
  MqttBrowserClient.withPort(
    String server,
    String clientIdentifier,
    int port,
  ) : super.withPort(server, clientIdentifier, port);
}
