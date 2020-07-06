import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:test/test.dart';

void main() {

  group('Inspector model', () {

    test('inspector fromJson', () {
      final data = {"id": 1, "usuario": "Javi", "contrasena": "javi"};
      Inspector inspector;
      inspector = Inspector.fromJson(data);

      expect(inspector is Inspector, true);
    });

    test('Inspector toJson', () {
      Inspector inspector = Inspector(id: 1, usuario: 'Javi', contrasena: 'javi');
      final data = inspector.toJson();

      expect(data, {"id": 1, "usuario": "Javi", "contrasena": "javi"});
    });

  });

  group('Inspeccion', () {

    test('Inspeccion fromJson', () {
      final data = {"id": 1, "idInspector": 1, "pais": "España", "provincia": "Valladolid", "latitud": 0.45, "longitud": 0.47};
      InspeccionModel inspeccion = InspeccionModel.fromJson(data);

      expect(inspeccion is InspeccionModel, true);
    });

    test('Inspeccion toJson', () {
      InspeccionModel inspeccion = InspeccionModel( id: 1, fechaInicio: DateTime.now().millisecondsSinceEpoch, fechaFin: DateTime.now().millisecondsSinceEpoch, direccion: "Eras",idInspector: 1, pais: "España", provincia: "Valladolid", latitud: 0.45, longitud: 0.45);
      final data = inspeccion.toJson();

      expect(data, {"id": 1, "fechaInicio": DateTime.now().millisecondsSinceEpoch, "fechaFin": DateTime.now().millisecondsSinceEpoch, "direccion": "Eras", "provincia": "Valladolid", "pais": "España",  "latitud": 0.45, "longitud": 0.45, "comentarios": null, "idInspector": 1});
    });

  });

  group('Categorias', () {

    test(' fromJson', () {

    });

    test(' toJson', () {

    });

  });
  group('FactorRiesgo', () {

    test(' fromJson', () {

    });

    test(' toJson', () {

    });

  });
  
  group('Deficiencia', () {

    test(' fromJson', () {

    });

    test(' toJson', () {

    });

  });
  group('Evaluacion', () {

    test(' fromJson', () {

    });

    test(' toJson', () {

    });

  });

}