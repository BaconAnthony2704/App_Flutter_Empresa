import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';
class UsuarioProvider with ChangeNotifier{
  int idempresa;
  UsuarioProvider();
  
  Future<bool>getCrearUsuario(String nombre,String email,String password)async{
    UsuarioModel usuarioModel=new UsuarioModel(
      activo: 0,
      nombre: nombre,
      email: email,
      password: password,
      idrol: 2,
      docreate: 0,
      dodelete: 0,
      doread: 0,
      doupdate: 0,
      idempresa: 0,
    );
    int valor=await DBProvider.db.crearUsuario(usuarioModel);
    notifyListeners();
    if(valor!=0){
      return true;
    }else{
      return false;
    }
  }

  Future<bool>verificarIntegridad(String email)async{
    final usuario=await DBProvider.db.getUsuarioIntegridad(email);
    
    if(usuario==null){
      idempresa=0;
      return true;
    }
    else{
      idempresa=usuario.idempresa;
      return false;
      
    }
  }
  Future<List<UsuarioModel>> obtenerUsuarios(int idempresa)async{
    final lista=await DBProvider.db.getTodosUsuarios(idempresa);
    notifyListeners();
    return lista;
  }

  Future<UsuarioModel> obtenerUnUsuario(int idusuario)async{
    final usr=await DBProvider.db.getUsuario(idusuario);
    notifyListeners();
    return usr;
  }
  Future<UsuarioModel> obtenerUnUsuarioParaMenu(int idusuario)async{
    final usr=await DBProvider.db.getUsuario(idusuario);
    return usr;
  }

  Future<int> actualizarUsuario(UsuarioModel usuarioModel)async{
    int afectado=await DBProvider.db.updatePermisoUsuario(usuarioModel);
    return afectado;
  }
  Future<int> eliminiarUsuario(UsuarioModel usuarioModel)async{
    int afectado=await DBProvider.db.deleteUsuario(usuarioModel);
    notifyListeners();
    return afectado;
  }
}