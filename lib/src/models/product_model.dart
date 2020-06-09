import 'dart:convert';


//ProductModel productModel =ProductModelFromJson(jsonString);
ProductModel productModelFromJson(String str)=>
ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel productModel)=>
json.encode(productModel.toJson());

class ProductModel{
  String titulo;
  String detalle;
  int color;
  double precio;
  double existencia;
  String descripcion;
  bool favorito;
  bool is_offer;

  ProductModel({
    this.titulo,
    this.detalle,
    this.color,
    this.descripcion,
    this.existencia,
    this.favorito,
    this.precio,
    this.is_offer,
  });

  factory ProductModel.fromJson(Map<String,dynamic> json)=> new
  ProductModel(
    titulo          : json['titulo'],
    detalle         : json['detalle'],
    color           : json['color'],
    descripcion     : json['descripcion'],
    precio          : json['precio'],
    favorito        : json['favorito'],
    existencia      : json['existencia'],
    is_offer        : json['is_offer'],
  );
  Map<String,dynamic> toJson()=>{
    "titulo"      :titulo,
    "detalle"     :detalle,
    "color"       :color,
    "descripcion" :descripcion,
    "precio"      :precio,
    "favorito"    :favorito,
    "existencia"  :existencia,
    "is_offer"    :is_offer
  };

}