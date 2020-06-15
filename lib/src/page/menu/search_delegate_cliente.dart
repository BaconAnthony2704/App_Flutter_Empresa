import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';
class DataSearchCliente extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {
   //Accion que lleva nuestra busqueda
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query="";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquieda del app bar
    return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, 
    progress: transitionAnimation), onPressed: (){
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    //Los resultados que vamos a crear
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    ClienteProvider clienteProvider=Provider.of<ClienteProvider>(context);
    return FutureBuilder<List<ClienteModel>>(
      future: clienteProvider.buscarCliente(empresaProvider.idempresa, query),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data.length==0){
          return Center(child: Text("No hay cliente disponible"),);
        }
        return ListView.builder(
          itemBuilder:(context,index){
            return ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text(snapshot.data[index].nombre),
              subtitle: Text(snapshot.data[index].telefono),
              onTap: (){
                clienteProvider.consultaP=query;
                close(context,null);
                clienteProvider.notifyListeners();
              },
            );
          },
          itemCount: snapshot.data.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que vamos a buscar
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    ClienteProvider clienteProvider=Provider.of<ClienteProvider>(context);
    if(query.isEmpty){
      return ListTile(
        leading: Icon(Icons.supervised_user_circle),
        title: Text("Cliente"),
        subtitle: Text("Telefono"),
      );
    }
    return FutureBuilder<List<ClienteModel>>(
      future: clienteProvider.buscarCliente(empresaProvider.idempresa, query),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data.length==0){
          return Center(child: Text("No hay cliente disponible"),);
        }
        return ListView.builder(
          itemBuilder:(context,index){
            return ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text(snapshot.data[index].nombre),
              subtitle: Text(snapshot.data[index].telefono),
              onTap: (){
                clienteProvider.consultaP=query;
                close(context,null);
                clienteProvider.notifyListeners();
              },
            );
          },
          itemCount: snapshot.data.length,
        );
      },
    );

  }


}