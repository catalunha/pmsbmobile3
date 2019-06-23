class Model{
  static final String collection = "";

  dynamic _referenciaFirestore;
  dynamic get ref => _referenciaFirestore;
  set ref (dynamic ref) => _referenciaFirestore = ref;

  @override
  String toString() {
    return toMap().toString();
  }

  Map<dynamic, dynamic> toMap(){
    return {};
  }
}
