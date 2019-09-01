import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/models.dart';

class CacheService {
  final fw.Firestore _firestore;

  CacheService(this._firestore);

  load() async {
    await _firestore.collection(QuestionarioModel.collection).getDocuments();
    await _firestore.collection(QuestionarioAplicadoModel.collection).getDocuments();
    await _firestore.collection(PerguntaModel.collection).getDocuments();
    await _firestore.collection(PerguntaAplicadaModel.collection).getDocuments();
    await _firestore.collection(EixoModel.collection).getDocuments();
    await _firestore.collection(SetorCensitarioModel.collection).getDocuments();
  }
}
