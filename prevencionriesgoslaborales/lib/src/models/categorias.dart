
class CategoriaModel {

  static const _NOMBRE_ = "nombre";
  static const _CODIGO_ = "codigo";
  static const _ID_ = "id";
  static const _ICONO_ = "icono";
  static const _IDPADRE_ = "idPadre";

  int id;
  String codigo;
  String nombre;
  String icono;
  int idPadre;

  CategoriaModel({
    this.codigo,
    this.id,
    this.nombre,
    this.icono,
    this.idPadre
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
      id        : json[_ID_],
      codigo    : json[_CODIGO_],
      nombre    : json[_NOMBRE_],
      icono     : json[_ICONO_],
      idPadre   : json[_IDPADRE_],
  );

  Map<String, dynamic> toJson() => {
      _ID_      : id,
      _CODIGO_  : codigo,
      _NOMBRE_  : nombre,
      _ICONO_   : icono,
      _IDPADRE_ : idPadre,
  };

}