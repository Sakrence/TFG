import 'package:flutter/material.dart';

import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:prevencionriesgoslaborales/src/utils/login/login_response.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginCallBack {

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _usuario, _contrasena;

  LoginResponse _response;

  _LoginPageState() {
    _response = new LoginResponse(this);
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final _inspeccionBloc = Provider.inspeccionBloc(context);
    
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context, _inspeccionBloc ),
        ],
      ),
    );
  }

  Widget _crearFondo( BuildContext context ) {

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.30,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset(0.6 , 0.5),
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.white.withOpacity(0.05)
      ),
    );


    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, left: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: 30.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),

        Container(
          padding: EdgeInsets.only(top:50.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox( height: 10.0, width: double.infinity, ),
            ],
          ),
        ),
      ],
    );

  }

  Widget _loginForm( BuildContext context, InspeccionBloc inspeccionBloc ) {

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: size.height * 0.17,
            ),
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: .0),
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
                    border: Border.all(color: Colors.black12),
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
                  child: Text('Ingreso', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                ),
                SizedBox(height: 30.0),
                Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                       _crearUsuario(),
                        SizedBox(height: 30.0),                
                        // _crearPassword(bloc),
                        _crearPassword(),
                    ]
                  ),
                ),
                SizedBox(height: 30.0),
                _crearBoton(inspeccionBloc),
                SizedBox(height: 30.0),
              ],
            ),
          ),
          GestureDetector(
            key: Key('Registrarse'),
            child: Text('Registrarse'),
            onTap: () {
              _mostrarAlertaInspector(context, inspeccionBloc);
            },
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            key: Key('Olvidar'),
            child: Text('¿Olvido la contraseña?'),
            onTap: () {
              _mostrarAlertaContrasena(context, inspeccionBloc);
            },
          ),
          SizedBox( height: 100.0 ),
        ],
      ),
    );

  }

  Widget _crearUsuario() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        key: Key('usuario'),
        decoration: InputDecoration(
          icon: Icon(Icons.person_outline, color: Colors.deepPurple),
          hintText: 'Usuario',
          labelText: 'Usuario',
        ),
        onSaved: (value) => _usuario = value,
      ),
    );
    
  }

  Widget _crearPassword( ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        key: Key('contrasena'),
        obscureText: _obscureText,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
          labelText: 'Contraseña',
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility),
            onPressed: _toggle,
          )
        ),
        onSaved: (value) => _contrasena = value,
      ),
    );
    
  }

  Widget _crearBoton( InspeccionBloc inspeccionBloc ) {

    return RaisedButton(
      key: Key('boton'),
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 20.0),
        child: Text('Ingresar'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _submit(inspeccionBloc),
    );
  }

  _mostrarAlertaInspector( BuildContext context, InspeccionBloc bloc) {

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
                    child: Text('Resgistro', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                  ),
                  Material(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            _crearTextUsuario(inspector),
                            _crearTextContrasena(inspector)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        key: Key('registroCancelar'),
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        key: Key('registroOK'),
                        child: Text('Ok'),
                        onPressed: () {
                          agregarUsuario(inspector, bloc);
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

  agregarUsuario( Inspector inspector, InspeccionBloc bloc ) async {

    if (await _usuarioUnico(inspector)) {
      bloc.agregarInspector(inspector);
      Navigator.of(context).pop();
      _showSnackBar('Se ha creado el usuario satisfactoriamente');
    } else {
      _showSnackBar('El usuario ya existe');
    }

  }

  Future<bool> _usuarioUnico(Inspector inspector ) async {
    List<Inspector> inspectores = await DBProvider.db.getAllInspectores();
  
    bool flag = true;

    inspectores.forEach((element) {
      if ( element.usuario == inspector.usuario ) {
        if ( element.contrasena == inspector.contrasena ) flag = false;
      }
    });

    return flag;
  }

  Future<String> _recuperarContrasena( String usuario ) async {
    List<Inspector> inspectores = await DBProvider.db.getAllInspectores();

    String contrasena = null;

    inspectores.forEach((element) { 
      if (element.usuario.split(' ')[0] == usuario) contrasena = element.contrasena;
    });

    return contrasena;
  }

  _mostrarAlertaContrasena( BuildContext context, InspeccionBloc bloc ) {

    
    final size = MediaQuery.of(context).size;

    final inspector = Inspector();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return SingleChildScrollView(
          key: Key('olvidarDialog'),
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
                  child: Text('Recuperar contraseña', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                ),
                Material(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          _crearTextUsuario(inspector),
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
                        _contrasenaOlvidada(context, inspector);
                        // bloc.agregarInspector(inspector);
                        // Navigator.of(context).pop();
                        // _showSnackBar('Se ha creado el usuario satisfactoriamente');
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

  _contrasenaOlvidada( BuildContext context, Inspector inspector ) async {

    String contrasena = await _recuperarContrasena(inspector.usuario);

    if (contrasena == null ) {
      _showSnackBar('No existe ese usuario');
    } else {
      Navigator.of(context).pop();
      _showSnackBar('La contraseña es: $contrasena');
    }

  }

  Widget _crearTextUsuario( Inspector inspector) {

    return TextFormField(
      key: Key('registroUsuario'),
      initialValue: inspector.usuario,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Usuario',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => setState(() {
          inspector.usuario = value;
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
  
  Widget _crearTextContrasena( Inspector inspector) {

    return TextFormField(
      key: Key('registroContrasena'),
      initialValue: inspector.contrasena,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => setState(() {
          inspector.contrasena = value;
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

  void _submit( InspeccionBloc bloc ) {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(bloc, _usuario, _contrasena);
      });
    }
  }

  @override
  void onLoginError() {

    _showSnackBar('No existe ese usuario, prueba de nuevo');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(Inspector inspector, InspeccionBloc bloc) async {   

    if ( inspector != null ){

      // List<Inspector> list = bloc.inspectores;

      // list.add(inspector);
      // bloc.changeInspectores(list);
      
      bloc.changeInspectorSeleccionado(inspector);
      // bloc.obtenerInspecciones(inspector.id);

      Navigator.of(context).pushNamed("inspecciones");
    
    }else{

      _showSnackBar('No existe ese usuario, prueba de nuevo, o registrate');

      setState(() {
        _isLoading = false;
      });
    }
    
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

}