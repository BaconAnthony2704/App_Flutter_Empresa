import 'package:flutter/cupertino.dart';
import 'package:mantenimiento_empresa/src/models/product_model.dart';
import 'package:mantenimiento_empresa/src/models/tipo_producto_model.dart';
import 'package:mantenimiento_empresa/src/service/db_provider.dart';

class ProductProvider with ChangeNotifier{
  String consulta;
  List<ProductModel> listProduct=new List();
  List<ProductModel> listProductFilter=new List();
  List<ProductModel> listaProductPromotion=new List();
  ProductProvider(){
    loadProducts();
  }

  void loadProducts() {
    listProduct.clear();
    listProductFilter.clear();
    final pro1=new ProductModel(
      color: 0xFF101C42,
      descripcion: "Descripcion 1",
      detalle: "Es detalle del producto",
      existencia: 160.02,
      favorito: true,
      is_offer: true,
      precio: 36.0,
      titulo: "Spinach and tumeric soup",
    );

    final pro2=new ProductModel(
      color: 0xFFC01C32,
      descripcion: "Descripcion 2",
      detalle: "Es detalle del producto 2",
      existencia: 560.02,
      favorito: true,
      is_offer: false,
      precio: 39.0,
      titulo: "Cashew and sesame pancake",
    );


    final pro3=new ProductModel(
      color: 0xFF1B1DE2,
      descripcion: "Descripcion 3",
      detalle: "Es detalle del producto 3",
      existencia: 260.02,
      favorito: false,
      is_offer: false,
      precio: 36.0,
      titulo: "Polenta and cardamom muffins",
    );

    final pro4=new ProductModel(
      color: 0xFFABCE42,
      descripcion: "Descripcion 4",
      detalle: "Es detalle del producto 4",
      existencia: 760.02,
      favorito: false,
      is_offer: false,
      precio: 84.0,
      titulo: "Apricot and shank salad",
    );
    final pro5=new ProductModel(
      color: 0xFFABCE42,
      descripcion: "Descripcion 5",
      detalle: "Es detalle del producto 5",
      existencia: 60.02,
      favorito: false,
      is_offer: true,
      precio: 154.0,
      titulo: "Pastes de chocolate",
    );
    listaProductPromotion.addAll([
      pro1,
      pro5
    ]);

    listProduct.addAll([
      pro2,
      pro3,
      pro4,
    ]);
    notifyListeners();
  }

  List<ProductModel> buscarProducto(){
    listProductFilter.clear();
    this.listProduct.forEach((product) {
      if(product.titulo.toLowerCase().contains(this.consulta.toLowerCase())){
        listProductFilter.add(product);
      }
      if(this.consulta==null){
        listProductFilter=listProduct;
      }
     });
     notifyListeners();
     return listProductFilter;
  }
  void guardarQuery({@required String query=""}){
    this.consulta=query;
    notifyListeners();
  }

  void limpiarFiltro(){
    this.listProductFilter.clear();
    notifyListeners();
  }

  void searchProduct(String query){
    listProductFilter.clear();
    this.listProduct.forEach((pro) {
      if(pro.titulo.toLowerCase().contains(query.toLowerCase())){
        listProductFilter.add(pro);
      }
     });
     notifyListeners();
  }

  void eliminarProducto(int index){
    this.listProduct.removeAt(index);
    notifyListeners();
  }

  Future<int> ingresarTipoProducto(TipoProductoModel tipoProductoModel)async{
    int valor=await DBProvider.db.crearTipoProducto(tipoProductoModel);
    return valor;
  }

  Future<List<TipoProductoModel>> getTodosTipoProducto(int idEmpresa)async{
    List<TipoProductoModel> listado=await DBProvider.db.getTodosTipoProductos(idEmpresa);
    return listado;
  }


  
}