import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ContenedorPrincipalPromocion extends StatelessWidget {
  const ContenedorPrincipalPromocion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider=Provider.of<ProductProvider>(context);
    return Container(
      margin: Environment().metMargen5All,
      child: ListView.builder(
        itemBuilder: (context,index){
          return Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.chrome_reader_mode),
                  title: Text(productProvider.listaProductPromotion[index].titulo),
                  subtitle: Table(
                    children: [
                      Environment().generarFila("Precio",productProvider.listProduct[index].precio.toStringAsFixed(2)),
                      Environment().generarFila("Existencia", productProvider.listProduct[index].existencia.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ),
              Container(
                margin: Environment().metMargen5All,
                child: Icon(Icons.local_offer))
            ],
          );
        },
        itemCount: productProvider.listaProductPromotion.length,
      ),
    );
  }
}