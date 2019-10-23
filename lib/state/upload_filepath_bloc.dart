import 'package:universal_io/io.dart';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/firebase_storage.dart'
    if (dart.library.io) 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

//Tudo ok.
class BlocState {
  String userId;
  StorageUploadTask storageUploadTask;
}

class UploadFilePathBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Estados
  final _blocState = BlocState();

  //Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //authBloc
  final AuthBloc _authBloc = Bootstrap.instance.authBloc;

  //Arquivo
  final _fileController = BehaviorSubject<String>();

  Stream<String> get fileStream => _fileController.stream;

  Function get fileSink => _fileController.sink.add;

  //StorageTaskEvent
  final _storageTaskEventController = BehaviorSubject<StorageTaskEvent>();

  BehaviorSubject<StorageTaskEvent> get storageTaskEventStream =>
      _storageTaskEventController.stream;

  Function get storageTaskEventSink => _storageTaskEventController.sink.add;
  StreamSubscription<StorageTaskEvent> _eventsSubscription;

  //Observable
  Observable<bool> uploadTasks;

  //UploadModel
  final _uploadModelController = BehaviorSubject<UploadModel>();

  Stream<UploadModel> get uploadModelStream => _uploadModelController.stream;
  StreamSubscription<UploadModel> _uploadModelSubscriptionController;

  UploadFilePathBloc(this._firestore) {
    _authBloc.userId.listen((userId) => _blocState.userId = userId);

    uploadTasks = Observable.combineLatest2(
      _authBloc.userId,
      fileStream.where((String filePath) => filePath != null),
      _uploadFromPathHandler,
    );
    storageTaskEventStream.listen(_handleStorageTaskEvent);
  }

  void dispose() async {
    await _fileController.drain();
    _fileController.close();
    await _storageTaskEventController.drain();
    _storageTaskEventController.close();
    _uploadModelSubscriptionController.cancel();
    await _uploadModelController.drain();
    _uploadModelController.close();
  }

  bool _uploadFromPathHandler(String userId, String filePath) {
    if (_blocState.storageUploadTask != null) {
      _blocState.storageUploadTask.cancel();
      _eventsSubscription.cancel();
    }

    final uuid = new Uuid();
    File file = File(filePath);
    final String filename = uuid.v4();
    final fileContentType =
        lookupMimeType(filePath, headerBytes: file.readAsBytesSync());

    final StorageReference fileStorage = _storage.ref().child(filename);
    final StorageUploadTask _uploadTask = fileStorage.putFile(
      file,
      StorageMetadata(
        contentType: fileContentType,
      ),
    );
    _eventsSubscription = _uploadTask.events.listen((event) {
      storageTaskEventSink(event);
    });
    return true;
  }

  void _handleStorageTaskEvent(StorageTaskEvent storageTaskEvent) {
    if (storageTaskEvent.type == StorageTaskEventType.resume) {}
    if (storageTaskEvent.type == StorageTaskEventType.progress) {}
    if (storageTaskEvent.type == StorageTaskEventType.pause) {}
    if (storageTaskEvent.type == StorageTaskEventType.success) {
      _uploadSucess(storageTaskEvent);
    }
    if (storageTaskEvent.type == StorageTaskEventType.failure) {}


  }

  _uploadSucess(StorageTaskEvent storageTaskEvent) async {
    var arquivo = UploadModel(
      usuario: _blocState.userId,
      nome: await storageTaskEvent.snapshot.ref.getName(),
      contentType: storageTaskEvent.snapshot.storageMetadata.contentType,
      storagePath: storageTaskEvent.snapshot.storageMetadata.path,
      url: await storageTaskEvent.snapshot.ref.getDownloadURL(),
      upload: true,
    );

    var docRef = _firestore.collection(UploadModel.collection).document();
    await docRef.setData(arquivo.toMap(), merge: true);
    docRef
        .snapshots()
        .map((snap) => UploadModel(id: docRef.documentID).fromMap(snap.data))
        .pipe(_uploadModelController);
  }
}
