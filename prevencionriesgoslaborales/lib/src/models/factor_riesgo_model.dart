import 'dart:convert';

FactorRiesgoModel factorRiesgoModelFromJson(String str) => FactorRiesgoModel.fromJson(json.decode(str));

String factorRiesgoModelToJson(FactorRiesgoModel data) => json.encode(data.toJson());

class FactorRiesgoModel {
    FactorRiesgoModel({
        this.id,
        this.codigo,
        this.nombre,
        this.icono,
        this.idPadre,
    });

    int id;
    String codigo;
    String nombre;
    String icono;
    int idPadre;

    factory FactorRiesgoModel.fromJson(Map<String, dynamic> json) => FactorRiesgoModel(
        id        : json["id"],
        codigo    : json["codigo"],
        nombre    : json["nombre"],
        icono     : json["icono"],
        idPadre   : json["idPadre"],
    );

    Map<String, dynamic> toJson() => {
        "id"      : id,
        "codigo"  : codigo,
        "nombre"  : nombre,
        "icono"   : icono,
        "idPadre" : idPadre,
    };
}