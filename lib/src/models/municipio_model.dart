// To parse this JSON data, do
//
//     final municipioModel = municipioModelFromJson(jsonString);

import 'dart:convert';

List<MunicipioModel> municipioModelFromJson(String str) => List<MunicipioModel>.from(json.decode(str).map((x) => MunicipioModel.fromJson(x)));

String municipioModelToJson(List<MunicipioModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MunicipioModel {
    MunicipioModel({
        this.id,
        this.idDepartamento,
        this.nombre,
    });

    int id;
    int idDepartamento;
    String nombre;

    factory MunicipioModel.fromJson(Map<String, dynamic> json) => MunicipioModel(
        id: json["id"],
        idDepartamento: json["idDepartamento"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idDepartamento": idDepartamento,
        "nombre": nombre,
    };
}
