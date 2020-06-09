import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class ProductoProvider with ChangeNotifier{
  ProductoProvider();

  Future<int> insertarProducto(ProductoModel productoModel)async{
    int crear=await DBProvider.db.crearProducto(productoModel);
    notifyListeners();
    return crear;
  }
  Future<int> insertarProductoSinNotificar(ProductoModel productoModel)async{
    int crear=await DBProvider.db.crearProducto(productoModel);
    return crear;
  }

  Future<List<ProductoModel>> obtenerTodosProductos(int idempresa)async{
    List<ProductoModel>lista= await DBProvider.db.getTodosProductos(idempresa);
    //notifyListeners();
    return lista;
  }
  Future<String> subirImagen(File imagen)async{
    final url=Uri.parse('https://api.cloudinary.com/v1_1/dunsiuhtb/image/upload?upload_preset=g3ygbk4x');
    final mimeType=mime(imagen.path).split('/');//image/jpg
    final imageUploadReq=http.MultipartRequest(
      'POST',
      url
    );
    final file=await http.MultipartFile.fromPath('file', imagen.path,
    contentType: MediaType(mimeType[0],mimeType[1]));
    imageUploadReq.files.add(file);

    final streamResponse=await imageUploadReq.send();
    final resp=await http.Response.fromStream(streamResponse);
    if(resp.statusCode!=200 && resp.statusCode!=201){
      print("Algo salio mal");
      print(resp.body);
      return null;
    }
    final respData=json.decode(resp.body);
    return respData['secure_url'];

  }

  Future<int> actualizarProducto(ProductoModel productoModel)async{
    int update=await DBProvider.db.updateProducto(productoModel);
    notifyListeners();
    return update;
  }
}