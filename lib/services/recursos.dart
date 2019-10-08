import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:pmsbmibile3/services/recursos/io.dart'
    if (dart.library.html) "package:pmsbmibile3/services/recursos/html.dart";

const Map<String, List<String>> BIBLIOTECAS = {
  "path_provider": ["android", "ios"],
  "pdf": ["android", "ios", "web"],
  "uuid": ["android", "ios", "web"],
  "rxdart": ["android", "ios", "web"],
  "validators": ["android", "ios", "web"],
  "firestore_wrapper_flutter": ["android", "ios", "web"],
  "location": ["android", "ios"],
  "cupertino_icons": ["android", "ios", "web"],
  "provider": ["android", "ios", "web"],
  "google_sign_in": ["android", "ios"],
  "firebase_core": ["android", "ios"],
  "firebase_auth": ["android", "ios"],
  "cloud_firestore": ["android", "ios"],
  "firebase_storage": ["android", "ios"],
  "firebase_messaging": ["android", "ios"],
  "file_picker": ["android", "ios"],
  "flutter_markdown": ["android", "ios"],
  "mime": ["android", "ios", "web"],
  "url_launcher": ["android", "ios"],
  "image_picker": ["android", "ios"],
  "image": ["android", "ios", "web"],
  "image_picker_saver": ["android", "ios"],
  "image_gallery_saver": ["android", "ios"],
  "csv": ["android", "ios", "web"],
  "open_file": ["android", "ios"],
  "markdown": ["android", "ios", "web"],
  "flutter_html_to_pdf": ["android", "ios"],
  "webview_flutter": ["android", "ios"],
  "permission_handler": ["android", "ios"],
  "queries": ["android", "ios", "web"],
  "flutter_local_notifications": ["android", "ios"],
  "fixnum": ["android", "ios", "web"],
};

const RECURSOS = {
  "gps": [
    "location",
  ],
  "firestore": [
    "firestore_wrapper_flutter",
  ],
  "armazenamento": [],
  "file_picking": [
    "image_picker",
  ],
};

class Recursos {
  static Recursos instance;

  static void initialize(TargetPlatform plataforma) {
    switch (plataforma) {
      case TargetPlatform.android:
        Recursos.instance = Recursos._(PLATFORM == "io" ? "android" : "web");
        break;
      case TargetPlatform.fuchsia:
        Recursos.instance = Recursos._(PLATFORM == "io" ? "fuchsia" : "web");
        break;
      case TargetPlatform.iOS:
        Recursos.instance = Recursos._(PLATFORM == "io" ? "ios" : "web");
        break;
      default:
        Recursos.instance = Recursos._("fuchsia");
        break;
    }
  }

  final String plataforma;

  Recursos._(this.plataforma);

  bool disponivel(String recurso) {
    final libs = RECURSOS[recurso];
    for (var r in libs) if (!BIBLIOTECAS[r].contains(plataforma)) return false;
    return true;
  }

  bool disponivelList(List<String> recursos) {
    for (var r in recursos) {
      if (!disponivel(r)) return false;
    }
    return true;
  }
}
