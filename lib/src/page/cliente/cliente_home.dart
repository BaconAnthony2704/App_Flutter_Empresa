import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
class ClienteHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.solidFileExcel), onPressed: (){}),
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