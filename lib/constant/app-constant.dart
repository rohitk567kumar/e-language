// ignore: file_names
import 'package:flutter/material.dart';

class AppColors {
  static const Color secondaryColor = Color(0xFF3498db); // Moderate Blue
  static const Color primaryColor =     Color(0xFF2ecc71); // Emerald Green
  static const Color accentColor = Color(0xFFe74c3c); // Alizarin Red
  static const Color backgroundColor = Color(0xFFecf0f1);// Light Gray
  static const Color textColor = Color(0xFF2c3e50); // Dark Slate Gray
}
class AppConstants {
  static const String appName = "E Language"; // Example app name
}


double getResponsiveSizeWidh(BuildContext context, double widthFraction) {
  return MediaQuery.of(context).size.width * widthFraction;
}

double getResponsiveSizeHieght(BuildContext context, double heightFraction) {
  return MediaQuery.of(context).size.height * heightFraction;
}
double getResponsiveFontSize(BuildContext context, double fontFraction) {
  return MediaQuery.of(context).size.width * fontFraction;
}
