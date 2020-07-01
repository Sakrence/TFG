import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:location/location.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';


class ListaInspeccionPage extends StatefulWidget {
  @override
  _ListaInspeccionPageState createState() => _ListaInspeccionPageState();
}

class _ListaInspeccionPageState extends State<ListaInspeccionPage> {
  static final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _latitudController = TextEditingController(text:'0.0');
  final _longitudController = TextEditingController(text:'0.0');

  @override
  Widget build(BuildContext context) {

    final _inspeccionBloc = Provider.inspeccionBloc(context);
    _inspeccionBloc.obtenerInspecciones(_inspeccionBloc.inspectorSeleccionado.id);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _fondoApp(),
          SafeArea(
            child: StreamBuilder(
              stream: _inspeccionBloc.inspeccionesStream,
              builder: ( context, AsyncSnapshot<List<InspeccionModel>> snapshot) {

                if ( !snapshot.hasData ){

                  return Center(child: Text('No hay datos', style: TextStyle(decoration: TextDecoration.none, fontSize: 16.0, color: Colors.white)));

                } else {

                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: ( context, index)  => Dismissible(
                      key: UniqueKey(),
                      background: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.delete),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 200.0,
                                spreadRadius: 0.5,
                                offset: Offset(-8.0, 10.0)
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withOpacity(0.6),
                                Colors.grey
                              ]
                            ),
                          ),
                        ),
                      ),
                      onDismissed: ( direction ) => { _inspeccionBloc.eliminarInspeccion( snapshot.data[index] ) },
                      child: _tarjeta(context, _inspeccionBloc, snapshot.data[index]),
                    ),
                  );

                } 
              }
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: UniqueKey(),
                    onPressed: (){
                      _mostrarAlertaInspeccion(context, _inspeccionBloc);
                    },
                    label: Text('Iniciar Inspeccion'),
                  ),
                ],
                
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _fondoApp() {

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0)
          ],
        )
      ),
    );

    final cajaRosa = Transform.rotate(
      angle: -pi / 5.2,
      child: Container(
        height: 350.0,
        width: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(85.0),
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent,
              Colors.blueAccent
            ]
          ),
        ),
      ),
    );
    

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: -100,
          child: cajaRosa
        ),
      ],
    );
  }

  Widget _tarjeta( BuildContext context, InspeccionBloc bloc, InspeccionModel inspeccion ) {

    return Container(
      height: 70.0,
      margin: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(-8.0, 10.0)
          )
        ],
      ),
      child: Card(
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
              _texto(inspeccion),
              // _botonInspeccionar(context, bloc, inspeccion),
              _acciones(bloc, inspeccion),
          ],
        ),
      ),
    );

  }

  Widget _texto( InspeccionModel inspeccion ) {

    return Container(
      width: 150,
      child: Text(
        inspeccion.direccion,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
      ),
    );

  }

  _inspeccionar( InspeccionBloc bloc, inspeccion ){
    bloc.changeInspeccionSeleccionada(inspeccion);
    Navigator.pushNamed(context, 'categorias', arguments: inspeccion);
  }

  _crearInforme( InspeccionBloc bloc, InspeccionModel inspeccion ) async {
    
    if (await permission.Permission.storage.request().isGranted) {

      Map<String, List<DeficienciaModel>> riesgosAgrupados = _agruparRiesgos(inspeccion);

      List<String> linea;
      List<List<String>> datos = [];
      int index = 0;
      String tipoFactor;

      riesgosAgrupados.forEach((riesgo, deficiencias) {
        for (var i = 0; i < deficiencias.length; i++) {
          
          if ( deficiencias[i].evaluacion.tipoFactor == "Potencial" ) {
            tipoFactor = 'P';
          } else {
            tipoFactor = 'E';
          }

          if ( i == (deficiencias.length % 2) || deficiencias.length == 1 ) {
            linea = ["0${index+1}", "0${index+1}", "($tipoFactor)${deficiencias[i].evaluacion.riesgo}", "", "", "$riesgo", "", "", "${_maxND(deficiencias)}", "${_maxNE(deficiencias)}", "${_calculoNP(deficiencias)}", "${_maxNC(deficiencias)}", "${_calculoNR(deficiencias)}", "${_calculoNI(deficiencias)}"];
            index++;
          } else {
            linea = ["", "", "($tipoFactor)${deficiencias[i].evaluacion.riesgo}", "", "", "", "", "", "", "", "", "", "", ""];
          }

          datos.add(linea);
          
        }
      });

      List<List<dynamic>> csvData = [
        <String>["Inspeccion","Pais", "Provincia", "Dirección", "Latitud", "Longitud"],
        [inspeccion.id, inspeccion.pais, inspeccion.provincia, inspeccion.direccion, inspeccion.latitud, inspeccion.longitud],
        [],
        <String>["FACTORES"],
        <String>["Código", "Nombre"], 
        ...inspeccion.deficiencias.map((item) => 
                [item.factorRiesgo.idPadre.toString()+item.factorRiesgo.codigo,
                item.factorRiesgo.nombre]),
        [],
        <String>["", "", "", "", "", "", "", "", "", "", "EVALUACIÓN"],
        <String>["", "", "FACTOR RIESGO", "", "", "", "RIESGO", "", "", "PROBABILIDAD"],
        <String>["Nº", "ID", "FACTOR(POTENCIAL (P)/ EXISTENTE(E))", "", "", "", "RIESGO", "", "ND", "NE", "NP", "NC", "NR", "NI"],
        ...datos
      ];

      String csv = ListToCsvConverter(fieldDelimiter: ';').convert(csvData);

      Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      final String path = '${downloadsDirectory.path}/lugar_inspeccion${inspeccion.id}.csv';
      final File file = File(path);

      await file.writeAsString(csv, mode: FileMode.write);

      _showSnackBar('Se ha creado el archivo CSV en su tarjeta SD -> Download');
      
    }
  }

  Map<String, List<DeficienciaModel>> _agruparRiesgos( InspeccionModel inspeccion ) {
    
    List<DeficienciaModel> deficiencias = List();

    Map<String, List<DeficienciaModel>> mapa = Map<String, List<DeficienciaModel>>();

    inspeccion.deficiencias.forEach((item) => {
      
      if ( item.evaluacion != null ) {

        if( mapa.containsKey(item.factorRiesgo.nombre) ) {
          mapa.update(item.factorRiesgo.nombre, (value) {
            value.add(item);
            return value;
          })
        } else {
          deficiencias = [],
          deficiencias.add(item),
          mapa[item.factorRiesgo.nombre] = deficiencias
        }
      }
    });
    return mapa;
  }

  int _maxND( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;

    deficiencias.forEach((element) {
      if ( element.evaluacion.nivelDeficiencia > max ) max = element.evaluacion.nivelDeficiencia; 
    });

    return max;
  }

  int _maxNE( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;

    deficiencias.forEach((element) {
      if ( element.evaluacion.nivelExposicion > max ) max = element.evaluacion.nivelExposicion; 
    });

    return max;
  }

  int _calculoNP( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;
    return max;
  }

  int _maxNC( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;

    deficiencias.forEach((element) {
      if ( element.evaluacion.nivelConsecuencias > max ) max = element.evaluacion.nivelConsecuencias; 
    });

    return max;
  }

  int _calculoNR( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;
    return max;
  }

  int _calculoNI( List<DeficienciaModel> deficiencias ) {
    
    int max = 0;
    return max;
  }

  _cerrarInspeccion(  InspeccionBloc bloc, InspeccionModel inspeccion  ) {
    
  }

  _acciones( InspeccionBloc bloc, InspeccionModel inspeccion ) {

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _crearAcciones(Icons.edit, 'Inspeccionar', Colors.green, _inspeccionar, bloc, inspeccion),
            SizedBox(width: 10.0,),
            _crearAcciones(Icons.insert_drive_file, 'Informe', Colors.blueAccent, _crearInforme, bloc, inspeccion),
            SizedBox(width: 10.0,),
            _crearAcciones(Icons.lock, 'Cerrar', Colors.red, _cerrarInspeccion, bloc, inspeccion),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );

  }

  Widget _crearAcciones(IconData icono, String texto, Color color, Function callback,  InspeccionBloc bloc, InspeccionModel inspeccion) {

      return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: LinearGradient(
                begin: FractionalOffset(-0.93, -0.25),
                end: FractionalOffset.bottomRight,
                colors: [
                  Colors.white,
                  color.withOpacity(1.0)
                ],
              )
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16.0,
              child: Icon( icono, color: Colors.white, size: 20.0 ),
            ),
          ),
          Text(texto, style: TextStyle( color: color, fontSize: 10.0)),
        ],
      ),
      onTap: () => callback(bloc, inspeccion), 
    );
  }

  void _mostrarAlertaInspeccion( BuildContext context, InspeccionBloc bloc) {

    final size = MediaQuery.of(context).size;
    
    final inspeccion = InspeccionModel();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 35.0),
          child: Container(
            width: size.width * 0.80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Container( 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.blue
                      ]
                    ),
                  ),
                  alignment: Alignment.center,
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Text('Crear Inspección', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                ),
                Material(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _crearTextFieldDireccion(inspeccion),
                          _creatSelectPais(inspeccion),
                          _crearSelectProvincia(inspeccion, bloc),
                          _crearFieldCoordenadas(inspeccion),
                          _crearTextFieldComentarios(inspeccion),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        if ( !_formKey.currentState.validate() ) return;
                        inspeccion.idInspector = bloc.inspectorSeleccionado.id;
                        bloc.agregarInspeccion(inspeccion);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        );
      }
    );

  }

  Widget _crearTextFieldDireccion( InspeccionModel inspeccion ) {

    return TextFormField(
      initialValue: inspeccion.direccion,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Direccion',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.direccion = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese la dirección donde se va a realizar la inspección';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearSelectProvincia( InspeccionModel inspeccion, InspeccionBloc bloc) {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Provincia',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: inspeccion.provincia,
      onChanged: ( value ) => inspeccion.provincia = value,
      items: bloc.provincias
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      }).toList(),
    );

  }

  Widget _creatSelectPais( InspeccionModel inspeccion ) {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'País',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: inspeccion.pais,
      onChanged: ( value ) => inspeccion.pais = value,
      items: <String>['España']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      }).toList(),
    );
  }

  Widget _crearFieldCoordenadas( InspeccionModel inspeccion ) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _crearTextFieldLatitud(inspeccion),
                _crearTextFieldLongitud(inspeccion)
              ],
            ),
          ),
          IconButton(
            iconSize: 30.0,
            icon: Icon(Icons.location_searching),
            color: Theme.of(context).primaryColor,
            onPressed: () => _getLocation(inspeccion)
          ),
        ],
      ),
    );
  }

  Widget _crearTextFieldLatitud( InspeccionModel inspeccion ) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _latitudController,
      decoration: InputDecoration(
        labelText: 'Latitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      onSaved: (value) => _latitudController.text = '${inspeccion.latitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag && num.tryParse(value).ceilToDouble() != 0.0){
          return null;
        } else {
          return 'Solo numeros';
        }   
      },
    );
  }

  Widget _crearTextFieldLongitud( InspeccionModel inspeccion ) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _longitudController,
      decoration: InputDecoration(
        labelText: 'Longitud',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onSaved: (value) => _longitudController.text = '${inspeccion.longitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag && num.tryParse(value).ceilToDouble() != 0.0){
          return null;
        } else {
          return 'Solo numeros';
        }  
      },
    );
  }

  Widget _crearTextFieldComentarios( InspeccionModel inspeccion ) {

    return TextFormField(
      maxLines: 3,
      initialValue: inspeccion.comentarios,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Comentarios',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.comentarios = value,
    );

  }

  _getLocation( InspeccionModel inspeccion ) async {

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      inspeccion.latitud = _locationData.latitude;
      inspeccion.longitud = _locationData.longitude;
    });

    _formKey.currentState.save();
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }
}