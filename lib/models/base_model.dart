
/// classe base para todos os modelos de dados originados no firestore
abstract class FirestoreModel{

  static final String collection = null;

  String id;

  FirestoreModel(this.id);

  Map<String, dynamic> toMap();

  FirestoreModel fromMap(Map<String, dynamic> map);

  @override
  String toString() {
    return toMap().toString();
  }
}
