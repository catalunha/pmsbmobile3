import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';

class ControleTarefaListBlocEvent {}

class UpdateTarefaUsuarioIDEvent extends ControleTarefaListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaUsuarioIDEvent(this.usuarioID);
}

class DuplicarTarefaEvent extends ControleTarefaListBlocEvent {
  final SetorCensitarioID setorID;
  final ControleTarefaModel tarefaID;

  DuplicarTarefaEvent({this.tarefaID, this.setorID});
}

class UpdateTarefaDuplicadaPorSetorEvent extends ControleTarefaListBlocEvent {
  final ControleTarefaModel controleTarefa;

  UpdateTarefaDuplicadaPorSetorEvent(this.controleTarefa);
}

class VerAcaoGerouTarefaEvent extends ControleTarefaListBlocEvent {
  final String acaoLink;

  VerAcaoGerouTarefaEvent({this.acaoLink});
}

class UpdateRelatorioPdfMakeEvent extends ControleTarefaListBlocEvent {}

class GerarRelatorioPdfMakeEvent extends ControleTarefaListBlocEvent {
  final bool pdfGerar;
  final bool pdfGerado;
  final String tipo;
  final String collection;
  final String document;

  GerarRelatorioPdfMakeEvent({
    this.pdfGerar,
    this.pdfGerado,
    this.tipo,
    this.collection,
    this.document,
  });
}

class TarefaDuplicadaNoSetor {
  SetorCensitarioID setorCensitarioID;
  bool duplicado;
  TarefaDuplicadaNoSetor({this.setorCensitarioID, this.duplicado});
}

class ControleTarefaListBlocState {
  UsuarioModel usuarioID;
  List<ControleTarefaModel> controleTarefaListDestinatario =
      List<ControleTarefaModel>();
  List<ControleTarefaModel> controleTarefaListRemetente =
      List<ControleTarefaModel>();
  bool isDataValidDestinatario = false;
  bool isDataValidRemetente = false;

  Map<String, TarefaDuplicadaNoSetor> tarefaDuplicadaNoSetorMap =
      Map<String, TarefaDuplicadaNoSetor>();

  String tarefaBase;

  RelatorioPdfMakeModel relatorioPdfMakeModel;
}

class ControleTarefaListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ControleTarefaListBlocEvent>();
  Stream<ControleTarefaListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ControleTarefaListBlocState _state = ControleTarefaListBlocState();
  final _stateController = BehaviorSubject<ControleTarefaListBlocState>();
  Stream<ControleTarefaListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
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
      _state.usuarioID = event.usuarioID;

      _state.controleTarefaListRemetente.clear();
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
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is VerAcaoGerouTarefaEvent) {
      var docRef = _firestore
          .collection(ControleAcaoModel.collection)
          .document(event.acaoLink);
      final snap = await docRef.get();
      _state.tarefaBase = snap.data['tarefa']['id'];
    }

    if (event is UpdateTarefaDuplicadaPorSetorEvent) {
      Map<String, SetorCensitarioID> setorMap =
          Map<String, SetorCensitarioID>();
      setorMap.clear();
      var collRef = await _firestore
          .collection(SetorCensitarioModel.collection)
          .getDocuments();
      for (var documentSnapshot in collRef.documents) {
        setorMap[documentSnapshot.documentID] = SetorCensitarioID(
            id: documentSnapshot.documentID,
            nome: documentSnapshot.data['nome']);
      }

      Map<String, SetorCensitarioID> setorEmQATarefaFoiDuplicadaMap =
          Map<String, SetorCensitarioID>();
      setorEmQATarefaFoiDuplicadaMap.clear();
      final streamDocsRemetente2 = await _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: _state.usuarioID.id)
          .where("referencia", isEqualTo: event.controleTarefa.referencia)
          .where("concluida", isEqualTo: false)
          .getDocuments();
      for (var documentSnapshot in streamDocsRemetente2.documents) {
        setorEmQATarefaFoiDuplicadaMap[documentSnapshot.data['setor']['id']] =
            SetorCensitarioID.fromMap(documentSnapshot.data['setor']);
      }

      _state.tarefaDuplicadaNoSetorMap.clear();
      for (var setor in setorMap.entries) {
        _state.tarefaDuplicadaNoSetorMap[setor.key] = TarefaDuplicadaNoSetor(
            setorCensitarioID: setor.value,
            duplicado: setorEmQATarefaFoiDuplicadaMap.containsKey(setor.key));
      }
    }

    if (event is DuplicarTarefaEvent) {
      final SetorCensitarioID setorID = event.setorID;
      final ControleTarefaModel tarefaID = event.tarefaID;

      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("setor.id", isEqualTo: setorID.id)
          .where("referencia", isEqualTo: tarefaID.referencia);
      final snap = await streamDocsRemetente.getDocuments();
      if (snap.documents.isEmpty) {
        final docRefTarefa =
            _firestore.collection(ControleTarefaModel.collection).document();
        Map<String, dynamic> tarefa = Map<String, dynamic>();
        tarefa['referencia'] = tarefaID.referencia;
        tarefa['setor'] = setorID.toMap();
        tarefa['remetente'] = tarefaID.remetente.toMap();
        tarefa['destinatario'] = tarefaID.destinatario.toMap();
        tarefa['acaoTotal'] = tarefaID.acaoTotal;
        tarefa['acaoCumprida'] = 0;
        tarefa['ultimaOrdemAcao'] = tarefaID.ultimaOrdemAcao;
        tarefa['concluida'] = false;
        tarefa['nome'] = tarefaID.nome;
        tarefa['inicio'] = tarefaID.inicio;
        tarefa['fim'] = tarefaID.fim;
        tarefa['modificada'] = Bootstrap.instance.fieldValue.serverTimestamp();
        await docRefTarefa.setData(tarefa, merge: true);

        if (docRefTarefa.documentID != null) {
          final streamDocsRemetente = await _firestore
              .collection(ControleAcaoModel.collection)
              .where("tarefa.id", isEqualTo: tarefaID.id)
              .getDocuments();

          for (var docSnap in streamDocsRemetente.documents) {
            ControleAcaoModel controleAcaoModel =
                ControleAcaoModel(id: docSnap.documentID).fromMap(docSnap.data);
            final docRefAcao = _firestore
                .collection(ControleAcaoModel.collection)
                .document(null);
            Map<String, dynamic> acaoNOVA = Map<String, dynamic>();
            acaoNOVA['referencia'] = controleAcaoModel.referencia;
            acaoNOVA['tarefa'] = ControleTarefaID(
                    id: docRefTarefa.documentID, nome: tarefaID.nome)
                .toMap();
            acaoNOVA['nome'] = controleAcaoModel.nome;
            acaoNOVA['setor'] =
                SetorCensitarioID(id: setorID.id, nome: setorID.nome).toMap();
            acaoNOVA['remetente'] = controleAcaoModel.remetente.toMap();
            acaoNOVA['destinatario'] = controleAcaoModel.destinatario.toMap();
            acaoNOVA['concluida'] = false;
            acaoNOVA['modificada'] =
                Bootstrap.instance.fieldValue.serverTimestamp();
            acaoNOVA['ordem'] = controleAcaoModel.ordem;
            docRefAcao.setData(acaoNOVA, merge: true);
          }
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
