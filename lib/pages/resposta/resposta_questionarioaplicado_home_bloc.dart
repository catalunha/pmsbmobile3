import 'package:pmsbmibile3/models/google_drive_model.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class RespostaQuestionarioAplicadoHomeEvent {}

class QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent
    extends RespostaQuestionarioAplicadoHomeEvent {}

class UpdateUsuarioIDEvent extends RespostaQuestionarioAplicadoHomeEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class CreateRelatorioEvent extends RespostaQuestionarioAplicadoHomeEvent {
  final QuestionarioAplicadoModel questionarioID;

  CreateRelatorioEvent(this.questionarioID);
}

class RespostaQuestionarioAplicadoHomeState {
  UsuarioModel usuarioModel;
  List<QuestionarioAplicadoModel> questionariosAplicados;
}

class RespostaQuestionarioAplicadoHomeBloc {
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController =
      BehaviorSubject<RespostaQuestionarioAplicadoHomeEvent>();
  Stream<RespostaQuestionarioAplicadoHomeEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final RespostaQuestionarioAplicadoHomeState _state =
      RespostaQuestionarioAplicadoHomeState();
  final _stateController =
      BehaviorSubject<RespostaQuestionarioAplicadoHomeState>();
  Stream<RespostaQuestionarioAplicadoHomeState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // //ProdutoModel List
  // final _questionarioAplicadoListController =
  //     BehaviorSubject<List<QuestionarioAplicadoModel>>();
  // Stream<List<QuestionarioAplicadoModel>> get questionarioAplicadoListStream =>
  //     _questionarioAplicadoListController.stream;
  // Function get questionarioAplicadoListSink =>
  //     _questionarioAplicadoListController.sink.add;

