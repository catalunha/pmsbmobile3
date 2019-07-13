import 'dart:io';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class BlocState {
  String userId;
  StorageUploadTask currentUploadTask;
}

class UploadBloc {
  final fsw.Firestore _firestore;
  final blocState = BlocState();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthBloc _authBloc =
      AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  final _filePath = BehaviorSubject<String>();

  Function get uploadFromPath => _filePath.sink.add;

  final _events = BehaviorSubject<StorageTaskEvent>();
  StreamSubscription<StorageTaskEvent> _eventsSubscription;

  BehaviorSubject<StorageTaskEvent> get events => _events.stream;

  Observable<bool> uploadTasks;

  final _arquivo = BehaviorSubject<ArquivoModel>();

  Stream<ArquivoModel> get arquivo => _arquivo.stream;
  StreamSubscription<ArquivoModel> _arquivoSubscriptio;

  UploadBloc(this._firestore) {
    _authBloc.userId.listen((userId) => blocState.userId = userId);

    uploadTasks = Observable.combineLatest2(
      _authBloc.userId,
      _filePath.stream.where((String filePath) => filePath != null),
      _uploadFromPathHandler,
    );
    //uploadTasks.listen((_) => print("uploadTask iniciada"));
    _events.stream.listen(_handleStorageTaskEvent);
  }

  bool _uploadFromPathHandler(String userId, String filePath) {
    if (blocState.currentUploadTask != null) {
      blocState.currentUploadTask.cancel();
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
      _events.sink.add(event);
    });
    return true;
  }

  void dispose() {
    _filePath.close();
    _events.close();
    _arquivo.close();
    _arquivoSubscriptio.cancel();
  }

  void _handleStorageTaskEvent(StorageTaskEvent storageTaskEvent) {
    _uploadSucess() async {
      var ref = _firestore.collection(ArquivoModel.collection);
      var arquivo = ArquivoModel(
        userId: blocState.userId,
        contentType: storageTaskEvent.snapshot.storageMetadata.contentType,
        storagePath: storageTaskEvent.snapshot.storageMetadata.path,
        titulo: storageTaskEvent.snapshot.storageMetadata.name,
        url: await storageTaskEvent.snapshot.ref.getDownloadURL(),
      );

      var doc = ref.document();
      doc.setData(arquivo.toMap());
      doc
          .snapshots()
          .map((snap) => ArquivoModel(id: doc.documentID).fromMap(snap.data))
          .pipe(_arquivo);
    }

    switch (storageTaskEvent.type) {
      case StorageTaskEventType.resume:
        // TODO: Handle this case.
        break;
      case StorageTaskEventType.progress:
        // TODO: Handle this case.
        break;
      case StorageTaskEventType.pause:
        // TODO: Handle this case.
        break;
      case StorageTaskEventType.success:
        _uploadSucess();
        break;
      case StorageTaskEventType.failure:
        // TODO: Handle this case.
        break;
    }
  }
}
