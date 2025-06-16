import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

extension ThemeContext on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ScaleConfig get scaleConfig => ScaleConfig(this);
}
