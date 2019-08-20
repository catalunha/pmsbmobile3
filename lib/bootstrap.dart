import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart'
    as fswfm;

import 'package:firebaseauth_wrapper/firebaseauth_wrapper.dart' as faw;
import 'package:firebaseauth_wrapper_flutter/firebaseauth_wrapper_flutter.dart'
    as fawf;

class Bootstrap {
  static final Bootstrap instance =
      Bootstrap(fswfm.Firestore(), fswfm.FieldValue(), fawf.FirebaseAuth());
  final fsw.Firestore firestore;
  final faw.FirebaseAuth auth;
  final fsw.FieldValue FieldValue;

  Bootstrap(this.firestore, this.FieldValue, this.auth);
}
