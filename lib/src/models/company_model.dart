import 'dart:convert';


//CompanyModel companyModel =CompanyModelFromJson(jsonString);
CompanyModel companyModelFromJson(String str)=>
CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel companyModel)=>
json.encode(companyModel.toJson());

class CompanyModel{
  int idcompany;
  String nombre;
  String giro;
  int color;
  double raiting;
  String direccion;
  String descripcion;
  bool favorito;
  bool isdelivery;
  int categoria;


  CompanyModel({
    this.idcompany,
    this.nombre,
    this.giro,
    this.color,
    this.descripcion,
    this.direccion,
    this.favorito,
    this.raiting,
    this.isdelivery,
    this.categoria,

  });

  factory CompanyModel.fromJson(Map<String,dynamic> json)=> new
  CompanyModel(
    idcompany   : json['idcompany'],
    nombre      : json['nombre'],
    giro        : json['giro'],
    color       : json['color'],
    descripcion : json['descripcion'],
    direccion   : json['direccion'],
    favorito    : json['favorito'],
    raiting     : json['raiting'],
    isdelivery  : json['isdelivery'],
    categoria   : json['categoria'],
  );
  Map<String,dynamic> toJson()=>{
    "idcompany":idcompany,
    "nombre":nombre,
    "giro":giro,
    "color":color,
    "descripcion":descripcion,
    "direccion":direccion,
    "favorito":favorito,
    "raiting":raiting,
    "isdelivery":isdelivery,
    "categoria":categoria
  };

}