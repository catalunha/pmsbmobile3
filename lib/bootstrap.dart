import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart';

class Bootstrap {
  static final Bootstrap instance = Bootstrap(Firestore());
  final fsw.Firestore firestore;

  Bootstrap(this.firestore);
}
