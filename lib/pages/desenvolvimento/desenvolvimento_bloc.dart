import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PageEvent {}

class UpdateArquivoEvent extends PageEvent {
  final String idUpload;

  UpdateArquivoEvent(this.idUpload);
}

class UpdateUploadModelEvent extends PageEvent {
  final UploadModel uploadModel;

  UpdateUploadModelEvent(this.uploadModel);
}

class DeleteArquivoEvent extends PageEvent {
  final String arquivo;

  DeleteArquivoEvent(this.arquivo);
}

class SaveEvent extends PageEvent {}

class PageState {
  String arquivo;
  UploadModel uploadModel;
  Map<String, UploadBloc> uploading = Map<String, UploadBloc>();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arquivo'] = this.arquivo;
    data['uploadModel'] = this.uploadModel.toMap();
    return data;
  }
}

class DesenvolvimentoPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Upload Bloc
  // final uploadBloc = UploadBloc(Bootstrap.instance.firestore);

  //Eventos
  final BehaviorSubject<PageEvent> _eventController =
      BehaviorSubject<PageEvent>();

  Stream<PageEvent> get eventStream => _eventController.stream;

  Function get eventSink => _eventController.sink.add;

  //Estados
  final PageState _state = PageState();
  final _stateController = BehaviorSubject<PageState>();

  Stream<PageState> get stateStream => _stateController.stream;

  Function get stateSink => _stateController.sink.add;

  DesenvolvimentoPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
    // uploadBloc.uploadModelStream.listen((arq) => UpdateUploadModelEvent(arq));
  }

  _mapEventToState(PageEvent event) async {
    if (event is UpdateArquivoEvent) {
      // _state.arquivo = event.arquivo;
      // uploadBloc.fileSink(_state.arquivo);

      final ref = _firestore
          .collection(UploadModel.collection)
          .document(event.idUpload);
      _state.uploading[event.idUpload] =
          UploadBloc(Bootstrap.instance.firestore);

      final snap = await ref.get();
      if (snap.exists) {
        var uploadModel = UploadModel(id: snap.documentID).fromMap(snap.data);

        final blocAtual = _state.uploading[event.idUpload];

        blocAtual.uploadModelSink(uploadModel);

        blocAtual.stateStream.listen((estado) {
          if (estado.uploaded == true) {
            blocAtual.dispose();
            _state.uploading.remove(event.idUpload);
          }
        });
      }
      print('>>> uploading.toString() <<< ${_state.uploading.toString()}');
    }

    if (event is UpdateUploadModelEvent) {
      _state.uploadModel = event.uploadModel;
    }
    if (event is DeleteArquivoEvent) {
      _state.arquivo = null;
    }
    if (event is SaveEvent) {
      // print('>>> SaveEvent _state.toMap() <<< ${_state.toMap()}');
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print(
        'event.runtimeType em DesenvolvimentoPageBloc  = ${event.runtimeType}');
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }
}
