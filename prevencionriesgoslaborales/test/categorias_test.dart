



import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:prevencionriesgoslaborales/main.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/pages/home.dart';
import 'package:test/test.dart';

void main() {

  test.testWidgets('charging ', (test.WidgetTester tester) async {
    await tester.pumpWidget(
      Provider(
        child: MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    final boton = test.find.text('Caídas de personas a distinto nivel');
    print(boton);

    expect(
      // test.find.byKey(Key('1')),
        test.find.text('Caídas de personas a distinto nivel'),
        test.findsOneWidget);
  });

}
