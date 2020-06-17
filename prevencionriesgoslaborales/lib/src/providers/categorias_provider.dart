import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';

class _Provider {

  List<CategoriaModel> categorias = [];
  List<FactorRiesgoModel> factores = [];

  _Provider();

  Future<List<CategoriaModel>>  cargarCategorias() async {

    final respuesta = await rootBundle.loadString('data/categorias.json');
    
    Map dataMap = json.decode(respuesta);
    
    for (var i = 0; i < dataMap['categorias'].length; i++) {
      categorias.add(CategoriaModel.fromJson(dataMap['categorias'][i])); 
    }
    
    return categorias;
  }

  Future<List<FactorRiesgoModel>>  cargarSubcategorias(CategoriaModel categoriaSeleccionada) async {

    final respuesta = await rootBundle.loadString('data/subcategorias.json');
    factores = [];
    Map dataMap = json.decode(respuesta); 
    
    for (var i = 0; i < dataMap['subcategorias'].length; i++) {
      factores.add(FactorRiesgoModel.fromJson(dataMap['subcategorias'][i]));
    }
    
    return factores;
  }

  Future<List<InspeccionModel>> cargarInspecciones() async {
    return null;
  }


}

final provider = new _Provider();