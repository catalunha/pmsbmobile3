import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart'
    as ffsw;

import 'package:firebaseauth_wrapper/firebaseauth_wrapper.dart' as fbaw;
import 'package:firebaseauth_wrapper_flutter/firebaseauth_wrapper_flutter.dart'
    as ffbaw;

class Bootstrap {
  static final Bootstrap instance =
      Bootstrap(ffsw.Firestore(), ffsw.FieldValue(), ffbaw.FirebaseAuth());
  final fsw.Firestore firestore;
  final fbaw.FirebaseAuth auth;
  final fsw.FieldValue FieldValue;

  Bootstrap(this.firestore, this.FieldValue, this.auth);
}
