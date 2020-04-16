import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

abstract class PageSizeMap {}

class PageSizeMapController {
  final PageSizeMap webPageSizeMap;
  final PageSizeMap mobileSizeMap;

  PageSizeMapController({
    @required this.webPageSizeMap,
    @required this.mobileSizeMap,
  });

  definirSizeMap() {
    if (kIsWeb) {
      return this.webPageSizeMap;
    } else {
      return this.mobileSizeMap;
    }
  }
}

// class PageSizeMapController {
//   final PageSizeMap webPageSizeMap;
//   final PageSizeMap mobileSizeMap;

//   PageSizeMapController({
//     @required this.webPageSizeMap,
//     @required this.mobileSizeMap,
//   });

//   definirSizeMap() {
//     if (kIsWeb) {
//       return this.webPageSizeMap;
//     } else {
//       return this.mobileSizeMap;
//     }
//   }
// }
