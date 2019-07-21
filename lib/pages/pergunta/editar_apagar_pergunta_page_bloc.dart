import 'dart:async';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:uuid/uuid.dart' as uuid;

class EditarApagarPerguntaBlocState {
  PerguntaModel instance;
  String id;
  Questionario questionario;
  String titulo;
  String textoMarkdown;
  PerguntaTipo tipo;
  PerguntaTipoEnum tipoEnum;

  List<Requisito> requisitos;
  Map<String, Escolha> escolhas;

  bool isValid;
  bool isBaund;

  String itemEscolha;
  String itemEscolhaID;

  void updateFromInstance() {
    questionario = instance.questionario;
    titulo = instance.titulo;
    textoMarkdown = instance.textoMarkdown;
    tipo = instance.tipo;
    if (tipo != null) tipoEnum = PerguntaTipoModel.ENUM[instance.tipo.id];
    requisitos = instance.requisitos;
    escolhas = instance.escolhas;
  }
}

class EditarApagarPerguntaBlocEvent {}

class InitEditarApagarPerguntaBlocEvent extends EditarApagarPerguntaBlocEvent {
  final defaultTipoPergunta = PerguntaTipoEnum.Texto;
  final defaultTextoMarkdown = "";
  final defaultIsBaund = false;
  final defaultIsValid = false;
}

class UpdateIDEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final id;

  UpdateIDEditarApagarPerguntaBlocEvent(this.id);
}

class UpdateQuestionarioEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final String questionarioId;

  UpdateQuestionarioEditarApagarPerguntaBlocEvent(this.questionarioId);
}

class UpdateTipoPerguntaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final PerguntaTipoEnum tipo;

  UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(this.tipo);
}

class UpdateTituloPerguntaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final String titulo;

  UpdateTituloPerguntaEditarApagarPerguntaBlocEvent(this.titulo);
}

class UpdateTextoMarkdownPerguntaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final String textoMarkdown;

  UpdateTextoMarkdownPerguntaEditarApagarPerguntaBlocEvent(this.textoMarkdown);
}

//escolha
class UpdateItemEscolhaIDEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final String itemEscolhaID;

  UpdateItemEscolhaIDEditarApagarPerguntaBlocEvent(this.itemEscolhaID);
}

class UpdateItemEscolhaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final String itemEscolha;

  UpdateItemEscolhaEditarApagarPerguntaBlocEvent(this.itemEscolha);
}

class AddItemEscolhaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {}

class DeletarItemEscolhaEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {}

class SaveEditarApagarPerguntaBlocEvent extends EditarApagarPerguntaBlocEvent {}

class DeletarEditarApagarPerguntaBlocEvent extends EditarApagarPerguntaBlocEvent {}

class EditarApagarPerguntaBloc {
  final fsw.Firestore _firestore;
  final _state = EditarApagarPerguntaBlocState();
  final _inputController = BehaviorSubject<EditarApagarPerguntaBlocEvent>();

  Function get dispatch => _inputController.add;
  final _outputController = BehaviorSubject<EditarApagarPerguntaBlocState>();

  Stream<EditarApagarPerguntaBlocState> get state => _outputController.stream;

  void dispose() {
    _inputController.close();
    _outputController.close();
  }

  EditarApagarPerguntaBloc(this._firestore) {
    _inputController.listen(_handleInput);
    dispatch(InitEditarApagarPerguntaBlocEvent());
  }

  void validate() {
    bool isValid = true;

    if (_state.titulo == null || _state.titulo.trim().isEmpty) {
      isValid = false;
    }

    if (_state.textoMarkdown == null || _state.textoMarkdown.trim().isEmpty) {
      isValid = false;
    }

    _state.isValid = isValid;

    if (_state.instance != null) {
      _state.isBaund = true;
    } else {
      _state.isBaund = false;
    }
  }

