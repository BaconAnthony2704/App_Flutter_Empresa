import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/categoria_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/mas_acciones.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/page/menu/search_delegate_producto.dart';
import 'package:mantenimiento_empresa/src/page/producto/contenedor_principal.dart';
import 'package:mantenimiento_empresa/src/page/producto/contenedor_principal_promocion.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  PreferenciasUsuario prefs;
  int pos;
  
  
  CustomPopupMenu _selectedChoices;
  @override
  void initState() {
    // TODO: implement initState
    pos=0;
    prefs=PreferenciasUsuario();
    //_selectedChoices=choices[0];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context){
    ProductoProvider productoModel=Provider.of<ProductoProvider>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            //BotToast.showText(text: "Proximamente busqueda");
            productoModel.filterP=null;
            showSearch(context: context, delegate: DataSearchProducto());
          }),
          (productoModel.consultaP!=null || productoModel.filterP!=null)
          ?IconButton(icon: Icon(Icons.close), onPressed: (){
            productoModel.consultaP=null;
            productoModel.filterP=null;
            productoModel.notifyListeners();
          })
          :Container(),
          IconButton(icon: Icon(Icons.filter_list), onPressed: ()async{
            await BotToast.showNotification(
              duration: Duration(seconds: 5),
              title: (_){
                return FutureBuilder<List<CategoriaModel>>(
                  future: productoModel.obtenerCategorias(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.data.length==0){
                      return Center(child: Text("No hay categoria disponibles"),);
                    }
                    return Container(
                      height: 120.0,
                      child: ListView.builder(
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Text(snapshot.data[index].categoria),
                            onTap: (){
                              productoModel.consultaP=null;
                              productoModel.filterP=snapshot.data[index].categoria;
                              productoModel.notifyListeners();
                            },
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    );
                  },
                );
              }
            );
          }),
          Environment().mostrarPopupMenu(
            choices: Environment().choicesProducto(
              context: context,
              empresaProvider: empresaProvider,
              productoModel: productoModel
            ))
        ],
      ),
      body: _callPage(pos),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Theme.of(context).textSelectionColor,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed('edit_producto');
        }
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.local_offer),title: Text("Productos")),
        BottomNavigationBarItem(icon: Icon(Icons.insert_chart),title: Text("Existencias")),
      ],
      onTap: (posicion){
        setState(() {
          pos=posicion;
        });
      },
      currentIndex: pos,
      ),
    );
  }

  Widget _callPage(int pos) {
    switch(pos){
      case 0:
        return ContenedorPrincipal();
        break;
      case 1:
        return ContenedorPrincipalPromocional();
        break;
    }
  }
}

