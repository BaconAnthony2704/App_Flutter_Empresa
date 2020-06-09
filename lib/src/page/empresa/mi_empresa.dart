import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/page/empresa/empresa_seleccionada.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';

class MiEmpresaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    
    final prefs=new PreferenciasUsuario();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          (empresaProvider.empresa)
          ?IconButton(icon: Icon(Icons.edit), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Actualizar", "Desea actualizar");
            if(estado){
              //Actualizar
              EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
              Navigator.of(context).pushNamed('actualizar_empresa',arguments: empresaModel);
            }
          })
          :Container(),
          (empresaProvider.empresa)
          ?IconButton(icon: Icon(Icons.delete), onPressed:()async{
            bool estado=await Environment().confirmar(context, "Borrar", "Desea borrar?");
            if(estado){
              bool verifica=await empresaProvider.verificarIntegridad(empresaProvider.idempresa);
              if(verifica){
                BotToast.showText(text: "No se puede eliminar porque existe usuarios referenciados.");
              }
              else{
                BotToast.showText(text: "Eliminado");
                await empresaProvider.eliminarEmpresa();
                Navigator.of(context).pop(true);
                Navigator.of(context).pushReplacementNamed('/');
              }
              
            }
          })
          :Container(),
          
        ],
      ),
      drawer: MenuLateral(),
      body: FutureBuilder(
        future: empresaProvider.obtenerEmpresaFi(),
        builder: (BuildContext context,AsyncSnapshot<EmpresaModel>snapshot){
          if(!snapshot.hasData && snapshot.data!=null){
            return Center(child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).textSelectionColor,
            ));  
          }
          if(snapshot.data==null){
            return Center(child: Text("Crear Empresa"));
          }
          return EmpresaSelected(
            idempresa: snapshot.data.idempresa.toString(),
            nombre: snapshot.data.nombre,
            direccion: snapshot.data.direccion,
            domicilio: snapshot.data.isdomicilio,
            email: snapshot.data.email,
            giro: snapshot.data.giro,
            nit: snapshot.data.nit,
            departamento: snapshot.data.departamento,
            municipio: snapshot.data.municipio,
            urlImagen: snapshot.data.url_imagen,
            telefono: snapshot.data.telefono,);

        },
      ),
      floatingActionButton: (!empresaProvider.empresa)?
      FloatingActionButton(
        backgroundColor: Theme.of(context).textSelectionColor,
        child: Icon(Icons.add),onPressed: (){
          Navigator.of(context).pushNamed('actualizar_empresa');
        },
      )
      :Container(),
    );
  }
}