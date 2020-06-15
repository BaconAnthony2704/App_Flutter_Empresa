import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';

class DataSearchProducto extends SearchDelegate{
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
   ProductoProvider productoProvider=Provider.of<ProductoProvider>(context);
   EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);

   return FutureBuilder<List<ProductoModel>>(
     future: productoProvider.obtenerTodosProductos(empresaProvider.idempresa),
     builder: (context,snapshot){
       if(!snapshot.hasData){
         return Center(child: CircularProgressIndicator(),);
       }
       if(snapshot.data.length==0){
         return Center(child: Text("No hay productos disponibles"),);
       }
       return ListView.builder(
         itemBuilder:(context,index){
           return ListTile(
             leading: (snapshot.data[index].urlimagen!=null)
             ?FadeInImage(placeholder: AssetImage('assets/img/silver_balls.gif'), 
             image: NetworkImage(snapshot.data[index].urlimagen))
             :Image(image: AssetImage('assets/img/no_product.png')),
             title: Text(snapshot.data[index].nombre),
             subtitle: Text(snapshot.data[index].precio.toString()),
             onTap: (){
               close(context, null);
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
    ProductoProvider productoProvider=Provider.of<ProductoProvider>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    if(query.isEmpty){
      return ListTile(
        leading: Image(image: AssetImage('assets/img/no_product.png'),
        width: 40.0,
        fit:BoxFit.contain,),
        title: Text("Producto"),
        subtitle: Text("Precio"),
      );
    }

    return FutureBuilder<List<ProductoModel>>(
     future: productoProvider.obtenerTodosProductos(empresaProvider.idempresa),
     builder: (context,snapshot){
       if(!snapshot.hasData){
         return Center(child: CircularProgressIndicator(),);
       }
       if(snapshot.data.length==0){
         return Center(child: Text("No hay productos disponibles"),);
       }
       return ListView.builder(
         itemBuilder:(context,index){
           return ListTile(
             leading: (snapshot.data[index].urlimagen.isNotEmpty)
             ?FadeInImage(placeholder: AssetImage('assets/img/silver_balls.gif'), 
             image: NetworkImage(snapshot.data[index].urlimagen))
             :Image(image: AssetImage('assets/img/no_product.png')),
             title: Text(snapshot.data[index].nombre),
             subtitle: Text(snapshot.data[index].precio.toString()),
             onTap: (){
               close(context, null);
             },
           );
       },
       itemCount: snapshot.data.length,
      );
     },
   );

    
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    final ThemeData theme=Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme
    );
  }

}