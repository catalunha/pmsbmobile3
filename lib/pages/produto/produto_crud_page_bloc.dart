import 'package:pmsbmibile3/models/google_drive_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ProdutoCRUDPageEvent {}

class UpdateUsuarioIDEvent extends ProdutoCRUDPageEvent {}

class UpdateProdutoIDEvent extends ProdutoCRUDPageEvent {
  final String produtoID;

  UpdateProdutoIDEvent(this.produtoID);
}

class UpdateProdutoIDNomeEvent extends ProdutoCRUDPageEvent {
  final String produtoIDNome;

  UpdateProdutoIDNomeEvent(this.produtoIDNome);
}

class UpdatePDFEvent extends ProdutoCRUDPageEvent {
  final String pdfLocalPath;

  UpdatePDFEvent(this.pdfLocalPath);
}

class SaveProdutoIDEvent extends ProdutoCRUDPageEvent {}

class DeleteProdutoIDEvent extends ProdutoCRUDPageEvent {}

class UpdateDeletePDFEvent extends ProdutoCRUDPageEvent {}

class ProdutoCRUDPageState {
  UsuarioModel usuarioModel;
  ProdutoModel produtoModel;

  String produtoModelID;
  String produtoModelIDTitulo;

  String pdfLocalPath;
  String pdfUrl;
  String pdfUploadID;

  void updateStateFromProdutoModel() {
    produtoModelIDTitulo = produtoModel.titulo;
    pdfLocalPath = produtoModel?.pdf?.localPath;
    pdfUrl = produtoModel?.pdf?.url;
    pdfUploadID = produtoModel?.pdf?.uploadID;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produtoModelID'] = this.produtoModelID;
    data['produtoModelIDTitulo'] = this.produtoModelIDTitulo;
    return data;
  }
}

class ProdutoCRUDPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Authenticacação
  AuthBloc _authBloc;

  //Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoCRUDPageEvent>();
  Stream<ProdutoCRUDPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoCRUDPageState _state = ProdutoCRUDPageState();
  final _stateController = BehaviorSubject<ProdutoCRUDPageState>();
  Stream<ProdutoCRUDPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //ProdutoModel
  final _produtoModelController = BehaviorSubject<ProdutoModel>();
  Stream<ProdutoModel> get produtoModelStream => _produtoModelController.stream;
  Function get produtoModelSink => _produtoModelController.sink.add;

  //Bloc
  ProdutoCRUDPageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
    await _produtoModelController.drain();
    _produtoModelController.close();
  }

  _mapEventToState(ProdutoCRUDPageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _authBloc.perfil.listen((usuario) {
        _state.usuarioModel = usuario;
      });
    }

    if (event is UpdateProdutoIDEvent) {
      if (event.produtoID != null) {
        _state.produtoModelID = event.produtoID;
        //Atualiza estado com produto
        final docRef = _firestore
            .collection(ProdutoModel.collection)
            .document(event.produtoID);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.produtoModel =
              ProdutoModel(id: snap.documentID).fromMap(snap.data);
          _state.updateStateFromProdutoModel();
        }
      }
    }

    if (event is UpdateProdutoIDNomeEvent) {
      _state.produtoModelIDTitulo = event.produtoIDNome;
    }

    if (event is SaveProdutoIDEvent) {
      if (_state.pdfUploadID != null && _state.pdfUrl == null) {
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.pdfUploadID);
        await docRef.delete();
        _state.pdfUploadID = null;

        if (_state.produtoModel.pdf?.url != null) {
          Future<StorageReference> storageRefFut =
              _storage.getReferenceFromUrl(_state.produtoModel.pdf.url);
          storageRefFut.then((storageRef) {
            storageRef.delete();
          });
        }
      }

      final produtoDocRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoModelID);

      //+++ Cria doc em UpLoadCollection
      if (_state.pdfLocalPath != null) {
        final upLoadModel = UploadModel(
          usuario: _state.usuarioModel.id,
          localPath: _state.pdfLocalPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: ProdutoModel.collection,
              document: produtoDocRef.documentID,
              field: "pdf"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.pdfUploadID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.pdfUploadID = docRef.documentID;
      }
      // Se for produto novo cria o gdocs dele
      print('>>> produtoModelID <<< ${_state.produtoModelID}');
      print(
          '>>> _state.produtoModel?.googleDriveID <<< ${_state.produtoModel?.googleDrive}');
      GoogleDriveID googleDriveID;
      if (_state.produtoModelID == null &&
          _state.produtoModel?.googleDrive == null) {
        // Listando usuarios do eixo do criador do produto
        final query = _firestore
            .collection(UsuarioModel.collection)
            .where("eixoID.id", isEqualTo: _state.usuarioModel.eixoID.id);
        final snap = await query.getDocuments();

        var usuariosEixoLista = snap.documents
            .map((doc) => UsuarioModel(id: doc.documentID).fromMap(doc.data))
            .toList();
        // Todos os usuarios do eixo do criador terao acesso a este gdoc
        Map<String, UsuarioGoogleDrive> usuarioGoogleDrive =
            Map<String, UsuarioGoogleDrive>();
        for (var item in usuariosEixoLista) {
          usuarioGoogleDrive[item.email] = UsuarioGoogleDrive(
            atualizar: false,
            permissao: 'escrever',
            usuarioID: item.id,
          );
        }
        // Criando googledriveCollection
        var googleDriveModel = GoogleDriveModel(
          tipo: 'documento',
          usuario: usuarioGoogleDrive,
          updateCollection: UpdateCollection(
              collection: ProdutoModel.collection,
              document: produtoDocRef.documentID,
              field: "googleDrive.arquivoID"),
        );
        final docRefGoogleDrive =
            _firestore.collection(GoogleDriveModel.collection).document();
        await docRefGoogleDrive.setData(googleDriveModel.toMap(), merge: true);
        googleDriveID =
            GoogleDriveID(id: docRefGoogleDrive.documentID, tipo: 'document');
      }

      final produtoModelSave = ProdutoModel(
        titulo: _state.produtoModelIDTitulo,
        eixoID: _state.usuarioModel.eixoIDAtual,
        setorCensitarioID: _state.usuarioModel.setorCensitarioID,
        googleDrive: googleDriveID,
        usuarioID: UsuarioID(
            id: _state.usuarioModel.id, nome: _state.usuarioModel.nome),
        modificado: DateTime.now().toUtc(),
        pdf: UploadID(
            uploadID: _state.pdfUploadID,
            url: _state.pdfUrl,
            localPath: _state.pdfLocalPath),
      );

      //--- Cria doc em UpLoadCollection
      await produtoDocRef.setData(produtoModelSave.toMap(), merge: true);
    }
    if (event is UpdatePDFEvent) {
      _state.pdfLocalPath = event.pdfLocalPath;
      _state.pdfUrl = null;
    }

    if (event is UpdateDeletePDFEvent) {
      _state.pdfLocalPath = null;
      _state.pdfUrl = null;
    }

    if (event is DeleteProdutoIDEvent) {
      if (_state.produtoModel?.pdf?.uploadID != null) {
        _firestore
            .collection(UploadModel.collection)
            .document(_state.produtoModel?.pdf?.uploadID)
            .delete();
        if (_state.produtoModel?.pdf?.url != null) {
          Future<StorageReference> storageRefFut =
              _storage.getReferenceFromUrl(_state.produtoModel?.pdf?.url);
          storageRefFut.then((storageRef) {
            storageRef.delete();
          });
        }
      }
      if (_state.produtoModel?.googleDrive?.id != null) {
        _firestore
            .collection(GoogleDriveModel.collection)
            .document(_state.produtoModel?.googleDrive?.id)
            .delete();
      }
      _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoModel.id)
          .delete();
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print('event.runtimeType em ProdutoCRUDPageBloc  = ${event.runtimeType}');
  }
}
