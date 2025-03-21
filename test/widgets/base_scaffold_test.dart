// test/widgets/base_scaffold_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:modern_elevator_app/screens/issue_reporting_screen.dart';
import 'package:modern_elevator_app/widgets/base_scaffold.dart';

void main() {
  group('BaseScaffold Widget Tests', () {
    testWidgets('Renders basic scaffold', (WidgetTester tester) async {
      // Build our widget with a dummy body
      await tester.pumpWidget(
        MaterialApp(
          home: BaseScaffold(
            body: Container(), // Empty container for testing
          ),
        ),
      );

      // Verify the scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Navigation items work', (WidgetTester tester) async {
      // Build with currentIndex 0 (Dashboard)
      await tester.pumpWidget(
        MaterialApp(
          home: BaseScaffold(
            body: Container(),
            currentIndex: 0,
          ),
          routes: {
            '/login': (context) => Placeholder(), // Mock login screen
          },
        ),
      );

      // Tap on the "Issue Reporting" tab (index 1)
      await tester.tap(find.byIcon(Icons.report_problem));
      await tester.pumpAndSettle();

      // Verify navigation occurred (you'll need to adjust based on your app)
      expect(find.byType(IssueReportingMaterialRequestScreen), findsOneWidget);
    });
  });
}