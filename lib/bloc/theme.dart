import 'package:flutter/material.dart';

enum ThemeStatus{DARK, LIGHT}
class ThemeChanger with ChangeNotifier {
  ThemeStatus _themeStatus;

  ThemeChanger(this._themeStatus);
  ThemeData _themeData;


  ThemeData dark = ThemeData.dark().copyWith(
    cardColor: Colors.grey[700],
    appBarTheme: AppBarTheme(color: Colors.black45),
    primaryColor: Color(0xFF44A8B2),
    backgroundColor: Color(0xFF303030),
    accentColor: Color(0xFF44A8B2)
  );

  ThemeData light = ThemeData.light().copyWith(
    cardColor: Colors.white54,
    appBarTheme: AppBarTheme(color: Color(0xFF44A8B2)),
    backgroundColor: Color(0xffd5e0e0),
    primaryColor: Color(0xFF44A8B2),
    scaffoldBackgroundColor: Color(0xffd5e0e0)
    
  );

  get getTheme => _themeData;
  get getThemeStatus => _themeStatus;

  setTheme(ThemeStatus theme) {
      if(theme == ThemeStatus.DARK){
        _themeData = dark;
      }else{
        _themeData = light;
      }
      _themeStatus = theme;
      print(theme.toString());
      notifyListeners();
  }
}
