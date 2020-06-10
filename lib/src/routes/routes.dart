import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/page/cliente/cliente_home.dart';
import 'package:mantenimiento_empresa/src/page/empresa/actualizar_empresa.dart';
import 'package:mantenimiento_empresa/src/page/empresa/mi_empresa.dart';
import 'package:mantenimiento_empresa/src/page/home_page.dart';
import 'package:mantenimiento_empresa/src/page/login_page.dart';
import 'package:mantenimiento_empresa/src/page/producto/edit_product.dart';
import 'package:mantenimiento_empresa/src/page/producto/upload_product_excel.dart';
import 'package:mantenimiento_empresa/src/page/producto_page.dart';
import 'package:mantenimiento_empresa/src/page/register_page.dart';
import 'package:mantenimiento_empresa/src/page/usuario/edit_usuario.dart';
import 'package:mantenimiento_empresa/src/page/usuario/home_usuario.dart';
import 'package:mantenimiento_empresa/src/page/usuario/view_usuario.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
    return {
      '/':(BuildContext context)=>HomePage(),
      /*Empresa */
      'actualizar_empresa':(BuildContext context)=>ActualizarEmpresa(),

      'miempresa':(BuildContext context)=>MiEmpresaPage(),

      /*Producto */
      'inicio_producto':(BuildContext context)=>ProductoPage(),
      'edit_producto':(BuildContext context)=>EditProduct(),
      'upload_producto':(BuildContext context)=>UploadProductExcel(),

      /*Login */
      'login':(BuildContext context)=>LoginPage(),
      /*Registro*/
      'registro':(BuildContext context)=>RegisterPage(),

      /*Usuario */
      'usuario_home':(BuildContext context)=>UsuarioHome(),
      'edit_usuario':(BuildContext context)=>EditUsuario(),
      'view_usuario':(BuildContext context)=>ViewUsuario(),

      /*Cliente */
      'cliente_home':(BuildContext context)=>ClienteHomePage(),

    };
  }