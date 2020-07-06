import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/existencia_categoria.dart';
import 'package:mantenimiento_empresa/src/models/existencia_tipo.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    ProductoProvider productoProvider=Provider.of<ProductoProvider>(context);
    ClienteProvider clienteProvider=Provider.of<ClienteProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: Environment().metMargen5All,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10.0,
              child: FutureBuilder<List<ExistenciaPorTipoModel>>(
                future: productoProvider.obtnerExistenciaPorTipo(empresaProvider.idempresa),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Container(
                      height: MediaQuery.of(context).size.height*.5,
                      child: Center(
                        child: CircularProgressIndicator(),)
                    );
                  }
                  if(snapshot.data.length==0){
                    return Container(
                      height: MediaQuery.of(context).size.height*.5,
                      child: Center(
                        child: Text("No se pudo obtener los datos"),
                      ),
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height*.5,
                    child: SfCartesianChart(

                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: "Existencia por tipo"),
                      legend: Legend(isVisible:true),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ),
                      series:[
                        LineSeries(
                          legendItemText: "Existencia",
                          isVisibleInLegend: false,
                          name: "Existencia",
                          dataSource: snapshot.data.map((e){
                            return ExistenciaPorTipoModel(tipo: e.tipo,valor: e.valor);
                          }).toList(), 
                          xValueMapper: (ExistenciaPorTipoModel existencia,_)=>existencia.tipo, 
                          yValueMapper: (ExistenciaPorTipoModel existencia,_)=>existencia.valor,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      height: MediaQuery.of(context).size.height*.3,
                      child: FutureBuilder<List<ExistenciaPorCategoriaModel>>(
                        future: productoProvider.obtnerExistenciaPorCategoria(empresaProvider.idempresa),
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          if(snapshot.data.length==0){
                            return Center(child: Text("No hay existencia disponibles"),);
                          }
                          return SfCircularChart(
                            title: ChartTitle(text:"Productos por categoria"),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series:[
                              PieSeries<ExistenciaPorCategoriaModel,String>(
                                enableTooltip: true,
                                dataSource: snapshot.data.map((e){
                                  return ExistenciaPorCategoriaModel(categoria: e.categoria,valor: e.valor,color: Color(int.parse(Environment().generateRandomHexColor(),radix: 16)));
                                }).toList(),
                                pointColorMapper: (ExistenciaPorCategoriaModel e,_)=>e.color,
                                xValueMapper: (ExistenciaPorCategoriaModel e,_)=>e.categoria,
                                yValueMapper: (ExistenciaPorCategoriaModel e,_)=>e.valor
                              )
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 10.0,
                        child: Container(
                          height: MediaQuery.of(context).size.height*.15,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text("Productos en Stock",textAlign: TextAlign.end,),
                                FutureBuilder<double>(
                                  initialData: 0,
                                  future: productoProvider.obtenerProductoStock(empresaProvider.idempresa),
                                  builder: (context,snapshot){
                                  if(!snapshot.hasData){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return Text("${snapshot.data}",style: TextStyle(fontSize: 30),);
                                }),
                                Text("Total de Stock",textAlign: TextAlign.end,),
                                FutureBuilder<double>(
                                  initialData: 0,
                                  future: productoProvider.obtenerPrecioStock(empresaProvider.idempresa),
                                  builder: (context,snapshot){
                                  if(!snapshot.hasData){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return Text("\$ ${snapshot.data}",style: TextStyle(fontSize: 25),);
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 10.0,
                        child: Container(
                          height: MediaQuery.of(context).size.height*.15,
                          child: Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,  
                            children: <Widget>[
                              Text("Cliente potenciales"),
                              FutureBuilder<double>(
                                initialData: 0,
                                future: clienteProvider.obtenerClientePotencial(empresaProvider.idempresa),
                                builder: (context,snapshot){
                                  if(!snapshot.hasData){
                                    return CircularProgressIndicator();
                                  }
                                  return Text("${snapshot.data}",style: TextStyle(fontSize: 30),);
                                })
                            ],
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
