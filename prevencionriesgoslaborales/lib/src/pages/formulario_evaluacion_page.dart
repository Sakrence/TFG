import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prevencionriesgoslaborales/src/bloc/deficiencia_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/evaluaciones_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'dart:math';

import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';

class FormPage extends StatefulWidget {

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  static final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  // DeficienciaBloc deficienciaBloc;
  // DeficienciaModel deficiencia = new DeficienciaModel();
  // EvaluacionModel evaluacion;
  bool _guardando = false;
  File foto;
  EvaluacionModel evaluacion;
  EvaluacionesBloc evaluacionBloc;
  DeficienciaModel deficiencia;


  final TextEditingController c1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    // deficienciaBloc = Provider.deficienciaBloc(context);
    evaluacionBloc = Provider.evaluacionesBloc(context);
    final DeficienciaModel deficienciaData = ModalRoute.of(context).settings.arguments;


    evaluacion = deficienciaData.evaluacion;
    deficiencia = deficienciaData;


    // evaluacionBloc.getEvaluacion(deficienciaData.id);

    // if ( evaluacionBloc.evaluacion == null ) {
    //   if ( deficienciaData != null ) {
    //     evaluacion = deficienciaData.evaluacion;
    //     deficiencia = deficienciaData;
    //   }
    // } else {
    //   evaluacion = evaluacionBloc.evaluacion;
    // }

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _fondoApp(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                // _formulario(context, evaluacion),
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



  // Widget _formulario( BuildContext context, EvaluacionModel evaluacion ) {
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
                      // onPressed: () => _seleccionarForo(evaluacion),
                      onPressed: _seleccionarForo,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      // onPressed: (){},
                      // onPressed: () => _tomarForo(evaluacion),
                      onPressed: _tomarForo,
                    )
                  ],
                ),
              ),
              Text(''),
              // _crearForm(evaluacion),
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

  // Widget _crearForm( EvaluacionModel evaluacion ) {
  Widget _crearForm() {

    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // _mostrarFoto(evaluacion),
            // _crearSeleccion(evaluacion),
            // _crearTextField(evaluacion),
            // _crearBoton(evaluacion),
            _mostrarFoto(),
            _crearSeleccion(),
            _crearTextField(),
            _crearBoton(),
          ],
        ),
      ),
    );

  }

  // Widget _crearSeleccion( EvaluacionModel evaluacion ) {
  Widget _crearSeleccion() {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Selección',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: evaluacion.tipoFactor,
      onChanged: ( value ) => evaluacion.tipoFactor = value,
      // onSaved: ( value ) => setState(() {
      //     evaluacion.tipoFactor = value;
      // }),
      // onChanged: ( value ) => setState(() {
      //     evaluacion.tipoFactor = value;
      // }),
      // onSaved: ( value ) => setState(() {
      //     evaluacion.tipoFactor = value;
      // }),
      items: <String>['Potencial', 'Existente']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      }).toList(),
    );

  }

  // Widget _crearTextField( EvaluacionModel evaluacion ) {
  Widget _crearTextField( ) {

    return TextFormField(
      initialValue: evaluacion.riesgo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Descripción',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      // onChanged: (value) {
      //   evaluacion.riesgo = value;
      //   // print(evaluacion.riesgo);
      // },
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

  // Widget _crearBoton( EvaluacionModel evaluacion ) {
  Widget _crearBoton(  ) {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      // onPressed: (_guardando) ? null :  _submit,
      // onPressed: () => _submit(evaluacion),
      onPressed: _submit,
    );

  }

  // void _submit( EvaluacionModel evaluacion ) async {
  void _submit() async {

    if ( !_formKey.currentState.validate() ) return;

    _formKey.currentState.save();
    // setState(() { _guardando = true; }); // para evitar que se guarden varias veces lo mismo sin querer

    

    if ( foto != null ) {
      // deficiencia.imagen = await deficienciaBloc.subirFoto(foto); // crearla para que suba foto a la base de datos y devuelva la foto
      List<int> imageBytes = foto.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      // print(base64Image);
      if ( evaluacion.fotos == null ) {
        List<Foto> lista = List();
        Foto aux = Foto(foto: Base64Decoder().convert(base64Image), idEvaluacion: evaluacion.id);
        lista.add(aux);
        evaluacion.fotos = lista;
      } else {
        evaluacion.fotos[0].foto = Base64Decoder().convert(base64Image);
      }

      // Uint8List _bytesImage = Base64Decoder().convert(base64Image);
    }

   
    // await DBProvider.db.nuevaEvaluacion(evaluacion);
    if ( evaluacion.id != null ) {
      await evaluacionBloc.editarEvaluacion(evaluacion);
    } else {
      await evaluacionBloc.addEvaluacion(evaluacion, deficiencia.id);
    }

    // if ( deficiencia.tipo == null  ) {
    //   deficienciaBloc.agregarDeficiencia(deficiencia); // crear para que cree la deficiencia en la BD
    // } else {
    //   deficienciaBloc.editarDeficiencia(deficiencia);
    // }


    print('Todo OK');


    // setState(() { _guardando = false; }); // mejor cambiarlo a que vuelva a la pagina anterior
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

  // Widget _mostrarFoto( EvaluacionModel evaluacion ) {
  Widget _mostrarFoto( ) {

    if ( evaluacion.fotos != null ) {

      // String decoImage = deficiencia.evaluacion.fotos[0].foto;
      // Uint8List _bytesImage = Base64Decoder().convert(decoImage);
      Uint8List _bytesImage = evaluacion.fotos[0].foto;

      return FadeInImage(
        height: 300.0,
        width: 300.0,
        fit: BoxFit.cover,
        placeholder: AssetImage('assets/img/original.gif'),
        image: Image.memory(
          _bytesImage,
        ).image,
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

  // _seleccionarForo( EvaluacionModel evaluacion ) async {
  _seleccionarForo(  ) async {

    // _procesarImagen( ImageSource.gallery, evaluacion );
    _procesarImagen( ImageSource.gallery);

  }
  
  // _procesarImagen( ImageSource source, EvaluacionModel evaluacion  ) async {
  _procesarImagen( ImageSource source) async {
// TODO: mirar que no haya problemas de que pierdan los datos
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage( source: source );

    foto = File(pickedFile.path);

    if ( foto != null ) {
      if (evaluacion.fotos != null ) evaluacion.fotos[0].foto = null;
    }

    setState(() {});

  }
  
  // _tomarForo( EvaluacionModel evaluacion ) async {
  _tomarForo( ) async {

    // _procesarImagen( ImageSource.camera, evaluacion );
    _procesarImagen( ImageSource.camera);

  }


}