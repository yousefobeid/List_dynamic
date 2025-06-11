import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:list_dynamic/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Form Integration Test', () {
    testWidgets('Fill Form and Submit', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));
      final chooseScreenButtonView = find.byKey(Key('chooseButton_view'));
      expect(chooseScreenButtonView, findsOneWidget);
      await tester.tap(chooseScreenButtonView);
      await tester.pumpAndSettle();
      final chooseScreenButtonGo = find.byKey(Key('chooseButton_go'));
      expect(chooseScreenButtonGo, findsOneWidget);
      await tester.tap(chooseScreenButtonGo);
      await tester.pumpAndSettle();
      final textFieldFirstName = find.byKey(Key('firstName'));
      expect(textFieldFirstName, findsOneWidget);
      await tester.enterText(textFieldFirstName, 'yousef');
      await tester.pumpAndSettle();

      final textFieldLastName = find.byKey(Key('lastName'));
      expect(textFieldLastName, findsOneWidget);
      await tester.enterText(textFieldLastName, 'obeid');
      await tester.pumpAndSettle();

      final textFieldEmail = find.byKey(Key('email'));
      expect(textFieldEmail, findsOneWidget);
      await tester.enterText(textFieldEmail, 'yousef@example.com');
      await tester.pumpAndSettle();

      final textFieldPhone = find.byKey(Key("phoneNamber"));
      expect(textFieldPhone, findsOneWidget);
      await tester.enterText(textFieldPhone, '0789805712');
      await tester.pumpAndSettle();

      final maleRadio = find.byKey(Key('gendermale'));
      expect(maleRadio, findsOneWidget);
      await tester.tap(maleRadio);
      await tester.pumpAndSettle();

      final religionDropdown = find.byKey(Key('religion'));
      expect(religionDropdown, findsOneWidget);
      await tester.tap(religionDropdown);
      await tester.pumpAndSettle();

      final islamOption = find.text('Islam').last;
      expect(islamOption, findsOneWidget);
      await tester.tap(islamOption);
      await tester.pumpAndSettle();

      final submitButton = find.byKey(Key('submit'));
      expect(submitButton, findsOneWidget);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
    });
  });
}

//flutter drive --driver integration_test/driver.dart --target integration_test/form_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:list_dynamic/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Test form flow', (WidgetTester tester) async {
//     app.main();
//     await tester.pumpAndSettle();

//     // اكتب اختباراتك هنا...
//   });
// }
