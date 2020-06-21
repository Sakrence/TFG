import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context ),
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

  Widget _loginForm(BuildContext context) {

    // final bloc = Provider.of(context);
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
                // _crearEmail(bloc),
                _crearEmail(),
                SizedBox(height: 30.0),                
                // _crearPassword(bloc),
                _crearPassword(),
                SizedBox(height: 30.0),
                // _crearBoton(bloc),
                _crearBoton(),
                SizedBox(height: 30.0),

              ],
            ),
          ),
          Text('¿Olvido la contraseña?'),
          SizedBox( height: 100.0 ),
        ],
      ),
    );

  }

  // Widget _crearEmail( LoginBloc bloc ) {
  Widget _crearEmail(  ) {

    // return StreamBuilder(
    //   stream: bloc.emailStream ,
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              // counterText: snapshot.data,
              // errorText: snapshot.error
            ),
            // onChanged: bloc.changeEmail,
          ),
        );
      // },
    // );



    
  }

  // Widget _crearPassword( LoginBloc bloc ) {
  Widget _crearPassword( ) {

    // return StreamBuilder(
    //   stream: bloc.passwordStream ,
    //   builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              labelText: 'Contraseña',
              // counterText: snapshot.data,
              // errorText: snapshot.error
            ),
            // onChanged: bloc.changePassword,
          ),
        );
    //   },
    // );


    
  }

  // Widget _crearBoton( LoginBloc bloc ) {
  Widget _crearBoton( ) {

    // return StreamBuilder(
    //   stream: bloc.formValidStream ,
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
         return RaisedButton(
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
          onPressed: () {},
          // onPressed: snapshot.hasData ? () => _login(bloc, context) : null
        );
    //   },
    // );
  }
 
  // _login( LoginBloc bloc, BuildContext context ) {
  _login(  ) {

    print('============ ');
    // print('Email: ${ bloc.email }');
    // print('Password: ${ bloc.password }');
    print('============ ');

    // Navigator.pushReplacementNamed(context, 'home'); // para que la sisguiente pagina sea el root

  }

}