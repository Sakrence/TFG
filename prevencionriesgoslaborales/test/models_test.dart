import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
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
      Inspector inspector =
          Inspector(id: 1, usuario: 'Javi', contrasena: 'javi');
      final data = inspector.toJson();

      expect(data, {"id": 1, "usuario": "Javi", "contrasena": "javi"});
    });
  });

  group('Inspeccion', () {
    test('Inspeccion fromJson', () {
      final data = {
        "id": 1,
        "idInspector": 1,
        "pais": "España",
        "provincia": "Valladolid",
        "latitud": 0.45,
        "longitud": 0.47
      };
      InspeccionModel inspeccion = InspeccionModel.fromJson(data);

      expect(inspeccion is InspeccionModel, true);
    });

    test('Inspeccion toJson', () {
      int time = DateTime.now().millisecondsSinceEpoch;
      InspeccionModel inspeccion = InspeccionModel(
          id: 1,
          fechaInicio: time,
          fechaFin: time,
          direccion: "Eras",
          idInspector: 1,
          pais: "España",
          provincia: "Valladolid",
          latitud: 0.45,
          longitud: 0.45);
      final data = inspeccion.toJson();

      expect(data, {
        "id": 1,
        "fechaInicio": time,
        "fechaFin": time,
        "direccion": "Eras",
        "provincia": "Valladolid",
        "pais": "España",
        "latitud": 0.45,
        "longitud": 0.45,
        "comentarios": null,
        "idInspector": 1
      });
    });
  });

  group('Categorias', () {
    test('Categorias fromJson', () {
      final data = {
        "id": 1,
        "codigo": "01",
        "nombre": "Nombre de prueba",
        "icono": "01",
        "idPadre": null
      };
      CategoriaModel categoria = CategoriaModel.fromJson(data);

      expect(categoria is CategoriaModel, true);
    });

    test('Categoria toJson', () {
      CategoriaModel categoria = CategoriaModel(
        id: 1,
        codigo: "01",
        nombre: "Nombre de prueba",
        icono: "01",
        idPadre: null,
      );
      final data = categoria.toJson();

      expect(data, {
        "id": 1,
        "codigo": "01",
        "nombre": "Nombre de prueba",
        "icono": "01",
        "idPadre": null
      });
    });
  });
  group('FactorRiesgo', () {
    test('FactorRiesgo fromJson', () {
      final data = {
        "id": 1,
        "codigo": "01",
        "nombre": "Nombre de prueba",
        "icono": "01",
        "idPadre": 1
      };
      FactorRiesgoModel factorRiesgo = FactorRiesgoModel.fromJson(data);

      expect(factorRiesgo is FactorRiesgoModel, true);
    });

    test('FactorRiesgo toJson', () {
      FactorRiesgoModel factorRiesgo = FactorRiesgoModel(
        id: 1,
        codigo: "01",
        nombre: "Nombre de prueba",
        icono: "01",
        idPadre: 1,
      );
      final data = factorRiesgo.toJson();

      expect(data, {
        "id": 1,
        "codigo": "01",
        "nombre": "Nombre de prueba",
        "icono": "01",
        "idPadre": 1
      });
    });
  });

  group('Deficiencia', () {
    test('Deficiencia fromJson', () {
      final data = {
        "id": 1,
        "idFactorRiesgo": 1,
        "factorRiesgo": null,
        "evaluacion": null,
        "idInspeccion": 1
      };
      DeficienciaModel deficiencia = DeficienciaModel.fromJson(data);

      expect(deficiencia is DeficienciaModel, true);
    });

    test('Deficiencia toJson', () {
      DeficienciaModel deficiencia = DeficienciaModel(
        id: 1,
        idFactorRiesgo: 1,
        factorRiesgo: null,
        evaluacion: null,
        idInspeccion: 1,
      );
      final data = deficiencia.toJson();

      expect(data, {"id": 1, "idFactorRiesgo": 1, "idInspeccion": 1});
    });
  });
  group('Evaluacion', () {
    test('Evaluacion fromJson', () {
      final data = {
        "id": 1,
        "riesgo": "Desprendimiento",
        "tipoFactor": "Potencial",
        "nivelDeficiencia": 2,
        "nivelExposicion": 1,
        "nivelConsecuencias": 100,
        "fotos": null,
        "accionCorrectora": "Colocar mallas de prevención",
        "coordenadas": null,
        "nivelP": 1,
        "nivelI": "I",
        "nivelRiesgo": 180,
        "idDeficiencia": 1
      };
      EvaluacionModel evaluacion = EvaluacionModel.fromJson(data);

      expect(evaluacion is EvaluacionModel, true);
    });

    test('Evaluacion toJson', () {
      EvaluacionModel evaluacion = EvaluacionModel(
        id: 1,
        riesgo: "Desprendimiento",
        tipoFactor: "Potencial",
        nivelDeficiencia: 2,
        nivelExposicion: 1,
        nivelConsecuencias: 100,
        fotos: null,
        accionCorrectora: "Colocar mallas de prevención",
        coordenadas: null,
        nivelP: 1,
        nivelI: "I",
        nivelRiesgo: 180,
        idDeficiencia: 1,
      );
      final data = evaluacion.toJson();

      expect(data, {
        "id": 1,
        "riesgo": "Desprendimiento",
        "tipoFactor": "Potencial",
        "nivelDeficiencia": 2,
        "nivelExposicion": 1,
        "nivelConsecuencias": 100,
        "accionCorrectora": "Colocar mallas de prevención",
        "nivelP": 1,
        "nivelI": "I",
        "nivelRiesgo": 180,
        "idDeficiencia": 1
      });
    });
  });
}
