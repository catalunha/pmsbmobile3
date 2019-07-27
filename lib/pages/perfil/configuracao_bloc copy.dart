// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pmsbmibile3/bootstrap.dart';
// import 'package:pmsbmibile3/models/propriedade_for_model.dart';
// import 'package:pmsbmibile3/models/setor_censitario_model.dart';
// import 'package:pmsbmibile3/models/upload_model.dart';
// import 'package:pmsbmibile3/state/upload_filepath_bloc.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:pmsbmibile3/models/usuario_model.dart';
// import 'package:pmsbmibile3/models/eixo_model.dart';
// import 'package:pmsbmibile3/models/arquivo_model.dart';
// import 'package:pmsbmibile3/state/upload_bloc.dart';
// import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

// /// Class base Eventos da Pagina ConfiguracaoPage
// class ConfiguracaoPageEvent {}

// class UpdateNomeEvent extends ConfiguracaoPageEvent {
//   final String nomeProjeto;

//   UpdateNomeEvent(this.nomeProjeto);
// }

// class UpdateSetorCensitarioEvent extends ConfiguracaoPageEvent {
//   final String setorId;
//   final String setorNome;

//   UpdateSetorCensitarioEvent(this.setorId, this.setorNome);
// }

// class UpdateEixoIDAtualEvent extends ConfiguracaoPageEvent {
//   final String eixoId;
//   final String eixoNome;

//   UpdateEixoIDAtualEvent(this.eixoId, this.eixoNome);
// }

// class UpdateEmailEvent extends ConfiguracaoPageEvent {
//   final String email;

//   UpdateEmailEvent(this.email);
// }

// class UpdateUsuarioIDEvent extends ConfiguracaoPageEvent {
//   final String usuarioID;

//   UpdateUsuarioIDEvent(this.usuarioID);
// }

// class UpdateCelularEvent extends ConfiguracaoPageEvent {
//   final String celular;

//   UpdateCelularEvent(this.celular);
// }

// class SaveStateToFirebaseEvent extends ConfiguracaoPageEvent {}

// /// Class base Estado da Pagina ConfiguracaoPage
// class ConfiguracaoPageState {
//   String usuarioID;
//   String nome;
//   String celular;
//   String email;
//   String setorCensitarioIDId;
//   String setorCensitarioIDnome;
//   String eixoIDAtualId;
//   String eixoIDAtualNome;

//   String filePath;
//   dynamic imagemPerfil;
//   String imagemPerfilUrl;

//   @override
//   String toString() => "$email $nome, $celular, $filePath";
// }

// /// class Bloc para ConfiguracaoPage
// class ConfiguracaoPageBloc {
//   final fsw.Firestore _firestore;

//   // Estados da Página
//   final ConfiguracaoPageState configuracaoPageState = ConfiguracaoPageState();
//   final _configuracaoPageStateController =
//       BehaviorSubject<ConfiguracaoPageState>();

//   Stream<ConfiguracaoPageState> get configuracaoPageStateStream =>
//       _configuracaoPageStateController.stream;

//   // Eventos da Página
//   final _configuracaoPageEventController =
//       BehaviorSubject<ConfiguracaoPageEvent>();

//   Stream<ConfiguracaoPageEvent> get configuracaoPageEventStream =>
//       _configuracaoPageEventController.stream;

//   Function get configuracaoPageEventSink =>
//       _configuracaoPageEventController.sink.add;

//   // UsuarioModel
//   BehaviorSubject<UsuarioModel> _usuarioModelController =
//       BehaviorSubject<UsuarioModel>();

//   Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

//   Function get usuarioModelSink => _usuarioModelController.sink.add;

//   // EixoModel
//   BehaviorSubject<List<EixoModel>> _eixoModelListController =
//       BehaviorSubject<List<EixoModel>>();

// // SetorCensitarioModel
//   BehaviorSubject<List<SetorCensitarioModel>>
//       _setorCensitarioModelListController =
//       BehaviorSubject<List<SetorCensitarioModel>>();

//   Stream<List<SetorCensitarioModel>> get setorCensitarioModelListStream =>
//       _setorCensitarioModelListController.stream;

//   //UploadBloc
//   final uploadFilePathBloc = UploadFilePathBloc(Bootstrap.instance.firestore);

//   //Imagem usuario.
//   BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

//   Function get updateImagemPerfil => _imagemPerfil.sink.add;

//   ConfiguracaoPageBloc(this._firestore) {
//     configuracaoPageEventStream.listen(_mapEventToState);

//     //retorna somente id do usuario caso esteja logado
//     FirebaseAuth.instance.onAuthStateChanged
//         .where((user) => user != null)
//         .map((user) => user.uid)
//         .listen((usuarioID) {
//       configuracaoPageEventSink(UpdateUsuarioIDEvent(usuarioID));
//     });

//     //pega lista de SetorCensitarioModel
//     pullSetorCensitario();

//     _imagemPerfil.listen(_imagemPerfilUpload);
//     uploadFilePathBloc.uploadModelStream
//         .listen(_imagemPerfilUpdateState); //update informação do perfil
//   }

