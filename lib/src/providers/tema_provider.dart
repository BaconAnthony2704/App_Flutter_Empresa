import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
class TemaProvider with ChangeNotifier{
  bool _darkTheme;
  ThemeData _currentTheme;
  Color _color1;
  Color _color2;
  PreferenciasUsuario _prefs=new PreferenciasUsuario();
  Color get color1=>this._color1;
  Color get color2=>this._color2;
  bool get darkTheme =>this._darkTheme;
  ThemeData get currentTheme =>this._currentTheme;
  TemaProvider(){
    switch(_prefs.tema){
      case 0:
      _darkTheme=false;
      _color1=Color(0xFF6782B4);
      _color2=Color(0xFFB1BFD8);
      _currentTheme=ThemeData(primaryColor: Color(0xFF101C42),textSelectionColor: Color(0xFF101C42));
      break;
      case 1:
      _color1=Color(0xFF0BAB64);
      _color2=Color(0xFF3BB78F);
      
      _darkTheme=true;
      _currentTheme=ThemeData.dark();
      break;
    }
  }

  set darkTheme(bool value){
    _darkTheme=value;
    if(value){
      _currentTheme=ThemeData.dark();
      
      _color1=Color(0xFF0BAB64);
      _color2=Color(0xFF3BB78F);
    }else{
      _color1=Color(0xFF6782B4);
      _color2=Color(0xFFB1BFD8);
      _currentTheme=ThemeData(primaryColor: Color(0xFF101C42),textSelectionColor: Color(0xFF101C42));
    }
    notifyListeners();
  }
  



  
}