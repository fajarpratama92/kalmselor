import 'package:flutter/material.dart';
import 'package:counselor/widget/persistent_tab/curve_type.dart';

class NeumorphicProperties {
  final double bevel;
  final double borderRadius;
  final BoxBorder? border;
  final BoxShape shape;
  final CurveType curveType;
  final bool showSubtitleText;

  const NeumorphicProperties({
    this.bevel = 12.0,
    this.borderRadius = 15.0,
    this.border,
    this.shape = BoxShape.rectangle,
    this.curveType = CurveType.concave,
    this.showSubtitleText = false,
  });
}
