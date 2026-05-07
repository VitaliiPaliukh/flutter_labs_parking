import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flashlight_plugin_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('example app shows the flashlight button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlashlightExampleApp());
    expect(find.text('Toggle flashlight'), findsOneWidget);
  });
}