  void _handleInput(EditarApagarPerguntaBlocEvent event) async {
    if (event is InitEditarApagarPerguntaBlocEvent) {
      dispatch(UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
          event.defaultTipoPergunta));
      _state.textoMarkdown = event.defaultTextoMarkdown;
      _state.requisitos = List<Requisito>();
      _state.escolhas = Map<String, Escolha>();
    }

    if (event is UpdateIDEditarApagarPerguntaBlocEvent) {
      if (event.id != null) {
        _state.id = event.id;
        final ref =
            _firestore.collection(PerguntaModel.collection).document(_state.id);
        final snap = await ref.get();
        if (snap.exists) {
          _state.instance =
              PerguntaModel(id: snap.documentID).fromMap(snap.data);
          _state.updateFromInstance();
        }
      }
    }

    if (event is UpdateTituloPerguntaEditarApagarPerguntaBlocEvent) {
      _state.titulo = event.titulo;
    }

    if (event is UpdateTextoMarkdownPerguntaEditarApagarPerguntaBlocEvent) {
      _state.textoMarkdown = event.textoMarkdown;
    }

    if (event is UpdateQuestionarioEditarApagarPerguntaBlocEvent) {
      if (event.questionarioId != null) {
        final ref = _firestore
            .collection(QuestionarioModel.collection)
            .document(event.questionarioId);

        final snap = await ref.get();
        if (snap.exists) {
          _state.questionario = Questionario.fromMap({
            "id": snap.documentID,
            ...snap.data,
          });
        }
      }
    }

    if (event is UpdateTipoPerguntaEditarApagarPerguntaBlocEvent) {
      _state.tipoEnum = event.tipo;
      _state.tipo = PerguntaTipo(PerguntaTipoModel.IDS[event.tipo],
          PerguntaTipoModel.NOMES[event.tipo]);
    }
    //adicionar, editar e remover requisito


    //adicionar , editar e remover escolha
    if (event is UpdateItemEscolhaIDEditarApagarPerguntaBlocEvent) {
      _state.itemEscolhaID = event.itemEscolhaID;
    }
    if (event is UpdateItemEscolhaEditarApagarPerguntaBlocEvent) {
      _state.itemEscolha = event.itemEscolha;
    }
    if (event is AddItemEscolhaEditarApagarPerguntaBlocEvent) {
      final uuidG = uuid.Uuid();

      final escolhaID =
          _state.itemEscolhaID == null ? uuidG.v4() : _state.itemEscolhaID;

      _state.escolhas[escolhaID] = Escolha(
        uid: escolhaID,
        key: true,
        marcada: false,
        ordem: 0,
        texto: _state.itemEscolha,
      );
      _state.itemEscolha = null;
      _state.itemEscolhaID = null;
    }

    if (event is DeletarItemEscolhaEditarApagarPerguntaBlocEvent) {
      //TODO: este codigo não remove item de dicionario no firestore
      _state.escolhas.remove(_state.itemEscolhaID);
    }

    //salvar e deletar geral
    if (event is SaveEditarApagarPerguntaBlocEvent) {
      if (_state.isValid) {
        final ref =
            _firestore.collection(PerguntaModel.collection).document(_state.id);

        //TODO: revisar para casos de adição e edição
        final instance = PerguntaModel(
          titulo: _state.titulo,
          textoMarkdown: _state.textoMarkdown,
          questionario: _state.questionario,
          tipo: _state.tipo,
          requisitos: _state.requisitos,
          escolhas: _state.escolhas,
          ordem: 0,
          dataCriacao: DateTime.now(),
          dataEdicao: DateTime.now(),
        );
        ref.setData(instance.toMap(), merge: true);
        final snap = await ref.get();
        _state.instance = PerguntaModel(id: snap.documentID).fromMap(snap.data);
      }
    }

    if(event is DeletarEditarApagarPerguntaBlocEvent){
      final ref =
      _firestore.collection(PerguntaModel.collection).document(_state.id);
      ref.delete();
    }

    validate();

    if (!_outputController.isClosed) _outputController.add(_state);
    print(event.runtimeType);
  }
}
