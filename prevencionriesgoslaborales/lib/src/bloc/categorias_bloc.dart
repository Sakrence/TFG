import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';
import 'package:rxdart/rxdart.dart';

class CategoriasBloc {

  static final CategoriasBloc _singleton = new CategoriasBloc._internal();

  factory CategoriasBloc() {
    return _singleton;
  }

  CategoriasBloc._internal() {
    // Obtener Categorias de la Base de datos
    obtenerCategorias();
    _categoriaSeleccionadaController.listen((value) {
      obtenerSubcategorias();
     });
  }


  final _categoriasController    = BehaviorSubject<List<Categoria>>();
  final _subcategoriasController    = BehaviorSubject<List<Categoria>>();
  final _categoriaSeleccionadaController    = BehaviorSubject<Categoria>();

  // Recuperar los datos del Stream
  Stream<List<Categoria>> get categoriasStream    => _categoriasController.stream;
  Stream<List<Categoria>> get subcategoriasStream    => _subcategoriasController.stream;
  Stream<Categoria> get categoriaSeleccionadaStream    => _categoriaSeleccionadaController.stream;
  

  // Insertar valores al Stream
  Function(List<Categoria>) get changeCategorias    => _categoriasController.sink.add;
  Function(List<Categoria>) get changeSubcategorias    => _subcategoriasController.sink.add;
  Function(Categoria) get changeCategoriaSeleccionada    => _categoriaSeleccionadaController.sink.add;

  // Obtener el último valor ingresado a los streams
  List<Categoria> get subcategorias => _subcategoriasController.value;
  Categoria get seleccionada => _categoriaSeleccionadaController.value;


  dispose() {
    _categoriasController?.close();
    _subcategoriasController?.close();
    _categoriaSeleccionadaController?.close();
  }

  obtenerCategorias() async {
    _categoriasController.sink.add( await categoriasProvider.cargarCategorias() );
  }

  obtenerSubcategorias() async {
    // print("ID_Seleccionado: ${_categoriaSeleccionadaController.value.id}");
    _subcategoriasController.sink.add( await categoriasProvider.cargarSubcategorias(seleccionada) );
    // print("INDEX 7 de subcategorias: ${_subcategoriasController.value[0]}");
  }


}