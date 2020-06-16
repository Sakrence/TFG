import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:rxdart/rxdart.dart';

class InspeccionBloc {

  InspeccionBloc() {
    changeInspecciones([]);
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

  agregarInspeccion( InspeccionModel inspeccion) {

    final List<InspeccionModel> inspecciones = _inspeccionesController.value;

    inspeccion.fechaInicio = DateTime.now();

    inspecciones.add(inspeccion);
    changeInspecciones(inspecciones);

  }

  agregarInspector( Inspector inspector) {

    List<Inspector> inspectores = _inspectoresController.value;

    if ( inspectores == null ) inspectores = [];

    inspectores.add(inspector);
    changeInspectores(inspectores);

  }


  eliminarInspeccion( InspeccionModel inspeccion ) {

    final inspecciones = _inspeccionesController.value;
    inspecciones.remove(inspeccion);
    changeInspecciones(inspecciones);

  }

  eliminarInspectores( InspeccionModel inspector ) {

    final inspectores = _inspectoresController.value;
    inspectores.remove(inspector);
    changeInspectores(inspectores);

  }


}