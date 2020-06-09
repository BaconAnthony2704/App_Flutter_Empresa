
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mantenimiento_empresa/src/models/departamento_model.dart';
import 'package:mantenimiento_empresa/src/models/municipio_model.dart';

final _url="https://api.salud.gob.sv";
class DepartamentoProvider with ChangeNotifier{
  final url_api="$_url/departamentos.json";
  int _idDepartamento;
   bool progreso=false;
  List<DepartamentoModel> listaDepartamentos=[];

  List<MunicipioModel> listaMunicipios=[];
 DepartamentoProvider(){
    getCargarDepartamentos();
 }

Future<List<DepartamentoModel>> getCargarDepartamentos()async{
    try{
      final response=await http.get(url_api);
      List<DepartamentoModel> departamentos;
      departamentos=(json.decode(response.body) as List).map((i) {
        return DepartamentoModel.fromJson(i);
      }
      
      ).toList();
      //print(departamentos[0].nombre);
      listaDepartamentos=departamentos;
       notifyListeners();
       return departamentos;
    }catch(Exception){
      return [];
    }
  }

  obtenerIdDepartamento(int idDepartamento){
    idDepartamento=idDepartamento;
   // notifyListeners();
  }

  Future<void>obtenerMunicipios(int idDepartamento)async{
    final url_muni="$_url/municipios.json?idDepartamento=$idDepartamento";
    try{
      progreso=false;
      listaMunicipios.clear();
      final response=await http.get(url_muni);
      List<MunicipioModel> municipios;
      municipios=(json.decode(response.body) as List).map((municipio) =>
      MunicipioModel.fromJson(municipio)).toList();
      listaMunicipios=municipios;
      progreso=true;
     // notifyListeners();
      //return municipios;
    }catch(Exception){
      return [];
    }
    
  }
}