import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom scroll behavior to allow dragging with mouse.
/// Necessary to allow dragging with mouse on Continents carousel.
class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    // Allow to drag with mouse on Regions carousel
    PointerDeviceKind.mouse,
  };
}
