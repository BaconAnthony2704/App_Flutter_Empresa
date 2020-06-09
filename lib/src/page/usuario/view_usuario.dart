import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
class ViewUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UsuarioModel usuarioModel=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuario"),
      ),
      body: Container(
        margin: Environment().metMargen5All,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: Text("${usuarioModel.nombre.toUpperCase()}"),
              subtitle: Text("${usuarioModel.email.toLowerCase()}"),
              trailing: CircleAvatar(child: Text("${usuarioModel.nombre.toUpperCase()[0]}"),),
            ),
            ListTile(
              title: Text("Activo"),
              trailing: Checkbox(value: Environment().parseBooleano(usuarioModel.activo), onChanged: (value){
              }),
            ),
            ListTile(
              title: Text("Puede consultar"),
              trailing: Checkbox(value: Environment().parseBooleano(usuarioModel.doread), onChanged: (value){
              }),
            ),
            ListTile(
              title: Text("Puede crear"),
              trailing: Checkbox(value: Environment().parseBooleano(usuarioModel.docreate), onChanged: (value){
              }),
            ),
            ListTile(
              title: Text("Puede actualizar"),
              trailing: Checkbox(value: Environment().parseBooleano(usuarioModel.doupdate), onChanged: (value){
              }),
            ),
            ListTile(
              title: Text("Puede eliminar"),
              trailing: Checkbox(value: Environment().parseBooleano(usuarioModel.dodelete), onChanged: (value){
              }),
            ),
          ],
        ),
      ),
      
    );
  }
  
}

