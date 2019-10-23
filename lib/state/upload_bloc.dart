import 'package:universal_io/io.dart';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/naosuportato/firebase_storage.dart'
    if (dart.library.io) 'package:firebase_storage/firebase_storage.dart';
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

  //StorageTaskEvent
  final _storageTaskEventController = BehaviorSubject<StorageTaskEvent>();

  BehaviorSubject<StorageTaskEvent> get storageTaskEventStream =>
      _storageTaskEventController.stream;

  Function get storageTaskEventSink => _storageTaskEventController.sink.add;
  StreamSubscription<StorageTaskEvent> _eventsSubscription;

  
  final _uploadModelController = BehaviorSubject<UploadModel>();

  Stream<UploadModel> get uploadModelStream => _uploadModelController.stream;

  Function get uploadModelSink => _uploadModelController.sink.add;


  UploadBloc(this._firestore) {

    uploadModelStream.listen((uploadModel) {
      _blocState.uploadModel = uploadModel;
      _uploadFromPathHandler();
    });
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

  }
}