//   void pullSetorCensitario() {
//     //pega lista de SetorCensitarioModel
//     _firestore
//         .collection(SetorCensitarioModel.collection)
//         .snapshots()
//         .map((snap) => snap.documents
//             .map((doc) =>
//                 SetorCensitarioModel(id: doc.documentID).fromMap(doc.data))
//             .toList())
//         .pipe(_setorCensitarioModelListController);
//   }

//   void dispose() {
//     _usuarioModelController.close();
// //    _processForm.close();
//     _setorCensitarioModelListController.close();
//     _eixoModelListController.close();
//     _configuracaoPageEventController.close();
//     _configuracaoPageStateController.close();
//   }

//   void pullUsuarioModel(String usuarioID) {
//     print('2');
//     _firestore
//         .collection(UsuarioModel.collection)
//         .document(usuarioID)
//         .snapshots()
//         .where((snap) => snap.exists)
//         .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
//         .pipe(_usuarioModelController);
//     print('3');
//     usuarioModelStream.listen(upDateConfiguracaoPageStateUsuarioModel);
//     print('4');
//   }

//   void upDateConfiguracaoPageStateUsuarioModel(UsuarioModel perfil) {
//     print('5');
//     configuracaoPageState.celular = perfil.celular;
//     configuracaoPageState.nome = perfil.nome;
//     configuracaoPageState.setorCensitarioIDId = perfil.setorCensitarioID.id;
//     configuracaoPageState.setorCensitarioIDnome = perfil.setorCensitarioID.nome;
//     configuracaoPageState.eixoIDAtualId = perfil.eixoIDAtual.id;
//     configuracaoPageState.eixoIDAtualNome = perfil.eixoIDAtual.nome;
//     configuracaoPageState.imagemPerfilUrl = perfil.usuarioArquivoID.url;
//     configuracaoPageState.imagemPerfil = perfil.usuarioArquivoID.id;
//     print('6');
//     _configuracaoPageStateController.sink.add(configuracaoPageState);
//     print('6a');
//   }

//   bool SaveStateToFirebase(String usuarioID) {
//     UsuarioArquivoID usuarioArquivoID = UsuarioArquivoID(
//         id: configuracaoPageState.imagemPerfil,
//         url: configuracaoPageState.imagemPerfilUrl);
//     SetorCensitarioID setorCensitarioID = SetorCensitarioID(
//         id: configuracaoPageState.setorCensitarioIDId,
//         nome: configuracaoPageState.setorCensitarioIDnome);
//     EixoID eixoIDAtual = EixoID(
//         id: configuracaoPageState.eixoIDAtualId,
//         nome: configuracaoPageState.eixoIDAtualNome);
//     _firestore.collection(UsuarioModel.collection).document(usuarioID).setData({
//       ...UsuarioModel(
//         id: usuarioID,
//         nome: configuracaoPageState.nome,
//         celular: configuracaoPageState.celular,
//         usuarioArquivoID: usuarioArquivoID,
//         email: configuracaoPageState.email,
//         setorCensitarioID: setorCensitarioID,
//         eixoIDAtual: eixoIDAtual,
//       ).toMap(),
//     }, merge: true);
//     return true;
//   }

//   //upload file
//   void _imagemPerfilUpload(String filepath) {
//     print('>>>>> filepath: $filepath');
//     configuracaoPageState.filePath = filepath;
//     uploadFilePathBloc.fileSink(configuracaoPageState.filePath);
//   }

//   void _imagemPerfilUpdateState(UploadModel arquivo) {
//     configuracaoPageState.imagemPerfilUrl = arquivo.url;
//     // configuracaoPageState.imagemPerfil =
//         // _firestore.collection(ArquivoModel.collection).document(arquivo.id);
//   }

//   void _mapEventToState(ConfiguracaoPageEvent event) {
//     // if (event is UpdateEmailEvent) {
//     //   pageState.email = event.email;
//     // }
//     if (event is UpdateUsuarioIDEvent) {
//       print('1');
//       configuracaoPageState.usuarioID = event.usuarioID;
//       pullUsuarioModel(event.usuarioID);
//       print('7');
//     }
//     if (event is SaveStateToFirebaseEvent) {
//       SaveStateToFirebase(configuracaoPageState.usuarioID);
//     }
//     if (event is UpdateNomeEvent) {
//       configuracaoPageState.nome = event.nomeProjeto;
//     }
//     if (event is UpdateCelularEvent) {
//       configuracaoPageState.celular = event.celular;
//     }
//     if (event is UpdateSetorCensitarioEvent) {
//       configuracaoPageState.setorCensitarioIDId = event.setorId;
//       configuracaoPageState.setorCensitarioIDnome = event.setorNome;
//     }
//     if (event is UpdateEixoIDAtualEvent) {
//       configuracaoPageState.eixoIDAtualId = event.eixoId;
//       configuracaoPageState.eixoIDAtualNome = event.eixoNome;
//     }
//     print('8');
//     _configuracaoPageStateController.sink.add(configuracaoPageState);
//     print('9');
//   }
// }
