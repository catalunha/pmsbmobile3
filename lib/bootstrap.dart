import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

import 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart'
    show Firestore;

class Boostrap {
  static final Boostrap instance = Boostrap(Firestore());
  final fsw.Firestore firestore;

  Boostrap(this.firestore);
}
