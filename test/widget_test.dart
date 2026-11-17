import 'package:flutter_test/flutter_test.dart';
import 'package:chili_pedia/main.dart';
import 'package:chili_pedia/state/app_state.dart';

void main() {
  testWidgets('ChiliPedia smoke test - renders splash screen and brand',
      (WidgetTester tester) async {
    final appState = AppState();
    await appState.initialize();

    await tester.pumpWidget(ChiliPediaApp(appState: appState));

    // Verifikasi teks slogan ensiklopedia muncul pada Splash Screen
    expect(
        find.text('Ensiklopedia Hama & Penyakit Cabai'), findsOneWidget);
  });
}
