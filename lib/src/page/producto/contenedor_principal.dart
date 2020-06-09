import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';

class ContenedorPrincipal extends StatelessWidget {
  const ContenedorPrincipal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario prefs=PreferenciasUsuario();
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    ProductoProvider productoProvider=Provider.of<ProductoProvider>(context);
    int idempresa=Provider.of<EmpresaProvider>(context).idempresa;
    return FutureBuilder<List<ProductoModel>>(
      future: productoProvider.obtenerTodosProductos(idempresa),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data.length==0){
          return Center(child: Text("Agregar producto(s)"),);
        }
        return Container(
          margin: Environment().metMargen5All,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index){
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: (snapshot.data[index].urlimagen.isNotEmpty)
                ?FadeInImage(placeholder: AssetImage('assets/img/silver_balls.gif'), 
                image: NetworkImage(snapshot.data[index].urlimagen),
                fit: BoxFit.cover,
                width: 70,)
                :Image(image: AssetImage('assets/img/no_product.png'),
                width: 70,
                fit: BoxFit.cover,),
                title: Text(snapshot.data[index].nombre.toUpperCase()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(snapshot.data[index].descripcion),
                    Table(
                      children: [
                        Environment().generarFila("Precio","\$ "+snapshot.data[index].precio.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
                onTap: ()async{
                  UsuarioModel usuarioModel=await usuarioProvider.obtenerUnUsuarioParaMenu(prefs.idusuario);
                  if(usuarioModel.doupdate==0 && usuarioModel.dodelete==0){
                    await Environment().mostrarAlerta(context,"Solicite permisos del administrador");
                  }else{
                    Navigator.of(context).pushNamed('edit_producto',arguments: snapshot.data[index]);
                  }
                  
                },
              );
            },
            itemCount: snapshot.data.length,
          ),
        );
      },
    );
  }

  
}