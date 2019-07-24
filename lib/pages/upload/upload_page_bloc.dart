import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PageEvent {}

class UpdateUsuarioIDEvent extends PageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}
class StartUserEvent extends PageEvent {}

class StartUploadEvent extends PageEvent {}

class PageState {
  List<UploadModel> uploadList;
  bool uploading;
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
    _authBloc.userId
        .listen((userId) => eventSink(UpdateUsuarioIDEvent(userId)));
  }

  _mapEventToState(PageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      final streamDocs = _firestore
          .collection(UploadModel.collection)
          .where("usuarioID.id", isEqualTo: event.usuarioID)
          .where("upload", isEqualTo: false)
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) => UploadModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UploadModel> uploadModelList) {
        _state.uploadList = uploadModelList;
      });
    }
    if (event is StartUploadEvent) {
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
