import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';

class _CategoriasProvider {

  List<Categoria> categorias = [];

  _CategoriasProvider();

  Future<List<Categoria>>  cargarCategorias() async {

    final respuesta = await rootBundle.loadString('data/categorias.json');
    
    Map dataMap = json.decode(respuesta);
    
    for (var i = 0; i < dataMap['categorias'].length; i++) {
      categorias.add(Categoria.fromJson(dataMap['categorias'][i])); 
    }
    
    return categorias;
  }

  Future<List<Categoria>>  cargarSubcategorias(Categoria categoriaSeleccionada) async {

    final respuesta = await rootBundle.loadString('data/subcategorias.json');
    categorias = [];
    Map dataMap = json.decode(respuesta); 
    
    for (var i = 0; i < dataMap['subcategorias']['${categoriaSeleccionada.id}'].length; i++) {
      categorias.add(Categoria.fromJson(dataMap['subcategorias']['${categoriaSeleccionada.id}'][i]));
    }
    
    return categorias;
  }


}

final categoriasProvider = new _CategoriasProvider();