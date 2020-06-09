import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/company_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/product_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/providers/tema_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/routes/routes.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';
 
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs=PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(
    ChangeNotifierProvider<TemaProvider>(create: (_)=>TemaProvider(),
    child: MyApp(),),
  );
}
 
class MyApp extends StatelessWidget {
  final prefs=new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    final temaProvider=Provider.of<TemaProvider>(context).currentTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context)=>CompanyProvider()),
        ChangeNotifierProvider(create: (BuildContext context)=>ProductProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=>EmpresaProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=>UsuarioProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=>ProductoProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=>DepartamentoProvider(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: prefs.ultimaPagina,
        routes: getApplicationRoutes(),
        builder: BotToastInit(),
        theme:  temaProvider,
      ),
    );
  }

  
}