import 'package:bot_toast/bot_toast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';

class FilterProducto with ChangeNotifier{
  String _columna,_condicion,_valorBuscar,_relacion;
  bool _estado=false;
  bool status=false;
  String _query;
  List<String> _columnas=new List();
  List<String> _condiciones=new List();
  List<String> _valoresABuscar=new List();
  List<String> _relaciones=new List();
  Widget checkbox(){
    return Container(
          child: ListTile(
            leading: Checkbox(
            value: _estado, onChanged: (value){
            _estado=value;
            notifyListeners();
          }),
          title: Text("Distinguir MAY/min"),
          ),
        );
  }
  Widget filtro(BuildContext context){
    return Wrap(
      children: <Widget>[
        FindDropdown(
          onChanged: (String item){
            _columna=item;
            _columnas.add(_columna);
            notifyListeners();
          },
          items: ['Seleccione','nombre','descripcion','tipo','categoria'],
          selectedItem: 'Seleccione',
          label: 'Columna',
        ),
        FindDropdown(
          onChanged: (String item){
            _condicion=item;
            _condiciones.add(_condicion);
            notifyListeners();
          },
          items: ['Seleccione','Contiene','Es igual'],
          selectedItem: 'Seleccione',
          label: 'Condicion',
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical:10.0),
          child: TextField(
            autofocus: false,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              hintText: "Valor a buscar",
              labelText: "Valor a buscar",
            ),
            onChanged: (value){
              _valorBuscar=value;
              
            },
            onEditingComplete: (){
              FocusScope.of(context).unfocus();
              _valoresABuscar.add(_valorBuscar);
              notifyListeners();
            },
          ),
        ),
        
      ],
    );
    
  }
  Widget radio(){
    return RadioButtonGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
          'Y',
          'O' 
        ],
        onSelected: (selected){
          _relacion=selected;
          _relaciones.add(_relacion);
          notifyListeners();
        },
      );
  }


  crearConsultaFiltro(int idEmpresa){
    if(_columnas.length>=0 && _valoresABuscar.length==0){
      _query="SELECT * FROM producto WHERE idempresa=$idEmpresa";
    }else{
      _query="SELECT * FROM producto WHERE idempresa=$idEmpresa AND ";
    }
    if(_valoresABuscar.length>0){
      for(int i=0;i<_columnas.length;i++){
        _query+=" ${_columnas[i]}";
        if(_condiciones.length>0){
          if(_condiciones[i]=="Contiene"){
            _query+=" LIKE ";
            if(_valoresABuscar.length>0){
              _query+="'%${_valoresABuscar[i]}%' ";
            }
          }else{
            _query+=" = ";
            if(_valoresABuscar.length>0){
              _query+=" '${_valoresABuscar[i]}' ";
            }
          }
        }
        
        if(_relaciones.length>0 && _relaciones.length > i){
          if(_relaciones[i]=="Y"){
            _query+=" AND";
          }else{
            _query+="OR";
          }
        }
      }
    }else{
      BotToast.showText(text: "De clic de confirmar en su teclado");
    }

   status=true;
   notifyListeners();
   print(_query);
   
  }

  limpirarFiltros(){
    status=false;
    if(_valoresABuscar!=null  && _condiciones!=null && _columnas!=null){
      _columnas.clear();
      _condiciones.clear();
      _valoresABuscar.clear();
     
      _columna=null;
      _condicion=null;
      _valorBuscar=null;
      
    }
    if(_relaciones!=null){
       _relaciones.clear();
       _relacion=null;
    }
  }

  Future<List<ProductoModel>> obtenerProductoFiltro()async{
    List<ProductoModel> lista=await DBProvider.db.filterAdvance(_query);
    return lista;
  }
}