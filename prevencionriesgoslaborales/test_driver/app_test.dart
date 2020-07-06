
import 'dart:io';
// import 'dart:js_util';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:test/test.dart';
// import 'package:flutter_test/flutter_test.dart' as test;



void main() {

  group('Login App', () {

    FlutterDriver driver;

    // Conectarse al driver de FLutter antes de ejecutar test
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    }); 

    // Cierra la conexión con el driver después de que se hayan completado los tests
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    

    Future<void> delay([int milliseconds = 250]) async {
      await Future<void>.delayed(Duration(milliseconds: milliseconds));
    }

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('se puede crear un usuario', () async {
      final registrarse = find.byValueKey('Registrarse');
      await driver.tap(registrarse);

      final registroUsuario = find.byValueKey('registroUsuario');
      final registroContrasena = find.byValueKey('registroContrasena');
      final registroOK = find.byValueKey('registroOK');
      final registroCancelar = find.byValueKey('registroCancelar');

      await driver.tap(registroUsuario);
      await driver.enterText('Hello');
      await driver.tap(registroContrasena);
      await driver.enterText('Hello2');

      await driver.waitUntilNoTransientCallbacks();
      expect( find.text('Hello') is ByText, equals(true) );
      expect( find.text('Hello2') is ByText, equals(true) );
      await driver.tap(registroOK);
      await delay(750);
      expect(find.text('Se ha creado el usuario satisfactoriamente') is ByText, equals(true) );
      await driver.tap(registroCancelar);

    });

    test('se puede escribir usuario y contraseña', () async {
      final usuario = find.byValueKey('usuario');
      final contrasena = find.byValueKey('contrasena');
      final boton = find.byValueKey('boton');

      sleep(Duration(seconds: 5));
      await driver.tap(usuario);
      await driver.enterText('Hello');
      await driver.waitFor(usuario);
      await delay(750);
      await driver.waitUntilNoTransientCallbacks();
      await driver.tap(contrasena);
      await driver.enterText('Hello2');
      await driver.waitFor(contrasena);
      await driver.waitUntilNoTransientCallbacks();
      expect( find.text('Hello') is ByText, equals(true) );
      expect( find.text('Hello2') is ByText, equals(true) );
      await driver.tap(boton);
      await delay(750);
      expect(find.text('No existe ese usuario, prueba de nuevo') is ByText, equals(true) );
      await delay(750);
      
    });

  });

  // group('Categorias', () {

  //   FlutterDriver driver;

  //   // Conectarse al driver de FLutter antes de ejecutar test
  //   setUpAll(() async {
  //     driver = await FlutterDriver.connect();
  //   }); 

  //   // Cierra la conexión con el driver después de que se hayan completado los tests
  //   tearDownAll(() async {
  //     if (driver != null) {
  //       driver.close();
  //     }
  //   });

  //   final caidas = find.text('Caídas de personas a distinto nivel');

  //   test('check flutter driver health', () async {
  //     final health = await driver.checkHealth();
  //     expect(health.status, HealthStatus.ok);
  //   });

  //   test('charging buttons', () async {
  //     sleep(Duration(seconds: 5));
  //     // driver.waitFor(caidas);
  //     // expect(find.text('Caídas de personas a distinto nivel') is ByText, equals(true) );
  //     await driver.getText(caidas).then((value) {
  //       expect(value, equals('Caídas de personas a distinto nivel'));
  //     });
  //     sleep(Duration(seconds: 5));

  //   });


  // });


}