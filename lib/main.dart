import 'package:flutter/material.dart';
import 'package:flutter_app/src/UI/AppColors.dart';
import 'package:flutter_app/src/pages/home_page.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
    theme: _buildTheme(),
  ));
}

_buildTheme() {
  return ThemeData.light().copyWith(primaryColor: AppColors.kindaMint);
}
