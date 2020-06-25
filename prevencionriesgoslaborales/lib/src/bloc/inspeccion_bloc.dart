import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class InspeccionBloc {

  InspeccionBloc() {
    obtenerInspecciones(1);
    changeInspectores([]);
  }

  final _inspeccionesController = new BehaviorSubject<List<InspeccionModel>>();
  final _inspeccionSeleccionadaController = new BehaviorSubject<InspeccionModel>();
  final _inspectoresController = new BehaviorSubject<List<Inspector>>();
  final _inspectorController = new BehaviorSubject<Inspector>();


  Stream<List<InspeccionModel>> get inspeccionesStream => _inspeccionesController.stream;
  Stream<InspeccionModel> get inspeccionSeleccionadaStream => _inspeccionSeleccionadaController.stream;
  Stream<List<Inspector>> get inspectoresStream => _inspectoresController.stream;
  Stream<Inspector> get inspectorSeleccionadoStream => _inspectorController.stream;

  Function(List<InspeccionModel>) get changeInspecciones => _inspeccionesController.sink.add;
  Function(InspeccionModel) get changeInspeccionSeleccionada => _inspeccionSeleccionadaController.sink.add;
  Function(List<Inspector>) get changeInspectores => _inspectoresController.sink.add;
  Function(Inspector) get changeInspectorSeleccionado => _inspectorController.sink.add;

  List<Inspector> get inspectores => _inspectoresController.value;
  Inspector get inspectorSeleccionado => _inspectorController.value;
  InspeccionModel get inspeccionSeleccionada => _inspeccionSeleccionadaController.value;


// TODO: añadir funciones para usar el provider de la base de datos a traver del bloc 

  dispose() {
    _inspeccionesController?.close();
    _inspeccionSeleccionadaController?.close();
    _inspectoresController?.close();
    _inspectorController?.close();
  }

  agregarInspeccion( InspeccionModel inspeccion) async {

    inspeccion.fechaInicio = DateTime.now().millisecondsSinceEpoch;
    await DBProvider.db.nuevaInspeccion(inspeccion);
    obtenerInspecciones(inspeccion.idInspector);
  }

  eliminarInspeccion( InspeccionModel inspeccion ) async {

    await DBProvider.db.deleteInspeccion(inspeccion.id);
    obtenerInspecciones(inspeccion.idInspector);
  }

  obtenerInspecciones( int inspectorId) async {
    List<InspeccionModel> list = await DBProvider.db.getInspeccionesIdInspector(inspectorId);

    for (var i = 0; i < list.length; i++) {
      list[i].deficiencias = await DBProvider.db.getDeficienciasByIdInspeccion(list[i].id);
      for (var j = 0; j < list[i].deficiencias.length; j++) {
        list[i].deficiencias[j].factorRiesgo = await DBProvider.db.getFactorById(list[i].deficiencias[j].idFactorRiesgo);
        list[i].deficiencias[j].evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(list[i].deficiencias[j].id);
        list[i].deficiencias[j].evaluacion.fotos = await DBProvider.db.getFotoByIdEvaluacion(list[i].deficiencias[j].evaluacion.id);
      }
      // Coordenadas coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(list[i].id);
      // list[i].latitud = coordenadas.latitud;
      // list[i].longitud = coordenadas.longitud;
      // if ( coordenadas.length != 0 ){
      //   list[i].coordenadas = coordenadas[0];
      // }
    }

    _inspeccionesController.sink.add( list );
  }

  agregarInspector( Inspector inspector) async {

    await DBProvider.db.nuevoInspector(inspector);
    
    // obtenerInspectores();

  }

  eliminarInspector( Inspector inspector ) async {

    await DBProvider.db.deleteInspector(inspector.id);

    final inspectores = _inspectoresController.value;
    inspectores.remove(inspector);
    changeInspectores(inspectores);
  }

  Future<Inspector> getLogin( String usuario, String contrasena ) async {

    return await DBProvider.db.getLogin(usuario, contrasena);
  }

  obtenerInspectores() async {

    List<Inspector> list = await DBProvider.db.getAllInspectores();
    _inspectoresController.sink.add( list );
  }

  



}