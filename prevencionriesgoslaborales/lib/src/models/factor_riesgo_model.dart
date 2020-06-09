import 'dart:convert';

FactorRiesgoModel factorRiesgoModelFromJson(String str) => FactorRiesgoModel.fromJson(json.decode(str));

String factorRiesgoModelToJson(FactorRiesgoModel data) => json.encode(data.toJson());

class FactorRiesgoModel {
    FactorRiesgoModel({
        this.id,
        this.name,
        this.icon,
    });

    String id;
    String name;
    String icon;

    factory FactorRiesgoModel.fromJson(Map<String, dynamic> json) => FactorRiesgoModel(
        id      : json["id"],
        name    : json["name"],
        icon    : json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "name"  : name,
        "icon"  : icon,
    };
}