import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';

class Environment{
  EdgeInsetsGeometry get metMargen5All => EdgeInsets.all(5.0);
  Color get metColor => Colors.white;

  TableRow generarFila(String texto,String concepto) {
    return TableRow(
                children: [
                  Text(texto),
                  Text("${concepto}",textAlign: TextAlign.end,)
                ],
              );
  }

  Future<void> mostrarAlerta(BuildContext context,String alerta) {
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(alerta),
      actions: <Widget>[
        RaisedButton(onPressed: ()=>Navigator.of(context).pop(),child: Text("Aceptar"),)
      ],
    ));
  }
  Future<int> opcionesUsuario(BuildContext context,String texto) async{
    int accion=0;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      elevation: 10.0,
      content: Container(
        height: 180.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Editar permisos"),
              onTap: (){
                accion=1;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.info),
              title: Text("Inspeccionar permisos"),
              onTap: (){
                accion=2;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Eliminar usuario"),
              onTap: (){
                accion=3;
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      title: Row(
        children: <Widget>[
          Expanded(child: Text(texto)),
          IconButton(icon: Icon(Icons.clear), onPressed: ()=>Navigator.of(context).pop())
        ],
      ),
    ));
    return accion;
  }
  mostrarEmpresas(BuildContext context,EmpresaProvider empresaProvider,String email,String password)async{
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: FutureBuilder<List<EmpresaModel>>(
      future: empresaProvider.obtenerEmpresas(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        if(snapshot.data.length==0){
          return Center(child: Text("No hay empresas"),);
        }
        return Column(
          children: <Widget>[
            Center(child: Text("Seleccione una empresa"),),
            Expanded(
              child: ListView.builder(
                itemBuilder:(context,index){
                  return ListTile(
                    leading: Icon(Icons.business),
                    title: Text("${snapshot.data[index].nombre}"),
                    onTap: ()async{
                      print("Empresa seleccionada ${snapshot.data[index].idempresa}");
                      BotToast.showText(text: "Empresa seleccionada");
                      int cambio=await empresaProvider.actualizarUsuario(email, password, snapshot.data[index].idempresa);
                      if(cambio==1){
                        BotToast.showText(text: "Cambio actualizado");
                      }
                    },
                  );
                },
                itemCount: snapshot.data.length,
              ),
            ),
          ],
        );
        },
      ),
      actions: <Widget>[
        RaisedButton(onPressed: ()=>Navigator.of(context).pop(),child: Text("Aceptar"),)
        ],
      );
      },
    );
    

  }

  int parseEntero(bool condicion){
    if(condicion){
      return 1;
    }else{
      return 0;
    }
  }
  bool parseBooleano(int condicion){
    if(condicion==1){
      return true;
    }else{
      return false;
    }
  }
  ThemeData changeTheme() {
    PreferenciasUsuario preferenciasUsuario=new PreferenciasUsuario();
    switch(preferenciasUsuario.tema){
      case 0:
      return ThemeData.dark();
      break;
      case 1:
      return ThemeData(primaryColor: Color(0xFF101C42),textSelectionColor: Color(0xFF101C42));
    }
  }  

  Future<bool> confirmar(BuildContext context,String contenido,String descripcion)async{
    bool estado;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(descripcion),
      title: Text(contenido),
      actions: <Widget>[
        RaisedButton(onPressed: (){
          estado=true;
          Navigator.of(context).pop();
        },child: Text("Si"),),
        RaisedButton(onPressed: (){
          estado=false;
          Navigator.of(context).pop();
        },child: Text("No"),),
      ],
    ));
    return estado;
  }
  Future<bool> salirApp(BuildContext context,String contenido,String descripcion)async{
    bool estado;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(descripcion),
      title: Text(contenido),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          onPressed: (){
          estado=true;
          //Navigator.of(context).pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },child: Text("Si"),),
        RaisedButton(
          color: Colors.green,
          onPressed: (){
          estado=false;
          Navigator.of(context).pop();
        },child: Text("No"),),
      ],
    ));
    return estado;
  }

  
}