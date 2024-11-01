import 'package:flutter/material.dart';

import '../../../core/theme/ui.dart';
 
class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get lightTheme => ThemeState(Themes.defaultTheme);
  static ThemeState get darkTheme => ThemeState(Themes.darkTheme);


}
