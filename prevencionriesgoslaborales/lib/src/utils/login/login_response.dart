import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';


abstract class LoginCallBack {
  void onLoginSuccess(Inspector usuario, InspeccionBloc bloc);
  void onLoginError();
}
class LoginResponse {
  
  LoginCallBack _callBack;
  LoginResponse(this._callBack);

  doLogin(InspeccionBloc bloc, String usuario, String contrasena) {
    bloc
        .getLogin(usuario, contrasena)
        .then((inspector) => _callBack.onLoginSuccess(inspector, bloc))
        .catchError((onError) => _callBack.onLoginError());
  } 
}