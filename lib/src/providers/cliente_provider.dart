import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/models/forma_pago_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';
class ClienteProvider with ChangeNotifier{
  String consultaP;
  String filterC;
  Future<int> ingresarCliente(ClienteModel clienteModel)async{
    final valor=await DBProvider.db.crearCliente(clienteModel);
    return valor;
  }

  Future<List<ClienteModel>> mostrarClientes(int idempresa)async{
    List<ClienteModel> lista=await DBProvider.db.obtenerClientes(idempresa);
    if(lista==[]){
      return lista=[];
    }
    //notifyListeners();
    return lista;
  }

  Future<List<ClienteModel>> buscarCliente(int idEmpresa,String query)async{
    consultaP=query;
    List<ClienteModel> lista=await DBProvider.db.searchCliente(idEmpresa, query);
    if(lista==[]){
      return [];
    }
    return lista;
  }

  Future<int> actualizarCliente(ClienteModel clienteModel)async{
    int update=await DBProvider.db.updateCliente(clienteModel);
    return update;
  }

  Future<List<FormaPagoModel>> obtenerFormaPago()async{
    List<FormaPagoModel> lista=await DBProvider.db.obtenerPayment();
    return lista;
  }

  Future<List<ClienteModel>> filtrarPorFormaPago(int idEmpresa,String filtro)async{
    filterC=filtro;
    List<ClienteModel> lista=await DBProvider.db.filterToPayment(idEmpresa, filtro);
    return lista;
  }

  Future<double> obtenerClientePotencial(int idEmpresa)async{
    double cant=await DBProvider.db.getClientePotenciales(idEmpresa);
    return cant;
  }
}