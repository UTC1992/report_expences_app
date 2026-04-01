import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/app.dart';
import 'package:report_expences_app/core/di/injection_container.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await initDependencies();
  });

  testWidgets('Home shows reports tab by default', (WidgetTester tester) async {
    await tester.pumpWidget(const ReportExpencesApp());
    await tester.pumpAndSettle();
    expect(find.text('Reportes'), findsWidgets);
  });
}
