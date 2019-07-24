import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PageEvent {}

class UpdateUsuarioIDEvent extends PageEvent {}

class StartUserEvent extends PageEvent {}

class StartUploadEvent extends PageEvent {
  final String id;

  StartUploadEvent(this.id);
}

class Uploading {
  final String id;
  final UploadModel upload;
  bool uploading = false;

  Uploading(this.upload, this.id);
}

class PageState {
  List<Uploading> uploadingList;
}

class UploadPageBloc {
  //Firestore
  final fw.Firestore _firestore;
  // Authenticacação
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  //Eventos
  final _eventController = BehaviorSubject<PageEvent>();

  Stream<PageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PageState _state = PageState();
  final _stateController = BehaviorSubject<PageState>();
  Stream<PageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // //ProdutoModel List
  // final _uploadModelListController = BehaviorSubject<List<UploadModel>>();
  // Stream<List<UploadModel>> get uploadModelListStream =>
  //     _uploadModelListController.stream;
  // Function get uploadModelListSink => _uploadModelListController.sink.add;

  UploadPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
    // _authBloc.userId
    //     .listen((userId) => eventSink(UpdateUsuarioIDEvent(userId)));
  }

  _mapEventToState(PageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _authBloc.userId.listen((userId) {
        final streamDocs = _firestore
            .collection(UploadModel.collection)
            .where("usuarioID.id", isEqualTo: userId)
            .where("upload", isEqualTo: false)
            .snapshots()
            .map((snapDocs) => snapDocs.documents
                .map((doc) => Uploading(
                    UploadModel(id: doc.documentID).fromMap(doc.data),
                    doc.documentID))
                .toList())
            .listen((List<Uploading> uploadingList) {
          _state.uploadingList = uploadingList;
        });
      });
    }
    if (event is StartUploadEvent) {

      _state.uploadingList?.forEach((up) {
        if (up.id == event.id) {
          up.uploading = true;
        }
      });
      var delayedResult = Future.delayed(
          Duration(seconds: 5), () => 'Mostrar depois de 5 segundos');
      delayedResult.then((str) => print(str));
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print(event.runtimeType);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    _authBloc.dispose();
  }
}
