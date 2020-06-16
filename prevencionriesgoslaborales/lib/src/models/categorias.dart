
class CategoriaModel {

  static const _NOMBRE_ = "nombre";
  static const _ID_ = "id";
  static const _ICONO_ = "icono";

  String id;
  String nombre;
  String icono;

  CategoriaModel({
      this.id,
      this.nombre,
      this.icono,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
      id    : json[_ID_],
      nombre  : json[_NOMBRE_],
      icono : json[_ICONO_],
  );

  Map<String, dynamic> toJson() => {
      _ID_    : id,
      _NOMBRE_  : nombre,
      _ICONO_  : icono,
  };

}