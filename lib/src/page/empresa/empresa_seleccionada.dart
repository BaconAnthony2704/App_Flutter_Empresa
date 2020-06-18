import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/tema_provider.dart';
import 'package:provider/provider.dart';
class EmpresaSelected extends StatelessWidget {
  final String nombre,nit,giro,telefono,email,direccion,idempresa;
  final String departamento,municipio,urlImagen;
  final String nrc,data_facturacion,nombre_comercial;
  final int domicilio;
  EmpresaSelected({this.nombre="Empresa",this.departamento="-",this.municipio="-",
  this.nit="-",this.telefono="-",this.direccion="-",this.idempresa="-",this.urlImagen,
  this.email="-",this.giro="-",this.domicilio=0, this.nrc="-", this.data_facturacion="-",
   this.nombre_comercial="-"});
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
          height: size.height*.35,
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
        
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0),topLeft: Radius.circular(50.0)),
            child:FadeInImage(placeholder: AssetImage('assets/img/logo_placeholder.png'), 
            image:(urlImagen!="")?NetworkImage(urlImagen):AssetImage('assets/img/logo_placeholder.png'),
            height: 150,
            )
          ) ,
        )
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
                Environment().generarFila("Nombre comercial", "${this.nombre_comercial}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Identificacion tributaria","${this.nit}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("N.R.C", "${this.nrc}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Giro", "${this.giro}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Telefono", "${this.telefono}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Email", "${this.email}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Direccion", "${this.direccion}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Departamento", "${this.departamento}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Municipio", "${this.municipio}"),
                TableRow(children: [Divider(),Divider()]),
                Environment().generarFila("Data facturacion", "${this.data_facturacion}"),
                TableRow(children: [Divider(),Divider()]),
                
                (this.domicilio==1)
                ?TableRow(
                  children: [
                    Text("Domicilio"),
                    Icon(Icons.motorcycle)
                  ]
                )
                :Environment().generarFila("Domicilio", "No")
              ],
            ),
        )
     ],
      ),
   );
 }


}