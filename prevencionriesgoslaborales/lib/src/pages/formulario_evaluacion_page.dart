import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:prevencionriesgoslaborales/src/bloc/evaluaciones_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:prevencionriesgoslaborales/src/widgets/fondoApp.dart';

class FormPage extends StatefulWidget {

  final DeficienciaModel data;

  FormPage({this.data});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  static final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File foto;
  EvaluacionModel evaluacion;
  EvaluacionesBloc evaluacionBloc;
  InspeccionBloc inspeccionBloc;
  DeficienciaModel deficiencia;
  double _valueDeficiencia = 0.0;
  double _valueConsecuencias = 0.0;
  
  TextEditingController _latitudController;
  TextEditingController _longitudController;

  final TextEditingController c1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    evaluacionBloc = Provider.evaluacionesBloc(context);
    inspeccionBloc = Provider.inspeccionBloc(context);
    final DeficienciaModel deficienciaData = ModalRoute.of(context).settings.arguments;

    if ( widget.data != null ) {
      evaluacion = widget.data.evaluacion;
      deficiencia = widget.data;
    } else {
      evaluacion = deficienciaData.evaluacion;
      deficiencia = deficienciaData;
    }

    _actualizarValues();

    _latitudController = TextEditingController(text:'${evaluacion.coordenadas.latitud}');
    _longitudController = TextEditingController(text:'${evaluacion.coordenadas.longitud}');

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          FondoApp(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                _formulario(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _tomarForo,
      ),
    );
  }

  Widget _formulario( BuildContext context ) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Container(
          width: size.width * 0.90,
          margin: EdgeInsets.symmetric(vertical: 30.0),
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
                  )
                ),
                alignment: Alignment.center,
                height: size.height * 0.1,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Text('Evaluación de Riesgo', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    SizedBox(width: 5.0,),
                    IconButton(
                      icon: Icon(Icons.photo_size_select_actual),
                      onPressed: _seleccionarForo,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _tomarForo,
                    )
                  ],
                ),
              ),
              Text(''),
              _crearForm(),
            ],
          ),
        ),
        SizedBox( height: 100.0 ),
      ],
    );

  }

  Widget _crearForm() {

    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _crearTextFieldInfo(),
            _crearTextFieldRiesgo(),
            _crearSeleccion(),
            _crearSliderNDeficiencia(),
            _crearSliderNExposicion(),
            _crearSliderNConsecuencias(),
            _crearFieldCoordenadas(),
            _crearTextFieldAccionCorrectora(),
            _mostrarFoto(),
            _crearBoton(),
          ],
        ),
      ),
    );

  }
  
  Widget _crearTextFieldInfo() {

    return TextFormField(
      initialValue: deficiencia.factorRiesgo.nombre,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Factor de Riesgo',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
    );

  }

  Widget _crearSeleccion() {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Tipo Factor',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: evaluacion.tipoFactor,
      onChanged: ( value ) => evaluacion.tipoFactor = value,
      items: <String>['Potencial', 'Existente']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      }).toList(),
    );

  }

  Widget _crearSliderNDeficiencia() {

    final _size = MediaQuery.of(context).size;

    return  Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Text('Nivel de Deficiencia', style: TextStyle(fontSize: 17),),
          Container(
            width: _size.width * 0.77,
            height: 25,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.7),
                inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Theme.of(context).primaryColor.withOpacity(0.8),
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _valueDeficiencia,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  _valueDeficiencia = value;
                  switch ( value.ceil() ) {
                    case 0:
                      evaluacion.nivelDeficiencia = 0;
                      break;
                    case 1:
                      evaluacion.nivelDeficiencia = 2;
                      break;
                    case 2:
                      evaluacion.nivelDeficiencia = 6;
                      break;
                    case 3:
                      evaluacion.nivelDeficiencia = 10;
                      break;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('0'),
                Text('2'),
                Text('6'),
                Text('10'),
              ],
            ),
          ),
        ],
        
      ),
    );
  }

  Widget _crearSliderNExposicion() {

    final _size = MediaQuery.of(context).size;

    return  Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Text('Nivel de Exposicion', style: TextStyle(fontSize: 17),),
          Container(
            width: _size.width * 0.77,
            height: 25,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.7),
                inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Theme.of(context).primaryColor.withOpacity(0.8),
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: evaluacion.nivelExposicion.ceilToDouble(),
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  setState(
                    () {
                      evaluacion.nivelExposicion = value.ceil();
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('1'),
                Text('2'),
                Text('3'),
                Text('4'),
              ],
            ),
          ),
        ],
        
      ),
    );

  }

  Widget _crearSliderNConsecuencias() {

    final _size = MediaQuery.of(context).size;

    return  Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Text('Nivel Consecuencias', style: TextStyle(fontSize: 17),),
          Container(
            width: _size.width * 0.77,
            height: 25,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.7),
                inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Theme.of(context).primaryColor.withOpacity(0.8),
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _valueConsecuencias,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  _valueConsecuencias = value;
                  switch ( value.ceil() ) {
                    case 0:
                      evaluacion.nivelConsecuencias = 10;
                      break;
                    case 1:
                      evaluacion.nivelConsecuencias = 25;
                      break;
                    case 2:
                      evaluacion.nivelConsecuencias = 60;
                      break;
                    case 3:
                      evaluacion.nivelConsecuencias = 100;
                      break;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('10'),
                Text('25'),
                Text('60'),
                Text('100'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearFieldCoordenadas() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _crearTextFieldLatitud(),
                _crearTextFieldLongitud()
              ],
            ),
          ),
          IconButton(
            iconSize: 30.0,
            icon: Icon(Icons.location_searching),
            color: Theme.of(context).primaryColor,
            onPressed: _getLocation
          ),
        ],
      ),
    );
  }

  Widget _crearTextFieldLatitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _latitudController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Latitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      onSaved: (value) => _latitudController.text = '${evaluacion.coordenadas.latitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag ){
          return null;
        } else {
          return 'Solo números';
        }  
      },
    );
  }

  Widget _crearTextFieldLongitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _longitudController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Longitud',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onSaved: (value) => _longitudController.text = '${evaluacion.coordenadas.longitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag ){
          return null;
        } else {
          return 'Solo numeros';
        }  
      },
    );
  }

  Widget _crearTextFieldRiesgo( ) {

    return TextFormField(
      initialValue: evaluacion.riesgo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Riesgo',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onSaved: (value) => evaluacion.riesgo = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese la descripción del riesgo';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearTextFieldAccionCorrectora() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        maxLines: 3,
        initialValue: evaluacion.accionCorrectora,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Acción Correctora',
          labelStyle: TextStyle(fontSize: 20.0)
        ),
        onChanged: (value) => evaluacion.accionCorrectora = value,
        validator: (value) {
          if ( value.length < 3 ) {
            return 'Ingrese una acción correctora';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearBoton(  ) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Guardar'),
        icon: Icon( Icons.save ),
        onPressed: _submit,
      ),
    );

  }

  void _submit() async {

    if ( !_formKey.currentState.validate() ) return;

    _formKey.currentState.save();

    if ( evaluacion.id != null ) {
      await evaluacionBloc.editarEvaluacion(evaluacion);
    } else {
      await evaluacionBloc.addEvaluacion(evaluacion, deficiencia.id);
    }

    inspeccionBloc.obtenerInspecciones(inspeccionBloc.inspectorSeleccionado.id);    

    mostrarSnackbar('Registro guardado');

    Navigator.pop(context);

  }

  void mostrarSnackbar(String mensaje) {

    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }

  Widget _mostrarFoto( ) {

    if ( evaluacion.fotos != null && evaluacion.fotos.length > 0 ) {
      
      if ( foto != null ) {

        return addFoto();
      }
      
      return fotoCarrusel( evaluacion.fotos );
    
    } else {

      if ( foto != null ) {
      
        return addFoto();
      
      } else {

        return _carruselNoImg();
      }

    }

  }

  Widget addFoto() {

    List<int> imageBytes = foto.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    if ( evaluacion.fotos == null ) {
      List<Foto> lista = List();
      Foto aux = Foto(foto: Base64Decoder().convert(base64Image), idEvaluacion: evaluacion.id);
      lista.add(aux);
      evaluacion.fotos = lista;
    } else {
      evaluacion.fotos.add(Foto(foto: Base64Decoder().convert(base64Image), idEvaluacion: evaluacion.id));
    }
    
    foto = null;
    return fotoCarrusel( evaluacion.fotos );

  }

  _procesarImagen( ImageSource source) async {
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage( source: source );

    foto = File(pickedFile.path);

    setState(() {});

  }

  _seleccionarForo(  ) async {

    _procesarImagen( ImageSource.gallery);

  }
  
  Widget _carruselNoImg() {

    final _screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        height: _screenSize.height * 0.2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
              image: AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
            ),
        ),
      ),
      onTap: _tomarForo,
    );
  }
  
  Widget fotoCarrusel( List<Foto> fotos ) {

    final _pageController = new PageController(
      initialPage: 0,
      viewportFraction: 0.3
    );

    final _screenSize = MediaQuery.of(context).size;


    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: fotos.length,
        itemBuilder: ( context, i ) => _tarjeta(context, fotos[i])
      ),
    );
  }

  Widget _tarjeta( BuildContext context, Foto foto ) {

    return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/original.gif'),
                    image: Image.memory(
                      foto.foto,
                    ).image,
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  height: 40,
                  width: 40,
                  child: Container(
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.red,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Colors.white,
                        onPressed: () async {
                          if ( foto.id != null ){
                            await DBProvider.db.deleteFoto(foto);
                            evaluacion.fotos.remove(foto);
                            setState(() {});
                          } else {
                            evaluacion.fotos.remove(foto);
                            setState(() {});
                          }
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      );

  }


  _tomarForo( ) async {

    _procesarImagen( ImageSource.camera);
  }

  _actualizarValues() {

    switch ( evaluacion.nivelDeficiencia ) {
      case 0:
        _valueDeficiencia = 0;
        break;
      case 2:        
        _valueDeficiencia = 1;
        break;
      case 6:        
        _valueDeficiencia = 2;
        break;
      case 10:        
        _valueDeficiencia = 3;
        break;
    }

    switch ( evaluacion.nivelConsecuencias ) {
      case 10:
        _valueConsecuencias = 0;
        break;
      case 25:        
        _valueConsecuencias = 1;
        break;
      case 60:        
        _valueConsecuencias = 2;
        break;
      case 100:        
        _valueConsecuencias = 3;
        break;
    }

  }

  _getLocation() async {

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
      evaluacion.coordenadas.latitud = _locationData.latitude;
      print(_locationData.latitude);
      print(evaluacion.coordenadas.latitud);
      evaluacion.coordenadas.longitud = _locationData.longitude;
      print(_locationData.longitude);
      print(evaluacion.coordenadas.longitud);
    });

    _formKey.currentState.save();

  }
}