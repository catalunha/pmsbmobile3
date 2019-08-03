import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PerguntaImagemArquivoBlocEvent {}

class RemoverArquivoUpdatePerguntaImagemArquivoBlocEvent
    extends PerguntaImagemArquivoBlocEvent {
  final PerguntaAplicadaArquivo arquivo;

  RemoverArquivoUpdatePerguntaImagemArquivoBlocEvent(this.arquivo);
}

class AdicionarUploadPerguntaImagemArquivoBlocEvent
    extends PerguntaImagemArquivoBlocEvent {
  final PerguntaAplicadaArquivo arquivo;

  AdicionarUploadPerguntaImagemArquivoBlocEvent(this.arquivo);
}

class AdicionarImagemPerguntaImagemArquivoBlocEvent
    extends PerguntaImagemArquivoBlocEvent {
  final String path;

  AdicionarImagemPerguntaImagemArquivoBlocEvent(this.path);
}

class AdicionarArquivosPerguntaImagemArquivoBlocEvent
    extends PerguntaImagemArquivoBlocEvent {
  final Map<String, String> arquivos;

  AdicionarArquivosPerguntaImagemArquivoBlocEvent(this.arquivos);
}

class PerguntaImagemArquivoBlocState {}

class PerguntaImagemArquivoBloc extends Bloc<PerguntaImagemArquivoBlocEvent,
    PerguntaImagemArquivoBlocState> {
  final fsw.Firestore _firestore;
  final PerguntaAplicadaModel _perguntaAplicada;
  final String _usuarioID;

  PerguntaImagemArquivoBloc(
      this._perguntaAplicada, this._usuarioID, this._firestore);

  @override
  PerguntaImagemArquivoBlocState getInitialState() {
    return PerguntaImagemArquivoBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaImagemArquivoBlocEvent event) async {
    if (event is AdicionarImagemPerguntaImagemArquivoBlocEvent) {
      final String name = event.path.split("/").last;
      final arquivo = PerguntaAplicadaArquivo(
        localPath: event.path,
        nome: name,
      );
      dispatch(AdicionarUploadPerguntaImagemArquivoBlocEvent(arquivo));
    }
    if (event is AdicionarArquivosPerguntaImagemArquivoBlocEvent) {
      event.arquivos.forEach(
        (nome, endereco) {
          final arquivo = PerguntaAplicadaArquivo(
            localPath: endereco,
            nome: nome,
          );
          dispatch(AdicionarUploadPerguntaImagemArquivoBlocEvent(arquivo));
        },
      );
    }
    if (event is AdicionarUploadPerguntaImagemArquivoBlocEvent) {
      final upload = UploadModel(
        usuario: _usuarioID,
        nome: event.arquivo.nome,
        localPath: event.arquivo.localPath,
        upload: false,
        updateCollection: UpdateCollection(
          collection: PerguntaAplicadaModel.collection,
          document: _perguntaAplicada.id,
          field: "arquivo.uploadID",
        ),
      );
      final ref = _firestore.collection(UploadModel.collection).document();
      ref.setData(upload.toMap(), merge: true);
      event.arquivo.uploadID = ref.documentID;
      _perguntaAplicada.arquivo[ref.documentID] = event.arquivo;
    }

    if (event is RemoverArquivoUpdatePerguntaImagemArquivoBlocEvent) {
      final ref = _firestore
          .collection(UploadModel.collection)
          .document(event.arquivo.uploadID);
      await ref.delete();
      _perguntaAplicada.arquivo.remove(event.arquivo.uploadID);
    }
  }
}
