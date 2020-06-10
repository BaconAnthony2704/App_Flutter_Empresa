import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
class ClienteHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.solidFileExcel), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Cargar archivos", "Desea cargar los archivos?");
            if(estado){
              Navigator.of(context).pushNamed('upload_cliente');
            }
            else{
              BotToast.showText(text: "Cancelado");
            }
          }),
        ],
      ),
      body: Center(child: Text("Cliente home"),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).textSelectionColor,
        onPressed: (){

        }
      ),
      drawer: MenuLateral(),
    );
  }
}