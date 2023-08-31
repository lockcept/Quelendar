import 'package:flutter/material.dart';

Color calculateFocusColor(Color baseColor, {double brightnessDelta = 0.2}) {
  double newBrightness = baseColor.computeLuminance() + brightnessDelta;

  newBrightness = newBrightness.clamp(0.0, 1.0);

  return HSLColor.fromColor(baseColor).withLightness(newBrightness).toColor();
}
