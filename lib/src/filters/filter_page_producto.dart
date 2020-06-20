import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/filters/filter_producto.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';

class FilterPageProducto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FilterProducto filterProducto=Provider.of<FilterProducto>(context);
    EmpresaProvider empresaProvider=Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtrar"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: (){
            filterProducto.crearConsultaFiltro(empresaProvider.idempresa);
            Navigator.pop(context);
          })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              filterProducto.checkbox(),
              Divider(),
              filterProducto.filtro(context),
              filterProducto.radio(),
              Divider(),
              filterProducto.filtro(context),
              filterProducto.radio(),
              Divider(),
              filterProducto.filtro(context),
              filterProducto.radio(),
              Divider(),
              filterProducto.filtro(context),
            ],
          ),
        ),
      ),
    );
  }
}