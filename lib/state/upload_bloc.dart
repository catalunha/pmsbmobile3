import 'dart:io';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class BlocState {
  String userId;
  StorageUploadTask storageUploadTask;
}

class UploadBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Estados
  final _blocState = BlocState();

  //Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //authBloc
  final AuthBloc _authBloc =
      AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

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

  UploadBloc(this._firestore) {
    _authBloc.userId.listen((userId) => _blocState.userId = userId);

    uploadTasks = Observable.combineLatest2(
      _authBloc.userId,
      fileStream.where((String filePath) => filePath != null),
      _uploadFromPathHandler,
    );
    uploadTasks.listen((_) => print("uploadTask iniciada"));
    storageTaskEventStream.listen(_handleStorageTaskEvent);
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

  void dispose() {
    _fileController.close();
    _storageTaskEventController.close();
    _uploadModelController.close();
    _uploadModelSubscriptionController.cancel();
  }

  void _handleStorageTaskEvent(StorageTaskEvent storageTaskEvent) {
    if (storageTaskEvent.type == StorageTaskEventType.resume) {}
    if (storageTaskEvent.type == StorageTaskEventType.progress) {}
    if (storageTaskEvent.type == StorageTaskEventType.pause) {}
    if (storageTaskEvent.type == StorageTaskEventType.success) {
      _uploadSucess(storageTaskEvent);
    }
    if (storageTaskEvent.type == StorageTaskEventType.failure) {}

    // switch (storageTaskEvent.type) {
    //   case StorageTaskEventType.resume:
    //     // TODO: Handle this case.
    //     break;
    //   case StorageTaskEventType.progress:
    //     // TODO: Handle this case.
    //     break;
    //   case StorageTaskEventType.pause:
    //     // TODO: Handle this case.
    //     break;
    //   case StorageTaskEventType.success:
    //     _uploadSucess();
    //     break;
    //   case StorageTaskEventType.failure:
    //     // TODO: Handle this case.
    //     break;
    // }
  }

  _uploadSucess(StorageTaskEvent storageTaskEvent) async {
    var arquivo = UploadModel(
      usuario: _blocState.userId,
      nome: storageTaskEvent.snapshot.storageMetadata.name,
      contentType: storageTaskEvent.snapshot.storageMetadata.contentType,
      storagePath: storageTaskEvent.snapshot.storageMetadata.path,
      url: await storageTaskEvent.snapshot.ref.getDownloadURL(),
      upload: true,
    );

    var docRef = _firestore.collection(UploadModel.collection).document();
    await docRef.setData(arquivo.toMap());
    docRef
        .snapshots()
        .map((snap) => UploadModel(id: docRef.documentID).fromMap(snap.data))
        .pipe(_uploadModelController);
  }
}
