import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
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
              child: Container(
                height: MediaQuery.of(context).size.height*.5,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: "Half yearly sales analysis"),
                  legend: Legend(isVisible:true),
                  tooltipBehavior: TooltipBehavior(
                    enable: true
                  ),
                  series:<LineSeries<SalesData,String>>[
                    LineSeries<SalesData,String>(
                      dataSource:<SalesData>[
                        SalesData('Jan', 35),
                        SalesData('Feb', 25),
                        SalesData('Mar', 31),
                        SalesData('Apr', 34),
                        SalesData('May', 48)
                      ], 
                      xValueMapper: (SalesData sales,_)=>sales.year, 
                      yValueMapper: (SalesData sales,_)=>sales.sales,
                      dataLabelSettings: DataLabelSettings(isVisible: true)
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      height: MediaQuery.of(context).size.height*.3,
                      child: SfCircularChart(
                        title: ChartTitle(text:"Productos en existencias"),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries<SalesData,String>>[
                          PieSeries<SalesData,String>(
                            enableTooltip: true,
                            dataSource: [
                              SalesData('Jan', 35,color: Colors.red),
                              SalesData('Feb', 25,color: Colors.blue),
                              SalesData('Mar', 31,color: Colors.purple),
                              SalesData('Apr', 34,color: Colors.yellow),
                              SalesData('May', 48,color: Colors.orange)
                            ],
                            pointColorMapper: (SalesData sales,_)=>sales.color,
                            xValueMapper: (SalesData sales,_)=>sales.year,
                            yValueMapper: (SalesData sales,_)=>sales.sales
                          )
                        ],
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

class SalesData{
  SalesData(this.year,this.sales,{this.color=Colors.green});

  final String year;
  final double sales;
  final Color color;
}