import 'dart:convert';

FactorRiesgoModel factorRiesgoModelFromJson(String str) => FactorRiesgoModel.fromJson(json.decode(str));

String factorRiesgoModelToJson(FactorRiesgoModel data) => json.encode(data.toJson());

class FactorRiesgoModel {
    FactorRiesgoModel({
        this.id,
        this.nombre,
        this.icono,
        this.idPadre,
    });

    String id;
    String nombre;
    String icono;
    String idPadre;

    factory FactorRiesgoModel.fromJson(Map<String, dynamic> json) => FactorRiesgoModel(
        id        : json["id"],
        nombre    : json["nombre"],
        icono     : json["icono"],
        idPadre   : json["idPadre"],
    );

    Map<String, dynamic> toJson() => {
        "id"      : id,
        "nombre"  : nombre,
        "icono"   : icono,
        "idPadre" : idPadre,
    };
}