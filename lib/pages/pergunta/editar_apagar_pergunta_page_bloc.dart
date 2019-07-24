import 'dart:async';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:pmsbmibile3/bootstrap.dart';

class EditarApagarPerguntaBlocState {
  PerguntaModel instance;
  QuestionarioModel questionarioInstance;
  String id;
  Questionario questionario;
  String titulo;
  String textoMarkdown;
  PerguntaTipo tipo;
  PerguntaTipoEnum tipoEnum;
  int ordem = 0;
  String anterior;
  String posterior;

  Map<String, Requisito> requisitos;
  Map<String, dynamic> requisitosRemovidos = Map<String, dynamic>();
  Map<String, Escolha> escolhas;
  Map<String, dynamic> escolhasRemovidas = Map<String, dynamic>();
  bool isValid;
  bool isBaund;

  String itemEscolha;
  String itemEscolhaID;

  void updateFromInstance() {
    questionario = instance.questionario;
    titulo = instance.titulo;
    textoMarkdown = instance.textoMarkdown;
    tipo = instance.tipo;
    ordem = instance.ordem;
    if (tipo != null) tipoEnum = PerguntaTipoModel.ENUM[instance.tipo.id];
    requisitos = instance.requisitos != null ? instance.requisitos : requisitos;
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

class UpdateRequisitosEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {
  final Map<String, Map<String, dynamic>> requisitos;

  UpdateRequisitosEditarApagarPerguntaBlocEvent(this.requisitos);
}

class SaveEditarApagarPerguntaBlocEvent extends EditarApagarPerguntaBlocEvent {}

class DeletarEditarApagarPerguntaBlocEvent
    extends EditarApagarPerguntaBlocEvent {}

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
      _state.requisitos = Map<String, Requisito>();
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
          _state.questionarioInstance =
              QuestionarioModel(id: snap.documentID).fromMap(snap.data);

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
    if (event is UpdateRequisitosEditarApagarPerguntaBlocEvent) {
      event.requisitos.forEach((key, value) {
        if (value["checkbox"] != null) {
          if (value["checkbox"]) {
            _state.requisitos[key] = value["requisito"];
          } else {
            _state.requisitosRemovidos[key] =
                Bootstrap.instance.FieldValue.delete();
          }
        }
      });
    }

    //adicionar , editar e remover escolha
    if (event is UpdateItemEscolhaIDEditarApagarPerguntaBlocEvent) {
      _state.itemEscolhaID = event.itemEscolhaID;
      _state.itemEscolha = _state.escolhas[event.itemEscolhaID].texto;
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
      _state.escolhas.remove(_state.itemEscolhaID);
      _state.escolhasRemovidas[_state.itemEscolhaID] =
          Bootstrap.instance.FieldValue.delete();
    }

    //salvar e deletar geral
    if (event is SaveEditarApagarPerguntaBlocEvent) {
      if (_state.isValid) {
        final ref =
            _firestore.collection(PerguntaModel.collection).document(_state.id);

        //anterior, posterior e ordem
        final questionarioRef = _firestore
            .collection(QuestionarioModel.collection)
            .document(_state.questionarioInstance.id);

        String questionarioPrimeiraPerguntaID;
        String questionarioUltimaPerguntaID;
        String referencia;
        //criando a pergunta devemos verificar onde ela vai ser posicionada
        if (_state.id == null) {
          referencia = uuid.Uuid().v4();
          //primeira pergunta do questionario
          final _perguntasRef = _firestore.collection(PerguntaModel.collection);
          final ultimaPerguntaRef = _perguntasRef
              .document(_state.questionarioInstance.ultimaPerguntaID);
          final ultimaPerguntaSnap = await ultimaPerguntaRef.get();

          if (_state.questionarioInstance.ultimaPerguntaID == null ||
              !ultimaPerguntaSnap.exists) {
            questionarioUltimaPerguntaID = ref.documentID;
            final primeiraPerguntaRef = _perguntasRef
                .document(_state.questionarioInstance.primeiraPerguntaID);
            final primeiraPerguntaSnap = await primeiraPerguntaRef.get();
            if (_state.questionarioInstance.primeiraPerguntaID == null ||
                !primeiraPerguntaSnap.exists) {
              _state.ordem = 0;
              questionarioPrimeiraPerguntaID = ref.documentID;
            } else {
              final primeiraPergunta =
                  PerguntaModel(id: primeiraPerguntaSnap.documentID)
                      .fromMap(primeiraPerguntaSnap.data);
              _state.ordem = primeiraPergunta.ordem + 1;
            }
          } else {
            final ultimaPergunta =
                PerguntaModel(id: ultimaPerguntaSnap.documentID)
                    .fromMap(ultimaPerguntaSnap.data);
            _state.ordem = ultimaPergunta.ordem + 1;
            ultimaPergunta.posterior = ref.documentID;
            _state.anterior = ultimaPergunta.id;
            ultimaPerguntaRef.setData(ultimaPergunta.toMap(), merge: true);
            questionarioUltimaPerguntaID = ref.documentID;
          }
        }

        questionarioRef.setData({
          if (questionarioPrimeiraPerguntaID != null)
            "primeiraPerguntaID": questionarioPrimeiraPerguntaID,
          if (questionarioUltimaPerguntaID != null)
            "ultimaPerguntaID": questionarioUltimaPerguntaID,
        }, merge: true);

        final instance = PerguntaModel(
          referencia: referencia,
          titulo: _state.titulo,
          textoMarkdown: _state.textoMarkdown,
          questionario: _state.questionario,
          tipo: _state.tipo,
          requisitos: _state.requisitos,
          escolhas: _state.escolhas,
          ordem: _state.ordem,
          anterior: _state.anterior,
          posterior: _state.posterior,
          dataEdicao: DateTime.now(),
        );
        if (_state.id == null) {
          instance.dataCriacao = DateTime.now();
        }
        final map = instance.toMap();
        map["requisitos"].addAll(_state.requisitosRemovidos);
        map["escolhas"].addAll(_state.escolhasRemovidas);
        ref.setData(map, merge: true);

        final snap = await ref.get();
        _state.id = snap.documentID;
        _state.instance = PerguntaModel(id: snap.documentID).fromMap(snap.data);
        _state.updateFromInstance();
      }
    }

    if (event is DeletarEditarApagarPerguntaBlocEvent) {
      String primeiraPerguntaID =
          _state.questionarioInstance.primeiraPerguntaID;
      String ultimaPerguntaID = _state.questionarioInstance.ultimaPerguntaID;
      final ref =
          _firestore.collection(PerguntaModel.collection).document(_state.id);
      final snap = await ref.get();
      final pergunta = PerguntaModel(id: snap.documentID).fromMap(snap.data);

      if (primeiraPerguntaID == _state.id) {
        primeiraPerguntaID = pergunta.posterior;
      }
      if (ultimaPerguntaID == _state.id) {
        ultimaPerguntaID = pergunta.anterior;
      }

      if (pergunta.anterior != null) {
        final perguntaAnteriorRef = _firestore
            .collection(PerguntaModel.collection)
            .document(pergunta.anterior);
        final perguntaAnteriorSnap = await perguntaAnteriorRef.get();
        if (perguntaAnteriorSnap.exists) {
          perguntaAnteriorRef.setData({"posterior":pergunta.posterior}, merge: true);
        }
      }

      if (pergunta.posterior != null) {
        final perguntaPosteriorRef = _firestore
            .collection(PerguntaModel.collection)
            .document(pergunta.posterior);
        final perguntaPosteriorSnap = await perguntaPosteriorRef.get();
        if (perguntaPosteriorSnap.exists) {
          perguntaPosteriorRef
              .setData({"anterior": pergunta.anterior}, merge: true);
        }
      }

      final questionarioRef = _firestore
          .collection(QuestionarioModel.collection)
          .document(_state.questionarioInstance.id);
      questionarioRef.setData({
        "primeiraPerguntaID": primeiraPerguntaID,
        "ultimaPerguntaID": ultimaPerguntaID,
      }, merge: true);

      ref.delete();
    }

    validate();

    if (!_outputController.isClosed) _outputController.add(_state);

  }
}