  RespostaQuestionarioAplicadoHomeBloc(this._authBloc, this._firestore) {
    eventStream.listen(_mapEventToState);
    _authBloc.userId.listen((userId) {
      eventSink(UpdateUsuarioIDEvent(userId));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
    // await _questionarioAplicadoListController.drain();
    // _questionarioAplicadoListController.close();
  }

  void _mapEventToState(RespostaQuestionarioAplicadoHomeEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      final docRef = _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioID);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        final usuarioModel =
            UsuarioModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.usuarioModel = usuarioModel;
        if (!_stateController.isClosed) _stateController.add(_state);
      }

      // le todos os QuestionarioAplicado associados e ele, setor e eixo.
      final streamDocs = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .where("eixo.id", isEqualTo: _state.usuarioModel.eixoIDAtual.id)
          .where("setorCensitarioID.id",
              isEqualTo: _state.usuarioModel.setorCensitarioID.id)
          .snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) =>
              QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapList
          .listen((List<QuestionarioAplicadoModel> questionarioAplicadoList) {
        // print('>>> questionarioAplicadoList <<< ${questionarioAplicadoList.toString()}');
        // questionarioAplicadoListSink(questionarioAplicadoList);
        _state.questionariosAplicados = questionarioAplicadoList;
        // if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is CreateRelatorioEvent) {
      print(event.questionarioID.id);
      final docRef = _firestore
          .collection('HtmlDocxRelatorio')
          .document(event.questionarioID.id);
      final Map<String, dynamic> relatorio = new Map<String, dynamic>();
      relatorio['atualizada'] = false;
      relatorio['tipo'] = 'RespostaQuestionarioAplicado';
      relatorio['template'] = 'J8CfGBXBnbQSl7KZMv30';
      relatorio['collection'] = 'QuestionarioAplicado';
      relatorio['document'] = event.questionarioID.id;

      QuestionarioAplicadoModel questionarioAplicadoModel =
          event.questionarioID;
      Map<String, String> cabecalho = Map<String, String>();
      cabecalho['questionarioAplicadoModel.nome'] =
          questionarioAplicadoModel.nome;
      cabecalho['questionarioAplicadoModel.referencia'] =
          questionarioAplicadoModel.referencia;
      cabecalho['questionarioAplicadoModel.eixo.nome'] =
          questionarioAplicadoModel.eixo.nome;
      cabecalho['questionarioAplicadoModel.setorCensitarioID.nome'] =
          questionarioAplicadoModel.setorCensitarioID.nome;
      cabecalho['questionarioAplicadoModel.aplicador.nome'] =
          questionarioAplicadoModel.aplicador.nome;
      // cabecalho['questionarioAplicadoModel.aplicado']=questionarioAplicadoModel.aplicado;
      relatorio['questionarioAplicadoModel'] = cabecalho;

      final perguntasRef = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("questionario.id", isEqualTo: questionarioAplicadoModel.id)
          .orderBy("ordem", descending: false);

      final fsw.QuerySnapshot perguntasSnapshot =
          await perguntasRef.getDocuments();
      final perguntasList =
          perguntasSnapshot.documents.map((fsw.DocumentSnapshot doc) {
        return PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data);
      }).toList();

      List<Map<String, dynamic>> perguntaAplicadaList =
          List<Map<String, dynamic>>();

      int contador = 1;
      for (var pergunta in perguntasList) {
        Map<String, dynamic> perguntaAplicada = Map<String, dynamic>();

        perguntaAplicada['pergunta.numero'] = contador++;
        perguntaAplicada['pergunta.titulo'] = pergunta.titulo;
        perguntaAplicada['pergunta.textoMarkdown'] = pergunta.textoMarkdown;
        perguntaAplicada['pergunta.observacao'] = pergunta.observacao;
        perguntaAplicada['pergunta.tipo.nome'] = pergunta.tipo.nome;

        perguntaAplicada['pergunta.id'] = pergunta.id;
        perguntaAplicada['pergunta.temPendencias'] =
            pergunta.temPendencias ? "Tem pendências" : "Não tem pendências";
        perguntaAplicada['pergunta.foiRespondida'] =
            pergunta.foiRespondida ? "Foi respondida" : "Não foi respondida";
        perguntaAplicada['pergunta.temRespostaValida'] =
            pergunta.temRespostaValida ? "Tem informação válida" : "";

        //+++ texto
        if (pergunta.tipo.id == 'texto') {
          if (pergunta.texto != null) {
            perguntaAplicada['pergunta.texto'] = pergunta.texto;
          } else {
            perguntaAplicada['pergunta.texto'] = 'Nada informado.';
          }
        }
        //--- texto
        //+++ numero
        if (pergunta.tipo.id == 'numero') {
          if (pergunta.numero != null) {
            perguntaAplicada['pergunta.numero'] = pergunta.numero.toString();
          } else {
            perguntaAplicada['pergunta.numero'] = 'Nada informado.';
          }
        }
        //--- numero
        //+++ imagem
        if (pergunta.tipo.id == 'imagem') {
          if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
            // Map<String, String> anexo = Map<String, String>();
            for (var item in pergunta.arquivo.entries) {
              // anexo[item.key]=item.value.url;
              perguntaAplicada['pergunta.imagem'][item.key] = item.value.url;
            }
            // perguntaAplicada['pergunta.imagem']=anexo;

          } else {
            perguntaAplicada['pergunta.imagem'] = 'Nada informado.';
          }
        }
        //--- imagem
        //+++ arquivo
        if (pergunta.tipo.id == 'arquivo') {
          if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
            // Map<String, String> anexo = Map<String, String>();
            for (var item in pergunta.arquivo.entries) {
              // anexo[item.key]=item.value.url;
              perguntaAplicada['pergunta.arquivo'][item.key] = item.value.url;
            }
            // perguntaAplicada['pergunta.arquivo']=anexo;

          } else {
            perguntaAplicada['pergunta.arquivo'] = 'Nada informado.';
          }
        }
        //--- arquivo
        //+++ coordenada
        if (pergunta.tipo.id == 'coordenada') {
          if (pergunta.coordenada != null && pergunta.coordenada.isNotEmpty) {
            int coord = 1;
            for (var item in pergunta.coordenada) {
              perguntaAplicada['pergunta.arquivo'][coord++] =
                  '(${item.latitude},${item.longitude})';
            }
          } else {
            perguntaAplicada['pergunta.coordenada'] = 'Nada informado.';
          }
        }
        //--- coordenada
        //+++ escolhas
        if (pergunta.tipo.id == 'escolhaunica' ||
            pergunta.tipo.id == 'escolhamultipla') {
          if (pergunta.escolhas != null && pergunta.escolhas.isNotEmpty) {
            var dicEscolhas = Dictionary.fromMap(pergunta.escolhas);
            var escolhasAscOrder = dicEscolhas
                // Sort Ascending order by value ordem
                .orderBy((kv) => kv.value.ordem)
                // Sort Descending order by value ordem
                // .orderByDescending((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            print(escolhasAscOrder.toMap());
            Map<String, Escolha> escolhaMap = escolhasAscOrder.toMap();

            for (var item in escolhaMap.entries) {
              if(item?.key != null){
              String marcada = item.value.marcada ? 'X' : '';
              perguntaAplicada['pergunta.escolha'][item.key] =
                  '[${marcada}] ${item.value.texto}';
              }
            }
          } else {
            perguntaAplicada['pergunta.escolha'] = 'Nada informado.';
          }
        }
        //--- escolhas
        perguntaAplicadaList.add(perguntaAplicada);
      }
      relatorio['perguntaAplicadaList'] = perguntaAplicadaList;

      await docRef.setData(relatorio, merge: true);
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em RespostaQuestionarioAplicadoHomeBloc  = ${event.runtimeType}');
  }
}
