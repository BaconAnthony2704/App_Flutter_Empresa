import 'package:flutter/material.dart';

class ExistenciaPorTipoModel{

final String tipo;
final double valor;
final Color color;

  ExistenciaPorTipoModel({this.tipo, this.valor,this.color=Colors.red});

  factory ExistenciaPorTipoModel.fromJson(Map<String, dynamic>json)=>ExistenciaPorTipoModel(
    tipo    : json['tipo'],
    valor      : json['valor'].toDouble(),
       
  );

}