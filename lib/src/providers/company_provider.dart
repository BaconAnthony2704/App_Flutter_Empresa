import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/company_model.dart';
class CompanyProvider with ChangeNotifier{
  List<CompanyModel> listaCompany=new List();
  CompanyProvider(){
    loadCompany();
  }

  void loadCompany() {
    final comp1=new CompanyModel(
      idcompany: 1,
      color: 0xFF101C42,
      descripcion: "Empresa de servicios de embotelladoras",
      direccion: "Carretera Lorem, 31A 17ºA",
      favorito: true,
      giro: "Servicios",
      nombre: "Industria la Constancia S.A. de C.V.",
      raiting: 4.3,
      isdelivery: true,
      categoria: 1,
    );

    final comp2=new CompanyModel(
      idcompany: 2,
      color: 0xFF145C52,
      descripcion: "Empresa de servicios Maquila",
      direccion: "Urbanización Lorem ipsum dolor, 149B",
      favorito: true,
      giro: "Fab de Camisas",
      nombre: "AstroBoy S.A. de C.V.",
      raiting: 4.2,
      isdelivery: false,
      categoria: 1,
    );

    final comp3=new CompanyModel(
      idcompany: 3,
      color: 0xFF69AC48,
      descripcion: "Empresa de servicios de Informatica",
      direccion: "Pasaje Lorem, 206B 16ºF",
      favorito: false,
      giro: "Tecnologia",
      nombre: "Tecno Service S.A. de C.V.",
      raiting: 3.9,
      isdelivery: true,
      categoria: 1,
    );

    final comp4=new CompanyModel(
      idcompany: 4,
      color: 0xFFAAEC72,
      descripcion: "Empresa de servicios de Electricidad",
      direccion: "Alameda Lorem ipsum dolor sit, 156A 17ºA",
      favorito: true,
      giro: "Electronica",
      nombre: "DELSUR S.A. de C.V.",
      raiting: 4.6,
      isdelivery: false,
      categoria: 2,
    );

    listaCompany.addAll([
      comp1,
      comp2,
      comp3,
      comp4
    ]);
    notifyListeners();  
  }
  
  String deleteCompany(int id){
    try{
      listaCompany.removeAt(id);
    notifyListeners();
    return "Empresa eliminada";
    }catch(Exception){
      return "No se pudo elimninar";
    }
  }

  String saveCompany(CompanyModel companyModel){
    try{
      listaCompany.add(companyModel);
      notifyListeners();
      return "Empresa agregada";
    }catch(Exception){
      return "No se pudo agregar";
    }
  }
  String updateCompany(int index,CompanyModel companyModel){
    try{
      listaCompany.removeAt(index);
      listaCompany.insert(index, companyModel);
      notifyListeners();
      return "Empresa actualizada";
    }catch(Exception){
      return "No se pudo actualizar";
    }
  }

  int indexCompany(CompanyModel companyModel){
    int valor;
    for(int i=0;i<listaCompany.length;i++){
      if(listaCompany[i].nombre==companyModel.nombre){
        valor=i;
      }
    }
    //notifyListeners();
    return valor;
  }


}