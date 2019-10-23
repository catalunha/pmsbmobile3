import 'package:flutter/material.dart' show TimeOfDay;
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:uuid/uuid.dart' as uuid;

import '../../bootstrap.dart';

class ControleTarefaCrudBlocEvent {}

class UpdateTarefaCrudUsuarioIDEvent extends ControleTarefaCrudBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaCrudUsuarioIDEvent(this.usuarioID);
}

class UpdateUsuarioListEvent extends ControleTarefaCrudBlocEvent {}

class UpdateTarefaIDEvent extends ControleTarefaCrudBlocEvent {
  final String tarefaId;
  final String acaoId;
  final String acaoNome;

  UpdateTarefaIDEvent({this.tarefaId, this.acaoId, this.acaoNome});
}

class SelectDestinatarioIDEvent extends ControleTarefaCrudBlocEvent {
  final UsuarioModel destinatarioID;

  SelectDestinatarioIDEvent(this.destinatarioID);
}

class UpdateNomeEvent extends ControleTarefaCrudBlocEvent {
  final String nome;

  UpdateNomeEvent(this.nome);
}

class UpdateInicioEvent extends ControleTarefaCrudBlocEvent {
  final DateTime data;
  final TimeOfDay hora;

  UpdateInicioEvent({this.data, this.hora});
}

class UpdateFimEvent extends ControleTarefaCrudBlocEvent {
  final DateTime data;
  final TimeOfDay hora;

  UpdateFimEvent({this.data, this.hora});
}

class DeleteEvent extends ControleTarefaCrudBlocEvent {}

class SaveEvent extends ControleTarefaCrudBlocEvent {}

class ControleTarefaCrudBlocState {
  UsuarioModel usuarioID;
  UsuarioID destinatario;
  List<UsuarioModel> usuarioList = List<UsuarioModel>();
  ControleTarefaModel controleTarefaID;
  String controleTarefaId;
  String acaoId;
  String nome;
  DateTime inicio = DateTime.now();
  DateTime dataInicio;
  TimeOfDay horaInicio;
  DateTime fim = DateTime.now();
  DateTime dataFim;
  TimeOfDay horaFim;

  bool isDataValid = false;

  void updateStateFromControleTarefaModel() {
    nome = controleTarefaID.nome;
    inicio = controleTarefaID.inicio;
    fim = controleTarefaID.fim;
    destinatario = controleTarefaID.destinatario;
  }
}

class ControleTarefaCrudBloc {
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ControleTarefaCrudBlocEvent>();
  Stream<ControleTarefaCrudBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ControleTarefaCrudBlocState _state = ControleTarefaCrudBlocState();
  final _stateController = BehaviorSubject<ControleTarefaCrudBlocState>();
  Stream<ControleTarefaCrudBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// bloc
  ControleTarefaCrudBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateTarefaCrudUsuarioIDEvent(usuarioID));
    });
    eventSink(UpdateUsuarioListEvent());
  }

  void dispose() async {
    _authBloc.dispose();
    await _eventController.drain();
    _eventController.close();
    await _stateController.drain();
    _stateController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    if (_state.nome == null || _state.nome.isEmpty) {
      _state.isDataValid = false;
    }
    if (_state.destinatario == null) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ControleTarefaCrudBlocEvent event) async {
    if (event is UpdateTarefaCrudUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateUsuarioListEvent) {
      var collRef =
          await _firestore.collection(UsuarioModel.collection).getDocuments();

      for (var documentSnapshot in collRef.documents) {
        _state.usuarioList.add(UsuarioModel(id: documentSnapshot.documentID)
            .fromMap(documentSnapshot.data));
      }

      _state.usuarioList.sort((a, b) => a.nome.compareTo(b.nome));
    }
    if (event is UpdateTarefaIDEvent) {
      _state.controleTarefaId = event.tarefaId;
      _state.acaoId = event.acaoId;
      _state.nome = event.acaoNome;
      if (event.tarefaId != null) {
        var docRef = _firestore
            .collection(ControleTarefaModel.collection)
            .document(event.tarefaId);
        final snap = await docRef.get();
        if (snap.exists) {
          _state.controleTarefaID =
              ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
          _state.updateStateFromControleTarefaModel();
        }
      }
    }
    if (event is UpdateNomeEvent) {
      _state.nome = event.nome;
    }

    if (event is UpdateInicioEvent) {
      if (event.data != null) {
        _state.dataInicio = event.data;
      }
      if (event.hora != null) {
        _state.horaInicio = event.hora;
      }

      final newDate = DateTime(
          _state.dataInicio != null
              ? _state.dataInicio.year
              : _state.inicio.year,
          _state.dataInicio != null
              ? _state.dataInicio.month
              : _state.inicio.month,
          _state.dataInicio != null ? _state.dataInicio.day : _state.inicio.day,
          _state.horaInicio != null
              ? _state.horaInicio.hour
              : _state.inicio.hour,
          _state.horaInicio != null
              ? _state.horaInicio.minute
              : _state.inicio.minute);
      _state.inicio = newDate;
    }
    if (event is UpdateFimEvent) {
      if (event.data != null) {
        _state.dataFim = event.data;
      }
      if (event.hora != null) {
        _state.horaFim = event.hora;
      }

      final newDate = DateTime(
          _state.dataFim != null ? _state.dataFim.year : _state.fim.year,
          _state.dataFim != null ? _state.dataFim.month : _state.fim.month,
          _state.dataFim != null ? _state.dataFim.day : _state.fim.day,
          _state.horaFim != null ? _state.horaFim.hour : _state.fim.hour,
          _state.horaFim != null ? _state.horaFim.minute : _state.fim.minute);
      _state.fim = newDate;
    }
    if (event is DeleteEvent) {
      final streamDocsRemetente = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: _state.controleTarefaID.id)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ControleAcaoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleAcaoModel> controleAcaoList) {
        for (var acao in controleAcaoList) {
          _firestore
              .collection(ControleAcaoModel.collection)
              .document(acao.id)
              .delete();
        }
      });

      _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaID.id)
          .delete();
    }

    if (event is SelectDestinatarioIDEvent) {
      _state.destinatario = UsuarioID(
          id: event.destinatarioID.id, nome: event.destinatarioID.nome);
    }

    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaId);
      Map<String, dynamic> tarefa = Map<String, dynamic>();
      if (_state.controleTarefaId == null) {
        final uuidG = uuid.Uuid();
        tarefa['referencia'] = uuidG.v4();
        tarefa['setor'] = _state.usuarioID.setorCensitarioID.toMap();
        tarefa['remetente'] =
            UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome)
                .toMap();
        tarefa['acaoTotal'] = 0;
        tarefa['acaoCumprida'] = 0;
        tarefa['ultimaOrdemAcao'] = 0;
        tarefa['concluida'] = false;
      }
      if (_state.acaoId != null) {
        tarefa['acaoLink'] = _state.acaoId;
      }
      tarefa['nome'] = _state.nome;
      tarefa['inicio'] = _state.inicio;
      tarefa['fim'] = _state.fim;
      tarefa['modificada'] = Bootstrap.instance.fieldValue.serverTimestamp();
      tarefa['destinatario'] = _state.destinatario.toMap();

      docRef.setData(tarefa, merge: true);

      if (_state.acaoId != null) {
        final docRefAcao = _firestore
            .collection(ControleAcaoModel.collection)
            .document(_state.acaoId);
        docRefAcao.setData({'tarefaLink': {docRef.documentID:true}}, merge: true);
      }
    }
    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaCrudBloc  = ${event.runtimeType}');
  }
}
