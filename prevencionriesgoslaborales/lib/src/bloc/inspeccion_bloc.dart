import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class InspeccionBloc {

  InspeccionBloc() {
    obtenerInspecciones();
    // DBProvider.db.getInspeccionesIdInspector(1);
    // changeInspecciones([]);
    changeInspectores([]);
  }

  final _inspeccionesController = new BehaviorSubject<List<InspeccionModel>>();
  final _inspeccionSeleccionadaController = new BehaviorSubject<InspeccionModel>();
  final _inspectoresController = new BehaviorSubject<List<Inspector>>();


  Stream<List<InspeccionModel>> get inspeccionesStream => _inspeccionesController.stream;
  Stream<InspeccionModel> get inspeccionSeleccionadaStream => _inspeccionSeleccionadaController.stream;
  Stream<List<Inspector>> get inspectoresStream => _inspectoresController.stream;

  Function(List<InspeccionModel>) get changeInspecciones => _inspeccionesController.sink.add;
  Function(InspeccionModel) get changeInspeccionSeleccionada => _inspeccionSeleccionadaController.sink.add;
  Function(List<Inspector>) get changeInspectores => _inspectoresController.sink.add;

  List<Inspector> get inspectores => _inspectoresController.value;
  InspeccionModel get inspeccionSeleccionada => _inspeccionSeleccionadaController.value;


// TODO: añadir funciones para usar el provider de la base de datos a traver del bloc 

  dispose() {
    _inspeccionesController?.close();
    _inspeccionSeleccionadaController?.close();
    _inspectoresController?.close();
  }

  agregarInspeccion( InspeccionModel inspeccion) async {

    // DBProvider.db.nuevaInspeccionRaw(inspeccion);
    inspeccion.fechaInicio = DateTime.now().millisecondsSinceEpoch;
    await DBProvider.db.nuevaInspeccion(inspeccion);
    obtenerInspecciones();
    // DbApi dbApi = DbApi();
    // _factores = dbApi.getFactores (categoria);
    // _inFactores.add (_factores);

    // final List<InspeccionModel> inspecciones = _inspeccionesController.value;


    // inspecciones.add(inspeccion);
    // changeInspecciones(inspecciones);

  }

  eliminarInspeccion( InspeccionModel inspeccion ) async {

    await DBProvider.db.deleteInspeccion(inspeccion.id);

    obtenerInspecciones();

    // final inspecciones = _inspeccionesController.value;
    // inspecciones.remove(inspeccion);
    // changeInspecciones(inspecciones);

  }

  agregarInspector( Inspector inspector) {

    List<Inspector> inspectores = _inspectoresController.value;

    if ( inspectores == null ) inspectores = [];

    inspectores.add(inspector);
    changeInspectores(inspectores);

  }

  eliminarInspectores( InspeccionModel inspector ) {

    final inspectores = _inspectoresController.value;
    inspectores.remove(inspector);
    changeInspectores(inspectores);

  }

  
  obtenerInspecciones() async {
    List<InspeccionModel> list = await DBProvider.db.getInspeccionesIdInspector(1);

    for (var i = 0; i < list.length; i++) {
      list[i].deficiencias = await DBProvider.db.getDeficienciasByIdInspeccion(list[i].id);
      list[i].coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(list[i].id);
      // if ( coordenadas.length != 0 ){
      //   list[i].coordenadas = coordenadas[0];
      // }
    }

    _inspeccionesController.sink.add( list );
  }


}