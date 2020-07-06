



import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:prevencionriesgoslaborales/main.dart';
import 'package:test/test.dart';

void main() {
  test.testWidgets('clickar registrarse abre el dialog', (test.WidgetTester tester) async {

    await tester.pumpWidget(MyApp());
    
    expect(test.find.byKey(Key('registroUsuario')), test.findsNothing);

    await tester.tap(test.find.byKey(Key('Registrarse')));
    await tester.pump();

    expect(test.find.byKey(Key('registroUsuario')), test.findsOneWidget);
  });

  test.testWidgets('clickar olvidar contraseña abre el dialog', (test.WidgetTester tester) async {

    await tester.pumpWidget(MyApp());
    
    expect(test.find.byKey(Key('olvidarDialog')), test.findsNothing);

    await tester.tap(test.find.byKey(Key('Olvidar')));
    await tester.pump();

    expect(test.find.byKey(Key('olvidarDialog')), test.findsOneWidget);
  });

}