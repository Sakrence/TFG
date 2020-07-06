


import 'package:flutter/services.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:test/test.dart' as test;
import 'package:flutter_test/flutter_test.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // expose path_provider
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return ".";
    });
    // expose sqflite
    // const MethodChannel channel1 =
    //     MethodChannel('com.tekartik.sqflite');
    // channel1.setMockMethodCallHandler((MethodCall methodCall) async {
    //   return ".";
    // });
  });

  group('', () {

    test.test('', () async {

      await DBProvider.db.nuevoInspector(Inspector(usuario: "Javi", contrasena: "javi"));
      List<Inspector> inspectores = await DBProvider.db.getAllInspectores();
      expect(inspectores[0], Inspector(id: 1, usuario: "Javi", contrasena: "javi"));

    });

  });

}