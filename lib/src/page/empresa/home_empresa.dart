import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/page/empresa/contenedor_principal.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
class HomeEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text("Empresa"),
      ),
      body: ContenedorPrincipal(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).textSelectionColor,
        onPressed: (){
          Navigator.of(context).pushNamed('edit_empresa');
        }
      ),
    );
  }
}

