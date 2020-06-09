import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';


class EmpresaProvider with ChangeNotifier{
  bool empresa=false;
  int _idempresa=0;
  int idempresa;
 
  final _prefs=new PreferenciasUsuario();
  EmpresaProvider(){
  }
  Future<bool> obtenerUsuarioRegistrado(String email,String password)async{
    
    UsuarioModel usuarioModel;
    try{
      usuarioModel=await DBProvider.db.getUsuarioRegistrado(email, password);
      _prefs.idusuario=usuarioModel.idusuario;
      notifyListeners();
      if(usuarioModel!=null){
        return true;
      }else{
        return false;
      }
    }catch(Exception){
      return false;
    }
  }

  ingresarEmpresa(EmpresaModel empresaModel)async{
    int crear;
    crear=await DBProvider.db.crearEmpresa(empresaModel);
    notifyListeners();
    return crear;
  }
  ingresarUsuario(UsuarioModel usuarioModel)async{
    int crear;
    crear=await DBProvider.db.crearUsuario(usuarioModel);
    //notifyListeners();
    return crear;
  }
  actualizarUsuario(String email,String password,int idempresa)async{
    int update;
    update=await DBProvider.db.updateUsuario(email, password, idempresa);
    notifyListeners();
    return update;
  }
  Future<EmpresaModel>obtenerEmpresa()async{
    EmpresaModel empresaModel;
    empresaModel=await DBProvider.db.getEmpresaUsuario(_prefs.idusuario);
    notifyListeners();
    if(empresaModel!=null){ 
      empresa=true;
      _idempresa=empresaModel.idempresa;
      idempresa=_idempresa;
      return empresaModel;
    }else{
      idempresa=0;
      empresa=false;
      return null;
    }

  }
  Future<EmpresaModel>obtenerEmpresaFi()async{
    EmpresaModel empresaModel;
    empresaModel=await DBProvider.db.getEmpresaUsuario(_prefs.idusuario);
    if(empresaModel!=null){ 
      empresa=true;
      _idempresa=empresaModel.idempresa;
      idempresa=_idempresa;
      return empresaModel;
    }else{
      idempresa=0;
      empresa=false;
      return null;
    }

  }

  Future<int> eliminarEmpresa()async{
    int delete=0;
    delete=await DBProvider.db.eliminarEmpresa(this._idempresa);
    notifyListeners();
    return delete;

  }
  Future<int> actualizarEmpresa(EmpresaModel empresaModel)async{
    int update=await DBProvider.db.updateEmpresa(empresaModel);
    notifyListeners();
    return update;
  }

  Future<List<EmpresaModel>> obtenerEmpresas()async{
    final lista=await DBProvider.db.getTodosEmpresas();
    notifyListeners();
    return lista;
  }

  Future<bool> verificarIntegridad(int idempresa)async{
    int contar=0;
    final usuarios=await DBProvider.db.getTodosUsuarios(idempresa);
    contar=usuarios.length;
    if(contar>0){
      //Hay usuarios en la empresa
      return true;
    }
    else{
      //No hay usuarios en la empresa
      return false;
    }
  }
}