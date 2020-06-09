// To parse this JSON data, do
//
//     final DepartamentoModel = DepartamentoModelFromJson(jsonString);

import 'dart:convert';

List<DepartamentoModel> DepartamentoModelFromJson(String str) => List<DepartamentoModel>.from(json.decode(str).map((x) => DepartamentoModel.fromJson(x)));

String DepartamentoModelToJson(List<DepartamentoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepartamentoModel {
    DepartamentoModel({
        this.id,
        this.nombre,
        this.idPais,
        this.iso31662,
    });

    int id;
    String nombre;
    int idPais;
    String iso31662;

    factory DepartamentoModel.fromJson(Map<String, dynamic> json) => DepartamentoModel(
        id: json["id"],
        nombre: json["nombre"],
        idPais: json["idPais"],
        iso31662: json["iso31662"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "idPais": idPais,
        "iso31662": iso31662,
    };
}