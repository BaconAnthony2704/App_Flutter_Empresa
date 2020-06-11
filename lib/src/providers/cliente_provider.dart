import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';
class ClienteProvider with ChangeNotifier{

  Future<int> ingresarCliente(ClienteModel clienteModel)async{
    final valor=await DBProvider.db.crearCliente(clienteModel);
    return valor;
  }

  Future<List<ClienteModel>> mostrarClientes(int idempresa)async{
    List<ClienteModel> lista=await DBProvider.db.obtenerClientes(idempresa);
    if(lista==[]){
      return lista=[];
    }
    notifyListeners();
    return lista;
  }
}