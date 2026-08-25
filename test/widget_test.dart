import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omni_solve_ai/main.dart';

void main() {
  testWidgets('OmniSolveApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OmniSolveApp(),
      ),
    );

    expect(find.text('OmniSolve AI'), findsNothing); // Title is in MaterialApp
  });
}
