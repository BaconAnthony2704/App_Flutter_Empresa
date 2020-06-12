import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/page/menu/mas_acciones.dart';

PopupMenuButton mostrarPopupMenu({@required List<CustomPopupMenu> choices}){
  return PopupMenuButton(
    elevation: 3.2,
    itemBuilder: (context){
      return choices.map((CustomPopupMenu choice){
        return PopupMenuItem(
        value: choice,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(choice.icono),
          title: Text(choice.title),
          onTap: choice.funcion,
        ),
      );
      }).toList();
    });
}