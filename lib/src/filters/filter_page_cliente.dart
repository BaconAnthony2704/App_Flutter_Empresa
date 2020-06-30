import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/filters/filter_cliente.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';

class FilterPageCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FilterCliente filterCliente=Provider.of<FilterCliente>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    return Scaffold(

      appBar: AppBar(
        title: Text("Filtrar"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: (){
            filterCliente.crearConsultaFiltro(empresaProvider.idempresa);
            Navigator.pop(context);
          })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              filterCliente.checkbox(),
              filterCliente.filtro(context),
              filterCliente.radio(),
              filterCliente.filtro(context),
              filterCliente.radio(),
              filterCliente.filtro(context),
              filterCliente.radio(),
              filterCliente.filtro(context),
              filterCliente.radio(),
              filterCliente.filtro(context),
            ],
          ),
        ),
      ),
    );
  }
}