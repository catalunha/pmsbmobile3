import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';

class ControleTarefaListBlocEvent {}

class UpdateTarefaUsuarioIDEvent extends ControleTarefaListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaUsuarioIDEvent(this.usuarioID);
}

class SelectSetorIDEvent extends ControleTarefaListBlocEvent {
  final SetorCensitarioModel setorID;
  final ControleTarefaModel tarefaID;

  SelectSetorIDEvent({this.tarefaID, this.setorID});
}

class ControleTarefaListBlocState {
  UsuarioModel usuarioID;
  List<ControleTarefaModel> controleTarefaListDestinatario =
      List<ControleTarefaModel>();
  List<ControleTarefaModel> controleTarefaListRemetente =
      List<ControleTarefaModel>();
  bool isDataValidDestinatario = false;
  bool isDataValidRemetente = false;

  //Necessarios para duplicar tarefa
  List<SetorCensitarioModel> setorList = List<SetorCensitarioModel>();
  // List<ControleAcaoModel> controleAcaoList = List<ControleAcaoModel>();
}

class ControleTarefaListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleTarefaListBlocEvent>();
  Stream<ControleTarefaListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleTarefaListBlocState _state = ControleTarefaListBlocState();
  final _stateController = BehaviorSubject<ControleTarefaListBlocState>();
  Stream<ControleTarefaListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleTarefaListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateTarefaUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateDataDestinatario() {
    if (_state.controleTarefaListDestinatario != null) {
      _state.isDataValidDestinatario = true;
    } else {
      _state.isDataValidDestinatario = false;
    }
  }

  _validateDataRemetente() {
    if (_state.controleTarefaListRemetente != null) {
      _state.isDataValidRemetente = true;
    } else {
      _state.isDataValidRemetente = false;
    }
  }

  _mapEventToState(ControleTarefaListBlocEvent event) async {
    if (event is UpdateTarefaUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;

      _state.controleTarefaListRemetente.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: false)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              ControleTarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleTarefaModel> controleTarefaList) {
        _state.controleTarefaListRemetente = controleTarefaList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });

      _state.controleTarefaListDestinatario.clear();
      // le todas as tarefas deste usuario como destinatario/recebida neste setor.
      final streamDocsDestinatario = _firestore
          .collection(ControleTarefaModel.collection)
          .where("destinatario.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: false)
          .snapshots();

      final snapListDestinatario = streamDocsDestinatario.map((snapDocs) =>
          snapDocs
              .documents
              .map((doc) =>
                  ControleTarefaModel(id: doc.documentID).fromMap(doc.data))
              .toList());

      snapListDestinatario
          .listen((List<ControleTarefaModel> controleTarefaList) {
        _state.controleTarefaListDestinatario = controleTarefaList;
      });

      var collRef = await _firestore
          .collection(SetorCensitarioModel.collection)
          .getDocuments();
      for (var documentSnapshot in collRef.documents) {
        _state.setorList.add(
            SetorCensitarioModel(id: documentSnapshot.documentID)
                .fromMap(documentSnapshot.data));
      }
    }
    if (event is SelectSetorIDEvent) {
      final SetorCensitarioModel setorID = event.setorID;
      final ControleTarefaModel tarefaID = event.tarefaID;

      // print('Setor selecionado: ${setorID}');
      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("setor.id", isEqualTo: setorID.id)
          .where("referencia", isEqualTo: tarefaID.referencia);
      final snap = await streamDocsRemetente.getDocuments();
      if (snap.documents.isEmpty) {
        //Criando uma tarefa nova COPIA DA ATUAL neste setor
        final docRefTarefa =
            _firestore.collection(ControleTarefaModel.collection).document();
        Map<String, dynamic> tarefa = Map<String, dynamic>();
        tarefa['referencia'] = tarefaID.referencia;
        tarefa['setor'] =
            SetorCensitarioID(id: setorID.id, nome: setorID.nome).toMap();
        tarefa['remetente'] = tarefaID.remetente.toMap();
        tarefa['destinatario'] = tarefaID.destinatario.toMap();
        tarefa['acaoTotal'] = tarefaID.acaoTotal;
        tarefa['acaoCumprida'] = 0;
        tarefa['ultimaAcaoCriada'] = tarefaID.ultimaAcaoCriada;
        tarefa['concluida'] = false;
        tarefa['nome'] = tarefaID.nome + ' COPIA ';
        tarefa['inicio'] = tarefaID.inicio;
        tarefa['fim'] = tarefaID.fim;
        tarefa['modificada'] = Bootstrap.instance.FieldValue.serverTimestamp();
        await docRefTarefa.setData(tarefa, merge: true);

        if (docRefTarefa.documentID != null) {
          // tarefa criada pode duplicar acaoes

          final streamDocsRemetente = _firestore
              .collection(ControleAcaoModel.collection)
              .where("tarefa.id", isEqualTo: tarefaID.id)
              .snapshots();

          final snapListRemetente = streamDocsRemetente.map((snapDocs) =>
              snapDocs.documents
                  .map((doc) =>
                      ControleAcaoModel(id: doc.documentID).fromMap(doc.data))
                  .toList());

          snapListRemetente.listen((List<ControleAcaoModel> controleAcaoList) {
            // _state.controleAcaoList = controleAcaoList;
            for (var acao in controleAcaoList) {
              final docRefAcao = _firestore
                  .collection(ControleAcaoModel.collection)
                  .document(null);
              Map<String, dynamic> acaoNOVA = Map<String, dynamic>();
              acaoNOVA['referencia'] = acao.referencia;
              acaoNOVA['tarefa'] =
                  ControleTarefaID(id: docRefTarefa.documentID, nome: tarefaID.nome)
                      .toMap();
              acaoNOVA['nome'] = acao.nome + ' COPIA ';
              acaoNOVA['setor'] =
                  SetorCensitarioID(id: setorID.id, nome: setorID.nome).toMap();
              acaoNOVA['remetente'] = acao.remetente.toMap();
              acaoNOVA['destinatario'] = acao.destinatario.toMap();
              acaoNOVA['concluida'] = false;
              acaoNOVA['modificada'] =
                  Bootstrap.instance.FieldValue.serverTimestamp();
              acaoNOVA['numeroCriacao'] = acao.numeroCriacao;
              // print(acaoNOVA);
              docRefAcao.setData(acaoNOVA, merge: true);
            }
          });
        } else {
          print(
              'ControleTarefaListBloc. Algo deu errado. Tarefa nao duplicada.');
        }
      }
    }

    _validateDataDestinatario();
    _validateDataRemetente();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaListBloc  = ${event.runtimeType}');
  }
}
