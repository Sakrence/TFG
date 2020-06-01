
class Categoria {

  static const _NAME_ = "name";
  static const _ID_ = "id";
  static const _ICON_ = "icon";

  String id;
  String name;
  String icon;

  Categoria({
      this.id,
      this.name,
      this.icon,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
      id    : json[_ID_],
      name  : json[_NAME_],
      icon : json[_ICON_],
  );

  Map<String, dynamic> toJson() => {
      _ID_    : id,
      _NAME_  : name,
      _ICON_ : icon,
  };

}