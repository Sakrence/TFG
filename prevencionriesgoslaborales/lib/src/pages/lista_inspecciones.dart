import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';

class ListaInspeccionPage extends StatefulWidget {
  @override
  _ListaInspeccionPageState createState() => _ListaInspeccionPageState();
}

class _ListaInspeccionPageState extends State<ListaInspeccionPage> {
  static final _formKey = GlobalKey<FormState>();
  final _latitudController = TextEditingController(text:'0.0');
  final _longitudController = TextEditingController(text:'0.0');

  @override
  Widget build(BuildContext context) {

    final _inspeccionBloc = Provider.inspeccionBloc(context);

    return Scaffold(
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
                      _mostrarAlertaInspector(context, _inspeccionBloc);
                      // crear informe con las deficiencias
                    },
                    label: Text('Crear Inspector'),
                  ),
                  SizedBox(width: 10.0,),
                  FloatingActionButton.extended(
                    heroTag: UniqueKey(),
                    onPressed: (){
                      _mostrarAlertaInspeccion(context, _inspeccionBloc);
                      // crear informe con las deficiencias
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

// si quiero quitar el boton de evaluar pongo un gesture detector aqui y quito el boton
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

  _crearInforme( InspeccionBloc bloc, inspeccion ) {

  }

  _cerrarInspeccion(  InspeccionBloc bloc, inspeccion  ) {
    
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
          Text(texto, style: TextStyle( color: color)),
        ],
      ),
      onTap: () => callback(bloc, inspeccion), 
    );

      
              

    
  }


  void _mostrarAlertaInspector( BuildContext context, InspeccionBloc bloc) {

    final size = MediaQuery.of(context).size;

    final inspector = Inspector();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 35.0),
            child: Container(
              width: size.width * 0.80,
              // margin: EdgeInsets.symmetric(vertical: 30.0),
              // padding: EdgeInsets.symmetric(vertical: 40.0),
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
                    child: Text('Crear Inspector', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                  ),
                  Material(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            _crearTextNombre(inspector),
                            // _crearTextDNI(inspector),
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
                          bloc.agregarInspector(inspector);
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
            // margin: EdgeInsets.symmetric(vertical: 30.0),
            // padding: EdgeInsets.symmetric(vertical: 40.0),
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
                          _crearTextFieldProvincia(inspeccion),
                          _crearTextFieldPais(inspeccion),
                          _crearFieldCoordenadas(inspeccion),
                          _crearTextFieldComentarios(inspeccion),
                          _crearSeleccionInspector(inspeccion, bloc),
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
                        inspeccion.idInspector = 1;
                        if ( !_formKey.currentState.validate() ) return;
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

  Widget _crearTextNombre( Inspector inspector) {

    return TextFormField(
      initialValue: inspector.nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => setState(() {
          inspector.nombre = value;
      }),
      validator: (value) {
        if ( value.length < 2 ) {
          return 'Ingrese más de 2 carácteres';
        } else {
          return null;
        }
      },
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

  Widget _crearTextFieldProvincia( InspeccionModel inspeccion ) {

    return TextFormField(
      initialValue: inspeccion.provincia,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Provincia',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.provincia = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese la provincia donde se va a realizar la inspección';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearTextFieldPais( InspeccionModel inspeccion ) {

    return TextFormField(
      initialValue: inspeccion.pais,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'País',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.pais = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese el país donde se va a realizar la inspección';
        } else {
          return null;
        }
      },
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
      // initialValue: '${inspeccion.coordenadas.latitud}',
      controller: _latitudController,
      // enabled: false,
      decoration: InputDecoration(
        labelText: 'Latitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      onSaved: (value) => _latitudController.text = '${inspeccion.coordenadas.latitud}',
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
      // initialValue: '${inspeccion.coordenadas.longitud}',
      controller: _longitudController,
      // enabled: false,
      decoration: InputDecoration(
        labelText: 'Longitud',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onSaved: (value) => _longitudController.text = '${inspeccion.coordenadas.longitud}',
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
      // validator: (value) {
      //   if ( value.length < 3 ) {
      //     return 'Ingrese un comentario';
      //   } else {
      //     return null;
      //   }
      // },
    );

  }

  Widget _crearSeleccionInspector( InspeccionModel inspeccion, InspeccionBloc bloc ) {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Selección Inspector',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: inspeccion.idInspector,
      onChanged: ( value ) => setState(() {
          inspeccion.idInspector = value;
      }),
      items: bloc.inspectores
        .map<DropdownMenuItem<Inspector>>((Inspector value) {
      return DropdownMenuItem<Inspector>(
        value: value,
        child: (value.nombre) == null ? Text('') : Text(value.nombre),
      );
      }).toList(),
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
      inspeccion.coordenadas.latitud = _locationData.latitude;
      print(_locationData.latitude);
      print(inspeccion.coordenadas.latitud);
      inspeccion.coordenadas.longitud = _locationData.longitude;
      print(_locationData.longitude);
      print(inspeccion.coordenadas.longitud);
    });

    _formKey.currentState.save();

    
  }
}