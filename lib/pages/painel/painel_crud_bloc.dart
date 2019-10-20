import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
// import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class PainelCrudBlocEvent {}

class GetUsuarioIDEvent extends PainelCrudBlocEvent {
  final UsuarioModel usuarioID;

  GetUsuarioIDEvent(this.usuarioID);
}

class GetPainelEvent extends PainelCrudBlocEvent {
  final String painelId;
  GetPainelEvent({this.painelId});
}

class UpdateNomeEvent extends PainelCrudBlocEvent {
  final String nome;
  UpdateNomeEvent(this.nome);
}

class UpdateTipoEvent extends PainelCrudBlocEvent {
  final String tipo;
  UpdateTipoEvent(this.tipo);
}

class UpdateUsuarioListEvent extends PainelCrudBlocEvent {}

class SelectDestinatarioIDEvent extends PainelCrudBlocEvent {
  final UsuarioModel destinatario;

  SelectDestinatarioIDEvent(this.destinatario);
}

class UpdateEixoListEvent extends PainelCrudBlocEvent {}

class SelectEixoIDEvent extends PainelCrudBlocEvent {
  final EixoID eixo;

  SelectEixoIDEvent(this.eixo);
}

class UpdateProdutoFunasaListEvent extends PainelCrudBlocEvent {}

class SelectProdutoFunasaIDEvent extends PainelCrudBlocEvent {
  final ProdutoFunasaModel produtoFunasa;

  SelectProdutoFunasaIDEvent(this.produtoFunasa);
}

class SaveEvent extends PainelCrudBlocEvent {}

class DeleteDocumentEvent extends PainelCrudBlocEvent {}

class PainelCrudBlocState {
  String painelId;
  PainelModel painel;
  bool isDataValid = false;
  String nome;
  String tipo;
  UsuarioModel usuarioID;
  UsuarioID usuarioQVaiResponder;
  EixoID eixo;
  ProdutoFunasaID produtoFunasa;
  List<UsuarioModel> usuarioList = List<UsuarioModel>();
  List<EixoID> eixoList = List<EixoID>();
  List<ProdutoFunasaModel> produtoFunasaList = List<ProdutoFunasaModel>();

  void updateState() {
    nome = painel.nome;
    tipo = painel.tipo;
    usuarioQVaiResponder = painel?.usuarioQVaiResponder;
    eixo = painel?.eixo;
    produtoFunasa = painel?.produto;
  }
}

class PainelCrudBloc {
  //Firestore
  //Firestore
  // final fsw.Firestore _firestore;
  final fw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<PainelCrudBlocEvent>();
  Stream<PainelCrudBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PainelCrudBlocState _state = PainelCrudBlocState();
  final _stateController = BehaviorSubject<PainelCrudBlocState>();
  Stream<PainelCrudBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PainelCrudBloc(
    this._firestore,
    this._authBloc,
  ) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(GetUsuarioIDEvent(usuarioID));
    });
    eventSink(UpdateUsuarioListEvent());
    eventSink(UpdateEixoListEvent());
    eventSink(UpdateProdutoFunasaListEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    if (_state.nome == null || _state.nome.isEmpty) {
      _state.isDataValid = false;
    }
    if (_state.tipo == null) {
      _state.isDataValid = false;
    }
    if (_state.usuarioQVaiResponder == null) {
      _state.isDataValid = false;
    }
    if (_state.eixo == null) {
      _state.isDataValid = false;
    }
    if (_state.produtoFunasa == null) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(PainelCrudBlocEvent event) async {
    if (event is GetPainelEvent) {
      final docRef = _firestore
          .collection(PainelModel.collection)
          .document(event.painelId);
      _state.painelId = event.painelId;
      final snap = await docRef.get();
      if (snap.exists) {
        _state.painel = PainelModel(id: snap.documentID).fromMap(snap.data);
        _state.updateState();
      }
    }
    if (event is GetUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateUsuarioListEvent) {
      var collRef = await _firestore
          .collection(UsuarioModel.collection)
          .where("cargoID.id", isEqualTo: 'coordenador')
          // .orderBy('nome')
          .getDocuments();

      for (var documentSnapshot in collRef.documents) {
        _state.usuarioList.add(UsuarioModel(id: documentSnapshot.documentID)
            .fromMap(documentSnapshot.data));
      }
      _state.usuarioList.sort((a, b) => a.nome.compareTo(b.nome));
    }
    if (event is SelectDestinatarioIDEvent) {
      _state.usuarioQVaiResponder =
          UsuarioID(id: event.destinatario.id, nome: event.destinatario.nome);
    }

    if (event is UpdateEixoListEvent) {
      var collRef = await _firestore
          .collection(EixoModel.collection)
          // .orderBy('nome')
          .getDocuments();

      for (var documentSnapshot in collRef.documents) {
        _state.eixoList.add(EixoID(
            id: documentSnapshot.documentID,
            nome: documentSnapshot.data['nome']));
      }
      _state.eixoList.sort((a, b) => a.nome.compareTo(b.nome));
    }
    if (event is SelectEixoIDEvent) {
      _state.eixo = event.eixo;
    }

    if (event is UpdateProdutoFunasaListEvent) {
      var collRef = await _firestore
          .collection(ProdutoFunasaModel.collection)
          // .orderBy('nome')
          .getDocuments();

      for (var documentSnapshot in collRef.documents) {
        _state.produtoFunasaList.add(ProdutoFunasaModel(
            id: documentSnapshot.documentID).fromMap(documentSnapshot.data));
      }
      _state.produtoFunasaList.sort((a, b) => a.id.compareTo(b.id));
    }
    if (event is SelectProdutoFunasaIDEvent) {
      _state.produtoFunasa =ProdutoFunasaID(id:event.produtoFunasa.id,nome:event.produtoFunasa.nome);
            print(_state.produtoFunasa.toMap());

    }

    if (event is UpdateNomeEvent) {
      _state.nome = event.nome;
    }
    if (event is UpdateTipoEvent) {
      _state.tipo = event.tipo;
      print('radiovalue=${_state.tipo}');
    }
    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(PainelModel.collection)
          .document(_state.painelId);

      PainelModel painelModel = PainelModel(
        nome: _state.nome,
        tipo: _state.tipo,
        usuarioQEditou:
            UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome),
        usuarioQVaiResponder: _state.usuarioQVaiResponder,
        eixo: _state.eixo,
        produto: _state.produtoFunasa,
        modificado: Bootstrap.instance.fieldValue.serverTimestamp(),
      );

      await docRef.setData(painelModel.toMap(), merge: true);

      // await docRef.setData({
      //   'nome': _state.nome,
      //   'tipo': _state.tipo,
      //   'modificado': Bootstrap.instance.fieldValue.serverTimestamp(),
      //   'usuarioID':
      //       UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome)
      //           .toMap(),
      //                   'usuarioQVaiResponder':
      //       UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome)
      //           .toMap()
      // }, merge: true);

    }

    if (event is DeleteDocumentEvent) {
      _firestore
          .collection(PainelModel.collection)
          .document(_state.painel.id)
          .delete();
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelCrudBloc  = ${event.runtimeType}');
  }
}
