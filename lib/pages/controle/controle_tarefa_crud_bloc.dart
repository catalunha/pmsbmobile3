import 'package:flutter/material.dart' show TimeOfDay;
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ControleTarefaCrudBlocEvent {}

class UpdateTarefaCrudUsuarioIDEvent extends ControleTarefaCrudBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaCrudUsuarioIDEvent(this.usuarioID);
}

class UpdateTarefaIDEvent extends ControleTarefaCrudBlocEvent {
  final String tarefaID;

  UpdateTarefaIDEvent(this.tarefaID);
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

// class UpdateDestinatarioListEvent extends ControleTarefaCrudBlocEvent {
//   List<Map<dynamic, dynamic>> destinatarioList = List<Map<dynamic, dynamic>>();

//   UpdateDestinatarioListEvent(this.destinatarioList);
// }

// class UpdateTextoMarkdownEvent extends ControleTarefaCrudBlocEvent {
//   final String textoMarkdown;

//   UpdateTextoMarkdownEvent(this.textoMarkdown);
// }

class ControleTarefaCrudBlocState {
  UsuarioModel usuarioID;
  ControleTarefaModel controleTarefaID;
  String nome;

  void updateStateFromControleTarefaModel() {
    nome = controleTarefaID.nome;
  }

//   String noticiaID;

//   UsuarioIDEditor usuarioIDEditor;
//   String textoMarkdown;
  DateTime inicio = DateTime.now();
  DateTime dataInicio;
  TimeOfDay horaInicio;
  DateTime fim = DateTime.now();
  DateTime dataFim;
  TimeOfDay horaFim;
//   List<Map<String, dynamic>> destinatarioListMap = List<Map<String, dynamic>>();

// /*
// [
//   {
//     usuarioID:usuarioID
//     nome:usuarioID->nome
//   },
// ]
// */

//   void fromNoticiaModel(NoticiaModel noticiaModel) {
//     currentNoticiaModel = noticiaModel;
//     noticiaID = noticiaModel.id;
//     usuarioIDEditor = noticiaModel.usuarioIDEditor;
//     titulo = noticiaModel.titulo;
//     textoMarkdown = noticiaModel.textoMarkdown;
//     publicar = noticiaModel.publicar;
//     // print('>>> noticiaModel.id >>> ${noticiaModel.id}');
//     // print(
//     //     '>>> noticiaModel.usuarioIDDestino >>> ${noticiaModel.usuarioIDDestino}');
//     // destinatarioListMap =
//     //     noticiaModel.usuarioIDDestino.map((v) => v.toMap()).toList();
//     noticiaModel.usuarioIDDestino.forEach((k, v) {
// // print('>> k >> ${k}');
// // print('>> v >> ${v}');
//       destinatarioListMap.add(
//         {'usuarioID': '${k}', 'nome': '${v.nome}'},
//       );
//     });
  // }

  // NoticiaModel toNoticiaModel() {
  //   // List<Destinatario> usuarioIDDestino = [];
  //   Map<String, Destinatario> usuarioIDDestino = Map<String, Destinatario>();
  //   // print('>>>>>> ${destinatarioListMap}');
  //   // destinatarioListMap.map((item) => destinatarioList.add(item['usuarioID']));

  //   destinatarioListMap.forEach((item) {
  //     // print(item['usuarioID']);
  //     // print(item['nome']);
  //     usuarioIDDestino[item['usuarioID']] = Destinatario(
  //         uid: item['usuarioID'],
  //         id: true,
  //         nome: item['nome'],
  //         visualizada: false);
  //     // print('>> usuarioIDDestino >> ${usuarioIDDestino.toString()}');
  //   });
  //   // print('>>>>>> ${destinatarioList}');
  //   return NoticiaModel(
  //     usuarioIDEditor: usuarioIDEditor,
  //     titulo: titulo,
  //     // publicada: false,
  //     textoMarkdown: textoMarkdown,
  //     usuarioIDDestino: usuarioIDDestino,
  //     publicar: publicar ?? null,
  //   );
  // }
}

class ControleTarefaCrudBloc {
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleTarefaCrudBlocEvent>();
  Stream<ControleTarefaCrudBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleTarefaCrudBlocState _state = ControleTarefaCrudBlocState();
  final _stateController = BehaviorSubject<ControleTarefaCrudBlocState>();
  Stream<ControleTarefaCrudBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //bloc
  ControleTarefaCrudBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateTarefaCrudUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    _authBloc.dispose();
    await _eventController.drain();
    _eventController.close();
    await _stateController.drain();
    _stateController.close();
  }

  // void _dispatchUpdateUserId(String userId) {
  //   ControleTarefaCrudBlocEventSink(UpDateUsuarioIDEditorEvent(userId));
  // }

  _mapEventToState(ControleTarefaCrudBlocEvent event) async {
    if (event is UpdateTarefaCrudUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateTarefaIDEvent) {
      if (event.tarefaID != null) {
        var docRef = _firestore
            .collection(NoticiaModel.collection)
            .document(event.tarefaID);
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

      if (_state.dataInicio != null && _state.horaInicio != null) {
        final newDate = DateTime(
            _state.dataInicio != null
                ? _state.dataInicio.year
                : _state.inicio.year,
            _state.dataInicio != null
                ? _state.dataInicio.month
                : _state.inicio.month,
            _state.dataInicio != null
                ? _state.dataInicio.day
                : _state.inicio.day,
            _state.horaInicio != null
                ? _state.horaInicio.hour
                : _state.inicio.hour,
            _state.horaInicio != null
                ? _state.horaInicio.minute
                : _state.inicio.minute);
        _state.inicio = newDate;
      }
    }
    if (event is UpdateFimEvent) {
      if (event.data != null) {
        _state.dataFim = event.data;
      }
      if (event.hora != null) {
        _state.horaFim = event.hora;
      }

      if (_state.dataFim != null && _state.horaFim != null) {
        final newDate = DateTime(
            _state.dataFim != null ? _state.dataFim.year : _state.fim.year,
            _state.dataFim != null ? _state.dataFim.month : _state.fim.month,
            _state.dataFim != null ? _state.dataFim.day : _state.fim.day,
            _state.horaFim != null ? _state.horaFim.hour : _state.fim.hour,
            _state.horaFim != null ? _state.horaFim.minute : _state.fim.minute);
        _state.fim = newDate;
      }
    }
    if (event is DeleteEvent) {
      _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaID.id)
          .delete();
    }

    // if (event is UpdateDestinatarioListEvent) {
    //   _state.destinatarioListMap = event.destinatarioList;
    // }
    // if (event is UpdateTextoMarkdownEvent) {
    //   _state.textoMarkdown = event.textoMarkdown;
    // }

    if (event is SaveEvent) {
      // // print(map);
      final docRef = _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaID.id);

      // docRef.setData(map);
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaCrudBloc  = ${event.runtimeType}');
  }
}
