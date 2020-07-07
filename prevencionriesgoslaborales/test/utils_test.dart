import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:prevencionriesgoslaborales/src/utils/dataManipulation/dataManipulation.dart';
import 'package:prevencionriesgoslaborales/src/utils/maths/calculated_fields.dart';
import 'package:test/test.dart';

void main() {
  group('maths', () {
    test('calculoNP', () {
      final nivelDeficiencia = 2;
      final nivelExposicion = 3;

      expect(calculoNP(nivelDeficiencia, nivelExposicion), equals(6));
    });

    test('calculoNR', () {
      final nivelConsecuencias = 60;
      final nivelP = 18; // valor posible de NP

      expect(calculoNR(nivelConsecuencias, nivelP), equals(1080));
    });

    test('calculoNR', () {
      final nivelRiesgo = 1080;

      expect(calculoNI(nivelRiesgo), equals('I'));
    });

    List<DeficienciaModel> deficiencias = [];
    final evaluacion = EvaluacionModel(
        riesgo: "Riesgo1",
        nivelDeficiencia: 0,
        nivelExposicion: 1,
        nivelConsecuencias: 10);
    final evaluacion2 = EvaluacionModel(
        riesgo: "Riesgo2",
        nivelDeficiencia: 2,
        nivelExposicion: 2,
        nivelConsecuencias: 25);
    final evaluacion3 = EvaluacionModel(
        riesgo: "Riesgo3",
        nivelDeficiencia: 6,
        nivelExposicion: 3,
        nivelConsecuencias: 60);
    final evaluacion4 = EvaluacionModel(
        riesgo: "Riesgo4",
        nivelDeficiencia: 10,
        nivelExposicion: 4,
        nivelConsecuencias: 100);

    final deficiencia = DeficienciaModel(
        id: 1,
        idInspeccion: 1,
        idFactorRiesgo: 1,
        evaluacion: evaluacion,
        factorRiesgo: FactorRiesgoModel(
            id: 60,
            idPadre: 1,
            icono: "01",
            codigo: "01",
            nombre: "Caídas por trabajos en altura"));
    final deficiencia2 = DeficienciaModel(
        id: 2,
        idInspeccion: 1,
        idFactorRiesgo: 1,
        evaluacion: evaluacion2,
        factorRiesgo: FactorRiesgoModel(
            id: 60,
            idPadre: 1,
            icono: "01",
            codigo: "01",
            nombre: "Caídas por trabajos en altura"));
    final deficiencia3 = DeficienciaModel(
        id: 3,
        idInspeccion: 1,
        idFactorRiesgo: 3,
        evaluacion: evaluacion3,
        factorRiesgo: FactorRiesgoModel(
            id: 65,
            idPadre: 2,
            icono: "06",
            codigo: "02",
            nombre: "Caídas por tropiezo con obstáculo"));
    final deficiencia4 = DeficienciaModel(
        id: 4,
        idInspeccion: 1,
        idFactorRiesgo: 4,
        evaluacion: evaluacion4,
        factorRiesgo: FactorRiesgoModel(
            id: 66,
            idPadre: 3,
            icono: "03",
            codigo: "01",
            nombre: "Desplome de elementos fijos"));

    deficiencias.add(deficiencia);
    deficiencias.add(deficiencia2);
    deficiencias.add(deficiencia3);
    deficiencias.add(deficiencia4);

    test('maxND', () {
      expect(maxND(deficiencias), equals(10));
    });

    test('maxNE', () {
      expect(maxNE(deficiencias), equals(4));
    });

    test('maxNC', () {
      expect(maxNC(deficiencias), equals(100));
    });

    test('agruparRiesgos', () {
      InspeccionModel inspeccion = InspeccionModel(
          id: 1,
          idInspector: 1,
          direccion: "Eras",
          pais: "España",
          provincia: "Valladolid",
          fechaInicio: DateTime.now().millisecondsSinceEpoch,
          fechaFin: DateTime.now().millisecondsSinceEpoch,
          latitud: 0.45,
          longitud: 0.45,
          comentarios: null,
          deficiencias: deficiencias);

      Map<String, List<DeficienciaModel>> mapa = {
        "Caídas por trabajos en altura": [deficiencia, deficiencia2],
        "Caídas por tropiezo con obstáculo": [deficiencia3],
        "Desplome de elementos fijos": [deficiencia4]
      };

      expect(agruparRiesgos(inspeccion), equals(mapa));
    });
  });
}
