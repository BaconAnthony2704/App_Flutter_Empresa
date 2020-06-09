import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/company_model.dart';
import 'package:mantenimiento_empresa/src/providers/company_provider.dart';
import 'package:provider/provider.dart';
class ContenedorPrincipal extends StatelessWidget {
  const ContenedorPrincipal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CompanyProvider companyProvider=Provider.of<CompanyProvider>(context);
    return Container(
      margin: Environment().metMargen5All,
      width: double.infinity,
      height: double.infinity,
      child: ListView.builder(
        itemCount: companyProvider.listaCompany.length,
        itemBuilder: (context,index){
          return Dismissible(
            key: ValueKey('${companyProvider.listaCompany}'),
            child: empresa(companyProvider, index, context),
            background: Container(color: Colors.red.withOpacity(0.8),child: Icon(Icons.delete_forever,
            color: Environment().metColor,),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direccion){
              if(DismissDirection.startToEnd==direccion){
                //print("Eliminar ${index}");
                String estado=companyProvider.deleteCompany(index);
                BotToast.showText(text: estado);
              }
              
            },
          );
        },

      ),
    );
  }

  Column empresa(CompanyProvider companyProvider, int index, BuildContext context) {
    return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: Icon(Icons.business),
                    title: Text(companyProvider.listaCompany[index].nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(companyProvider.listaCompany[index].giro),
                        (companyProvider.listaCompany[index].isdelivery)
                        ?Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.motorcycle),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text("Domicilio"))
                          ],
                        )
                        :Container()
                      ],
                    ),
                    onTap: (){
                      Navigator.of(context).pushNamed('edit_empresa',arguments: companyProvider.listaCompany[index]);
                    },
                  ),
                ),
                Container(child: (companyProvider.listaCompany[index].favorito)
                ?Icon(Icons.star,color: Theme.of(context).textSelectionColor,)
                :Container()
                )
              ],
            ),
            Divider(color: Theme.of(context).textTheme.headline1.color,),
          ],
        );
  }
}