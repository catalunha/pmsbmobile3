import 'dart:io';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class BlocState {
  String userId;
  StorageUploadTask storageUploadTask;
  UploadModel uploadModel;
  bool uploaded;
}

class UploadBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Estados
  final _blocState = BlocState();

  //Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Estados
  final BlocState _state = BlocState();
  final _stateController = BehaviorSubject<BlocState>();
  Stream<BlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // //authBloc
  // final AuthBloc _authBloc =
  //     AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  // //Arquivo
  // final _fileController = BehaviorSubject<String>();
  // Stream<String> get fileStream => _fileController.stream;
  // Function get fileSink => _fileController.sink.add;

  //StorageTaskEvent
  final _storageTaskEventController = BehaviorSubject<StorageTaskEvent>();
  BehaviorSubject<StorageTaskEvent> get storageTaskEventStream =>
      _storageTaskEventController.stream;
  Function get storageTaskEventSink => _storageTaskEventController.sink.add;
  StreamSubscription<StorageTaskEvent> _eventsSubscription;

  // //Observable
  // Observable<bool> uploadTasks;

  //UploadModel
  final _uploadModelController = BehaviorSubject<UploadModel>();
  Stream<UploadModel> get uploadModelStream => _uploadModelController.stream;
  Function get uploadModelSink => _uploadModelController.sink.add;

  // StreamSubscription<UploadModel> _uploadModelSubscriptionController;

  UploadBloc(this._firestore) {
    // _authBloc.userId.listen((userId) => _blocState.userId = userId);

    // uploadTasks = Observable.combineLatest2(
    //   _authBloc.userId,
    //   fileStream.where((String filePath) => filePath != null),
    //   _uploadFromPathHandler,
    // );
    uploadModelStream.listen((uploadModel) {
      _blocState.uploadModel = uploadModel;
      _uploadFromPathHandler();
    });
    // uploadTasks.listen((_) => print("uploadTask iniciada"));
    storageTaskEventStream.listen(_handleStorageTaskEvent);
  }

  void dispose() async {
    await _storageTaskEventController.drain();
    _storageTaskEventController.close();
    await _uploadModelController.drain();
    _uploadModelController.close();
    await _stateController.drain();
    _stateController.close();
  }

  bool _uploadFromPathHandler() {
    if (_blocState.storageUploadTask != null) {
      _blocState.storageUploadTask.cancel();
      _eventsSubscription.cancel();
    }

    String filePath = _blocState.uploadModel.localPath;

    final uuid = new Uuid();
    File file = File(filePath);
    // String nameOriginal = file.path.split('/').last;
    // Map<String, String> customMetadata = Map<String, String>();
    // customMetadata['nameOriginal']=nameOriginal;
    final String filename = uuid.v4();
    final fileContentType =
        lookupMimeType(filePath, headerBytes: file.readAsBytesSync());

    final StorageReference fileStorage = _storage.ref().child(filename);
    final StorageUploadTask _uploadTask = fileStorage.putFile(
      file,
      StorageMetadata(
        contentType: fileContentType,
        // customMetadata:customMetadata,
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
    // var arquivo = UploadModel(
    //   usuario: _blocState.userId,
    //   // nome: storageTaskEvent.snapshot.storageMetadata.name,
    //   nome: await storageTaskEvent.snapshot.ref.getName(),
    //   contentType: storageTaskEvent.snapshot.storageMetadata.contentType,
    //   storagePath: storageTaskEvent.snapshot.storageMetadata.path,
    //   // storagePath: await storageTaskEvent.snapshot.ref.getBucket(),
    //   url: await storageTaskEvent.snapshot.ref.getDownloadURL(),
    //   upload: true,
    // );

// print('>>> storageTaskEvent.snapshot.storageMetadata.getBucket.toString <<< ${ storageTaskEvent.snapshot.ref.getBucket().toString()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.getBucket1 <<< ${await storageTaskEvent.snapshot.ref.getBucket()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.getName <<< ${await storageTaskEvent.snapshot.ref.getName()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.getPath <<< ${await storageTaskEvent.snapshot.ref.getPath()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.getDownloadURL <<< ${await storageTaskEvent.snapshot.ref.getDownloadURL()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.getParent <<< ${storageTaskEvent.snapshot.ref.path}');
// // print('>>> storageTaskEvent.snapshot.storageMetadata.getRoot <<< ${storageTaskEvent.snapshot.ref.getRoot().getStorage()}');
// // print('>>> storageTaskEvent.snapshot.storageMetadata.getRoot <<< ${storageTaskEvent.snapshot.ref.getRoot().getRoot()}');
// // print('>>> storageTaskEvent.snapshot.storageMetadata.getStorage <<< ${storageTaskEvent.snapshot.ref.getStorage()}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.name <<< ${storageTaskEvent.snapshot.storageMetadata.bucket}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.name <<< ${storageTaskEvent.snapshot.storageMetadata.name}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.path <<< ${storageTaskEvent.snapshot.storageMetadata.path}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.contentType <<< ${storageTaskEvent.snapshot.storageMetadata.contentType}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.md5Hash <<< ${storageTaskEvent.snapshot.storageMetadata.md5Hash}');
// print('>>> storageTaskEvent.snapshot.storageMetadata.md5Hash <<< ${storageTaskEvent.snapshot.}');


    _blocState.uploadModel.nome =
        storageTaskEvent.snapshot.storageMetadata.name;
    _blocState.uploadModel.storagePath =
        await storageTaskEvent.snapshot.ref.getBucket();
    _blocState.uploadModel.contentType =
        storageTaskEvent.snapshot.storageMetadata.contentType;
    _blocState.uploadModel.url =
        await storageTaskEvent.snapshot.ref.getDownloadURL();
    _blocState.uploadModel.hash =
        storageTaskEvent.snapshot.storageMetadata.md5Hash;
    _blocState.uploadModel.upload = true;

    var docRef = _firestore
        .collection(UploadModel.collection)
        .document(_blocState.uploadModel.id);
    await docRef.setData(_blocState.uploadModel.toMap(), merge: true);
    _state.uploaded = true;
    stateSink(_state);

    // docRef
    //     .snapshots()
    //     .map((snap) => UploadModel(id: docRef.documentID).fromMap(snap.data))
    //     .pipe(_uploadModelController);
  }
}
