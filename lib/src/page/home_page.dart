import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/page/dashboard/dashboard_page.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    
    final prefs=PreferenciasUsuario();
    return FutureBuilder<EmpresaModel>(
      future: empresaProvider.obtenerEmpresaFi(),
      builder: (context,snapshot){
        
        if(snapshot.data==null){
          return Scaffold(
              appBar: AppBar(
                title: Text("Crear Empresa"),
                actions: <Widget>[
                  IconButton(icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: (){
                    prefs.ultimaPagina='login';
                    Navigator.of(context).pushReplacementNamed('login');
                  })
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).textSelectionColor,
                onPressed: (){
                  Navigator.of(context).pushNamed('actualizar_empresa');
                }
              ),
            );
        }

        if(!snapshot.hasData){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
          
        }
        
          return Scaffold(
            drawer: MenuLateral(),
            appBar: AppBar(
              title: Text(snapshot.data.nombre),
              centerTitle: true,
            ),
            body: DashboardPage(),
          );
        
      },
    );
  }
  //   return Scaffold(
  //           drawer: MenuLateral(),
  //           appBar: AppBar(
  //             title: Text("Empresa"),
  //             centerTitle: true,
  //           ),
  //           body: Center(child: Text("Inicio"),),
  //         );
  // }
}

