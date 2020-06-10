import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

// import 'package:prevencionriesgoslaborales/src/bloc/bloc_provider.dart';
// import 'package:prevencionriesgoslaborales/src/bloc/deficiencia_bloc.dart';
// import 'package:prevencionriesgoslaborales/src/bloc/evaluaciones_bloc.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';

class FormPage extends StatefulWidget {

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DeficienciaModel deficiencia = new DeficienciaModel();

  // String _dropValue = 'Potencial';
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final DeficienciaModel deficienciaData = ModalRoute.of(context).settings.arguments;
    if ( deficienciaData != null ) {
      deficiencia = deficienciaData;
    }

    // final _deficienciasBloc = BlocProvider.of<DeficienciaBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _fondoApp(),
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



  Widget _formulario( BuildContext context ) {

    final size = MediaQuery.of(context).size;

    return Column(
            children: <Widget>[
              // SafeArea(
              //   child: Container(),
              // ),
              Container(
                width: size.width * 0.90,
                margin: EdgeInsets.symmetric(vertical: 30.0),
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
                            // onPressed: (){},
                            onPressed: _seleccionarForo,
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            // onPressed: (){},
                            onPressed: _tomarForo,
                          )
                        ],
                      ),
                    ),
                    Text(''),
                    _crearForm(),
                    
                    SizedBox(height: 60.0),
                    // _crearSelect(),
                    SizedBox(height: 30.0),    

                    SizedBox(height: 30.0),

                    
                  ],
                ),
              ),
              Text('¿Olvido la contraseña?', style: TextStyle(color: Colors.white)),
              SizedBox( height: 100.0 ),
            ],
    );

  }

  Widget _crearForm() {

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _mostrarFoto(),
          _crearSeleccion(),
          _crearTextField(),
          _crearBoton(),
        ],
      ),
    );

  }

  Widget _crearSeleccion() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Selección',
          labelStyle: TextStyle(fontSize: 20.0)
        ),
        value: deficiencia.tipo, // cambiar por evaluacion.seleccion
        // value: evaluacion, // cambiar por evaluacion.seleccion
        onChanged: ( value ) {
          setState(() {
            deficiencia.tipo = value;
          });
        },
        items: <String>['Potencial', 'Existente']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
        }).toList(),
      ),
    );

  }

  Widget _crearTextField() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        // initialValue: '', // cambair por evaluacion.descripcion
        initialValue: deficiencia.descripcion, // cambair por evaluacion.descripcion
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Descripción',
          labelStyle: TextStyle(fontSize: 20.0)
        ),
        onChanged: (value) {
          setState(() {
            deficiencia.descripcion = value;
          });
        },
        validator: (value) {
          // (value.length < 3) ? 'Ingrese la descripción del riesgo' : null;
          if ( value.length < 3 ) {
            return 'Ingrese la descripción del riesgo';
          } else {
            return null;
          }
        },

      ),
    );

  }

  Widget _crearBoton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      onPressed: (_guardando) ? null :  _submit,
    );

  }

  void _submit() {

    if ( !formKey.currentState.validate() ) return;

    setState(() { _guardando = true; }); // para evitar que se guarden varias veces lo mismo sin querer

    // cambiar valor de la evaluacion y crearla o editarla segun exita el id o no
    // if ( evaluacion.id == null ) {
    //  evaluacionProvider.crearEvaluacion(evaluacion);
    // } else {
    //  evaluacionProvider.editarEvaluacion(evaluacion);
    // }
    // 
    print('Todo OK');


    setState(() { _guardando = false; }); // mejor cambiarlo a que vuelva a la pagina anterior
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

  Widget _mostrarFoto() {

    if ( deficiencia.imagen != null ) {

      String decoImage = deficiencia.imagen;
      Uint8List _bytesImage = Base64Decoder().convert(decoImage);

      return Image.memory(
          _bytesImage,
          fit: BoxFit.cover,
          height: 300.0,
          width: 300.0,
      );

    } else {

      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
          width: 300.0,
        );
      }
      return Image(

        image: AssetImage( foto?.path ?? 'assets/img/no-image.png'),
        height: 300.0,
        width: 300.0,
        fit: BoxFit.cover,

      );

    }

  }

  _seleccionarForo() async {

    _procesarImagen( ImageSource.gallery );

  }
  
  _procesarImagen( ImageSource source ) async {
// TODO: mirar que no haya problemas de que pierdan los datos
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage( source: source );

    foto = File(pickedFile.path);



    if ( foto != null ) {
      
      List<int> imageBytes = foto.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      print(base64Image);

      deficiencia.imagen = base64Image;

      Uint8List _bytesImage = Base64Decoder().convert(base64Image);

    }

    setState(() {});


  }
  
  _tomarForo() async {

    _procesarImagen( ImageSource.camera );

  }


}