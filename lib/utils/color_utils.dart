import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorManager {
  static final ColorManager _instance = ColorManager._internal();

  ColorManager._internal();

  static ColorManager get instance => _instance;

  Color _currentColor = Colors.blue;

  Color get currentColor => _currentColor;

  Future<void> initializeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('app_bar_color') ?? Colors.blue.value;
    _currentColor = Color(colorValue);
  }

  Future<void> setColor(Color color) async {
    _currentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_bar_color', color.value);
  }
}
