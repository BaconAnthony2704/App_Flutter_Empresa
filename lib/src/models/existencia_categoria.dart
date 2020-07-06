import 'package:flutter/material.dart';

class ExistenciaPorCategoriaModel{

final String categoria;
final double valor;
final Color color;

  ExistenciaPorCategoriaModel({this.categoria, this.valor,this.color=Colors.red});

  factory ExistenciaPorCategoriaModel.fromJson(Map<String, dynamic>json)=>ExistenciaPorCategoriaModel(
    categoria    : json['categoria'],
    valor      : json['valor'].toDouble(),
       
  );

}