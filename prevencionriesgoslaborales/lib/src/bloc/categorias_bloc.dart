import 'dart:async';

import 'package:prevencionriesgoslaborales/src/bloc/bloc_provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';
import 'package:rxdart/rxdart.dart';

class CategoriasBloc extends BlocBase {

  static final CategoriasBloc _singleton = new CategoriasBloc._internal();

  factory CategoriasBloc() {
    return _singleton;
  }

  CategoriasBloc._internal() {
    // Obtener Categorias de la Base de datos
    obtenerCategorias();
  }


  final _categoriasController    = BehaviorSubject<List<CategoriaModel>>();

  // Recuperar los datos del Stream
  Stream<List<CategoriaModel>> get categoriasStream    => _categoriasController.stream;
  

  // Insertar valores al Stream
  Function(List<CategoriaModel>) get changeCategorias    => _categoriasController.sink.add;


  @override
  dispose() {
    _categoriasController?.close();
  }

  obtenerCategorias() async {
    _categoriasController.sink.add( await categoriasProvider.cargarCategorias() );
  }


}