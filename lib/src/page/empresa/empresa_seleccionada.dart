import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/tema_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as m;
class EmpresaSelected extends StatelessWidget {
  String nombre,nit,giro,telefono,email,direccion,idempresa;
  int domicilio;
  EmpresaSelected({this.nombre="Empresa",
  this.nit="-",this.telefono="-",this.direccion="-",this.idempresa="-",
  this.email="-",this.giro="-",this.domicilio=0});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _fondo(context),
        _recuadro(context),
      ],
    );
  }

  Widget _fondo(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final temaProvider=Provider.of<TemaProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: size.height*.40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.bottomCenter,
              colors: [
                temaProvider.color1,
                temaProvider.color2
              ]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0))
          ),
        ),
        Positioned(
          top: 20,
          left: 30,
          child: Container(
            width: size.width*.75,
            child: Text("${this.nombre}",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: size.height*.05,),)
          ),
        ),
        (this.domicilio==1)?
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0)),
            child: Icon(Icons.motorcycle,size: size.height*.2,color: Theme.of(context).textTheme.headline6.color.withOpacity(0.5),)),
        )
        :Container()
      ],
    );
  }

 Widget _recuadro(BuildContext context) {
   final size=MediaQuery.of(context).size;
   return SingleChildScrollView(
     child: Column(
       children: <Widget>[
         SafeArea(child: Container(height: 200.0,)),
         Container(
            width: size.width*.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).cardColor,
                Theme.of(context).canvasColor
              ]),
              boxShadow: [
                BoxShadow(color:Theme.of(context).primaryColorDark.withOpacity(0.5),
                blurRadius: 3.0,
                offset: Offset(0.0, 5.0),
                spreadRadius: 3.0)
              ]
            ),
            child: Table(
              children: [
                Environment().generarFila("NIT","${this.nit}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Giro", "${this.giro}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Telefono", "${this.telefono}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Email", "${this.email}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Direccion", "${this.direccion}")
              ],
            ),
        )
     ],
      ),
   );
 }


}