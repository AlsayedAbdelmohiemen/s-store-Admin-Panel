import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/app.dart';

void main() {
  testWidgets('AdminApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();
    expect(find.byType(AdminApp), findsOneWidget);
  });
}
