import 'package:flutter_test/flutter_test.dart';
import 'package:sih/main.dart';

void main() {
  testWidgets('SatQuery AI app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SatQueryAI());

    expect(find.text('SatQuery AI'), findsOneWidget);
  });
}