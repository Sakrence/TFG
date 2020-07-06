import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:prevencionriesgoslaborales/src/bloc/factores_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
// import 'package:prevencionriesgoslaborales/main.dart' as app;
import 'package:prevencionriesgoslaborales/src/pages/home.dart' as app;
import 'package:prevencionriesgoslaborales/src/pages/subcategorias.dart';

void main() {
  enableFlutterDriverExtension();
  
  // app.main(); // login_test

  // runApp( // categoria_test
  //   Provider(
  //     child: MaterialApp(
  //       home: app.HomePage(),
  //     ),
  //   ),
  // );

  runApp( // subcategoria_test
    Provider(
      child: MaterialApp(
        builder: (BuildContext context, __) {
          final categoria = CategoriaModel(id: 1, codigo: "01", nombre: "Caídas de personas a distinto nivel", icono: "01",idPadre: null);
          FactoresBloc factoresBloc = FactoresBloc(categoria);
          List<FactorRiesgoModel> factores = [FactorRiesgoModel(id: 60, codigo: "01", nombre: "Caídas por trabajos en altura", icono: "01", idPadre: 1)];
          factoresBloc.changeFactores(factores);
          Provider.of(context).factoresBloc = factoresBloc;
          final _deficienciasBloc = Provider.deficienciaBloc(context);
          _deficienciasBloc.addDeficiencia(factores[0], 1);
          final _inspeccionBloc = Provider.inspeccionBloc(context);
          _inspeccionBloc.changeInspeccionSeleccionada(InspeccionModel(id: 1, provincia: "Valladolid",
          pais: "España", longitud: 0.45, latitud: 0.45, idInspector: 1, fechaInicio: DateTime.now().microsecondsSinceEpoch));
          return SubcategoriaPage();
        },
        // home: app.HomePage(),
      ),
    ),
  );

}
