import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:rxdart/rxdart.dart';

class ControleAcaoListBlocEvent {}

class UpdateTarefaIDEvent extends ControleAcaoListBlocEvent {
  final String controleTarefaID;

  UpdateTarefaIDEvent(this.controleTarefaID);
}

class OrdenarAcaoEvent extends ControleAcaoListBlocEvent {
  final ControleAcaoModel acao;
  final bool up;

  OrdenarAcaoEvent(this.acao, this.up);
}
class UpdateTarefaListEvent extends ControleAcaoListBlocEvent {
  final ControleAcaoModel acaoID;

  UpdateTarefaListEvent(this.acaoID);
}

class SelectTarefaIDEvent extends ControleAcaoListBlocEvent {
  final ControleTarefaModel tarefaID;
  final ControleAcaoModel acaoID;

  SelectTarefaIDEvent({this.acaoID, this.tarefaID});
}

class ControleAcaoListBlocState {
  ControleTarefaModel controleTarefaID = ControleTarefaModel();
  List<ControleAcaoModel> controleAcaoList = List<ControleAcaoModel>();
  bool isDataValid;

  List<ControleTarefaModel> controleTarefaListRemetente = List<ControleTarefaModel>();
}

class ControleAcaoListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleAcaoListBlocEvent>();
  Stream<ControleAcaoListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleAcaoListBlocState _state = ControleAcaoListBlocState();
  final _stateController = BehaviorSubject<ControleAcaoListBlocState>();
  Stream<ControleAcaoListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleAcaoListBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    if (_state.controleTarefaID != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
    if (_state.controleAcaoList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ControleAcaoListBlocEvent event) async {
    if (event is UpdateTarefaIDEvent) {
      //Atualiza estado com usuario logado
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      // final docRef = _firestore
      //     .collection(ControleTarefaModel.collection)
      //     .document(event.controleTarefaID);
      // final snap = await docRef.get();
      // if (snap.exists) {
      //   _state.controleTarefaID =
      //       ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
      // }

    final streamDocsTarefa = _firestore
          .collection(ControleTarefaModel.collection)
          .document(event.controleTarefaID)
          .snapshots();

      final snapTarefa = streamDocsTarefa.map((snapDocs) =>
          ControleTarefaModel(id: snapDocs.documentID).fromMap(snapDocs.data));
      //       .toList());

      snapTarefa.listen((ControleTarefaModel controleTarefa) {
        _state.controleTarefaID = controleTarefa;
        if (!_stateController.isClosed) _stateController.add(_state);
      });




      _state.controleAcaoList.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: event.controleTarefaID)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ControleAcaoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleAcaoModel> controleAcaoList) {
        if (controleAcaoList.length > 1) {
          controleAcaoList
              .sort((a, b) => a.ordem.compareTo(b.ordem));
        }
        _state.controleAcaoList = controleAcaoList;

        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is OrdenarAcaoEvent) {
      final indexOrigem = _state.controleAcaoList.indexOf(event.acao);
      final indexOutro = event.up ? indexOrigem - 1 : indexOrigem + 1;
      final ordemOrigem =
          _state.controleAcaoList[indexOrigem].ordem;
      final ordemOutro =
          _state.controleAcaoList[indexOutro].ordem;

      final docRefOrigem = _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.controleAcaoList[indexOrigem].id);

      docRefOrigem.setData({"ordem": ordemOutro}, merge: true);

      final docRefOutro = _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.controleAcaoList[indexOutro].id);

      docRefOutro.setData({"ordem": ordemOrigem}, merge: true);
    }
    if (event is UpdateTarefaListEvent) {
      final ControleAcaoModel acaoID = event.acaoID;

      _state.controleTarefaListRemetente.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: acaoID.remetente.id)
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
  }

    if (event is SelectTarefaIDEvent) {
      final ControleTarefaModel tarefa = event.tarefaID;
      final ControleAcaoModel acao = event.acaoID;


      final streamDocsRemetente = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: tarefa.id)
          .where("referencia", isEqualTo: acao.referencia);
      final snap = await streamDocsRemetente.getDocuments();

      if (snap.documents.isEmpty) {
        // localizar a tarefa e atualizar o recebimento desta nova
      final docRefTarefa = _firestore
          .collection(ControleTarefaModel.collection)
          .document(tarefa.id);
      await docRefTarefa.setData({
        'acaoTotal': Bootstrap.instance.FieldValue.increment(1),
        'ultimaOrdemAcao': Bootstrap.instance.FieldValue.increment(1),
        'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
      }, merge: true);

      final docRefTarefaAtualizada = _firestore
          .collection(ControleTarefaModel.collection)
          .document(tarefa.id);
      final snap = await docRefTarefaAtualizada.get();
      ControleTarefaModel tarefaID = ControleTarefaModel();
      tarefaID = ControleTarefaModel(id: snap.documentID).fromMap(snap.data);

      final docRefAcao =
          _firestore.collection(ControleAcaoModel.collection).document(null);
      Map<String, dynamic> acaoNOVA = Map<String, dynamic>();
      acaoNOVA['referencia'] = acao.referencia;
      acaoNOVA['tarefa'] =
      ControleTarefaID(id: tarefaID.id, nome: tarefaID.nome)
          .toMap();
      acaoNOVA['nome'] = acao.nome + ' COPIA ';
      acaoNOVA['setor'] = acao.setor.toMap();
          // SetorCensitarioID(id: setor.id, nome: setor.nome).toMap();
      acaoNOVA['remetente'] = acao.remetente.toMap();
      acaoNOVA['destinatario'] = acao.destinatario.toMap();
      acaoNOVA['concluida'] = false;
      acaoNOVA['modificada'] = Bootstrap.instance.FieldValue.serverTimestamp();
      acaoNOVA['ordem'] = tarefaID.ultimaOrdemAcao;
      // print(acaoNOVA);
      await docRefAcao.setData(acaoNOVA, merge: true);

     }

    }

    _validateData();
    // print(_state.controleAcaoList.toString());
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaDestinatarioAcaoMarcarBloc  = ${event.runtimeType}');
  }
}
