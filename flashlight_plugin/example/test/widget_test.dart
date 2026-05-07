import 'package:flutter_test/flutter_test.dart';

import 'package:flashlight_plugin_example/main.dart';

void main() {
  testWidgets('example app shows the flashlight controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlashlightExampleApp());
    expect(find.text('Toggle flashlight'), findsOneWidget);
  });
}
