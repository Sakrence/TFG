import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:prevencionriesgoslaborales/src/bloc/factores_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:prevencionriesgoslaborales/src/pages/formulario_evaluacion_page.dart';
import 'package:prevencionriesgoslaborales/main.dart' as app;
import 'package:prevencionriesgoslaborales/src/pages/home.dart';
import 'package:prevencionriesgoslaborales/src/pages/lista_evaluaciones_page.dart';
import 'package:prevencionriesgoslaborales/src/pages/lista_inspecciones.dart';
import 'package:prevencionriesgoslaborales/src/pages/subcategorias.dart';

void main() {
  enableFlutterDriverExtension();
  
  app.main(); // login_test

  // runApp( // listaInspeccion_test
  //   Provider(
  //     child: MaterialApp(
  //       home: Builder(
  //         builder: (context) {
  //           final inspeccion = InspeccionModel(id: 1, direccion: "Eras", comentarios: null,
  //           fechaFin: DateTime.now().microsecondsSinceEpoch, deficiencias: null, provincia: "Valladolid",
  //           pais: "España", longitud: 0.45, latitud: 0.45, idInspector: 1, fechaInicio: DateTime.now().microsecondsSinceEpoch);
  //           Provider.inspeccionBloc(context).agregarInspeccion(inspeccion);
  //           Provider.inspeccionBloc(context).changeInspecciones([inspeccion]);
  //           Provider.inspeccionBloc(context).changeInspectorSeleccionado(Inspector(id: 1, usuario: "Javi", contrasena: "javi"));
  //           return new ListaInspeccionPage();
  //         }
  //       ),
        // theme: ThemeData(primaryColor: Colors.purple),
  //     ),
  //   ),
  // );

  // runApp( // categoria_test
  //   Provider(
  //     child: MaterialApp(
  //       home: HomePage(),
        // theme: ThemeData(primaryColor: Colors.purple),
  //     ),
  //   ),
  // );

  // runApp( // subcategoria_test
  //   Provider(
  //     child: MaterialApp(
  //       builder: (BuildContext context, __) {
  //         final categoria = CategoriaModel(id: 1, codigo: "01", nombre: "Caídas de personas a distinto nivel", icono: "01",idPadre: null);
  //         FactoresBloc factoresBloc = FactoresBloc(categoria);
  //         List<FactorRiesgoModel> factores = [FactorRiesgoModel(id: 60, codigo: "01", nombre: "Caídas por trabajos en altura", icono: "01", idPadre: 1)];
  //         factoresBloc.changeFactores(factores);
  //         Provider.of(context).factoresBloc = factoresBloc;
  //         final _deficienciasBloc = Provider.deficienciaBloc(context);
  //         _deficienciasBloc.addDeficiencia(factores[0], 1);
  //         final _inspeccionBloc = Provider.inspeccionBloc(context);
  //         _inspeccionBloc.changeInspeccionSeleccionada(InspeccionModel(id: 1, provincia: "Valladolid",
  //         pais: "España", longitud: 0.45, latitud: 0.45, idInspector: 1, fechaInicio: DateTime.now().microsecondsSinceEpoch));
  //         return SubcategoriaPage();
  //       }
  //     ),
        // theme: ThemeData(primaryColor: Colors.purple),
  //   ),
  // );

  // runApp( // listaEvaluacion_test
  //   Provider(
  //     child: MaterialApp(
  //       home: Builder(
  //         builder: (context) {
  //           final categoria = CategoriaModel(id: 1, codigo: "01", nombre: "Caídas de personas a distinto nivel", icono: "01",idPadre: null);
  //           FactoresBloc factoresBloc = FactoresBloc(categoria);
  //           List<FactorRiesgoModel> factores = [FactorRiesgoModel(id: 60, codigo: "01", nombre: "Caídas por trabajos en altura", icono: "01", idPadre: 1)];
  //           factoresBloc.changeFactores(factores);
  //           final _deficienciasBloc = Provider.deficienciaBloc(context);
  //           _deficienciasBloc.changeDeficiencias([DeficienciaModel(id: 1, factorRiesgo: factores[0], idFactorRiesgo: 1, idInspeccion: 1, evaluacion: null )]);
  //           return ListaEvaluacionPage();
  //         }
  //       ),
        // theme: ThemeData(primaryColor: Colors.purple),
  //     ),
  //   ),
  // );

  // runApp( // formulario_test
  //   Provider(
  //     child: MaterialApp(
  //       home: Builder(
  //         builder: (context) {
  //           final categoria = CategoriaModel(id: 1, codigo: "01", nombre: "Caídas de personas a distinto nivel", icono: "01",idPadre: null);
  //           FactoresBloc factoresBloc = FactoresBloc(categoria);
  //           List<FactorRiesgoModel> factores = [FactorRiesgoModel(id: 60, codigo: "01", nombre: "Caídas por trabajos en altura", icono: "01", idPadre: 1)];
  //           factoresBloc.changeFactores(factores);
  //           final _deficienciasBloc = Provider.deficienciaBloc(context);
  //           DeficienciaModel deficiencia = DeficienciaModel(id: 1, factorRiesgo: factores[0], idFactorRiesgo: 1, idInspeccion: 1, evaluacion: null );
  //           EvaluacionModel evaluacion = EvaluacionModel(id: 1, idDeficiencia: deficiencia.id, riesgo: 'Caída escalón', nivelDeficiencia: 2,
  //           nivelExposicion: 3, nivelConsecuencias: 60, coordenadas: Coordenadas(latitud: 0.45, longitud: 0.45), fotos: null,
  //           accionCorrectora: 'Poner una barandilla', tipoFactor: 'Existente');
  //           Provider.evaluacionesBloc(context).addEvaluacion(evaluacion, deficiencia.id);
  //           deficiencia.evaluacion = evaluacion;
  //           _deficienciasBloc.changeDeficiencias([deficiencia]);
  //           return FormPage(data: _deficienciasBloc.deficiencias[0]);
  //         }
  //       ),
  //       theme: ThemeData(primaryColor: Colors.purple),
  //     ),
  //   ),
  // );


}
