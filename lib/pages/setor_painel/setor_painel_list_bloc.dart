import 'package:pmsbmibile3/models/eixo_model.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';

import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class SetorPainelListBlocEvent {}

class UpdateUsuarioIDEvent extends SetorPainelListBlocEvent {
  final UsuarioModel usuarioLogado;

  UpdateUsuarioIDEvent(this.usuarioLogado);
}

class UpdateSetorPainelIDEvent extends SetorPainelListBlocEvent {}

class UpdateProdutoListEvent extends SetorPainelListBlocEvent {}

class UpdateEixoListEvent extends SetorPainelListBlocEvent {}

class UpdateExpandeRetraiEixoMapEvent extends SetorPainelListBlocEvent {
  final String eixoID;

  UpdateExpandeRetraiEixoMapEvent(this.eixoID);
}

class EixoInfo {
  final EixoModel eixo;
  bool expandir=false;
  EixoInfo({this.eixo, this.expandir});
}

class SetorPainelInfo {
  final SetorCensitarioPainelModel setorPainel;
  bool destacarSeDestinadoAoUsuarioLogado = false;
  SetorPainelInfo({this.setorPainel, this.destacarSeDestinadoAoUsuarioLogado});
}

class SetorPainelListBlocState {
  UsuarioModel usuarioLogado;
  bool isDataValid = false;
  List<SetorCensitarioPainelModel> setorPainelList =
      List<SetorCensitarioPainelModel>();

  Map<String, ProdutoFunasaModel> produtoMap =
      Map<String, ProdutoFunasaModel>();

  Map<String, EixoInfo> eixoInfoMap = Map<String, EixoInfo>();

  Map<String, Map<String, List<SetorPainelInfo>>> setorPainelTreeProdutoEixo =
      Map<String, Map<String, List<SetorPainelInfo>>>();

  updateSetorPainelTreeProdutoEixo(
      List<SetorCensitarioPainelModel> painelList) {
    setorPainelTreeProdutoEixo.clear();
    String _produto;
    String _eixo;
    bool _destacarSeDestinadoAoUsuarioLogado;
    for (SetorCensitarioPainelModel painel in painelList) {
      if (painel?.produto?.id != null &&
          painel?.eixo?.id != null &&
          painel.produto.id.isNotEmpty &&
          painel.eixo.id.isNotEmpty) {
        _produto = painel.produto.id;
        _eixo = painel.eixo.id;
        _destacarSeDestinadoAoUsuarioLogado =
            painel?.usuarioQVaiResponder?.id == usuarioLogado?.id;
      } else {
        _produto = '*';
        _eixo = '*';
        _destacarSeDestinadoAoUsuarioLogado = false;
      }
      if (setorPainelTreeProdutoEixo[_produto] == null) {
        setorPainelTreeProdutoEixo[_produto] = {_eixo: []};
      }
      if (setorPainelTreeProdutoEixo[_produto][_eixo] == null) {
        setorPainelTreeProdutoEixo[_produto][_eixo] = [];
      }
      setorPainelTreeProdutoEixo[_produto][_eixo].add(SetorPainelInfo(
          setorPainel: painel,
          destacarSeDestinadoAoUsuarioLogado:
              _destacarSeDestinadoAoUsuarioLogado));
      // print('painelPorProdutoEixo: ${paneilSemDPE}');
    }
  }

  updateProdutoToMap(List<ProdutoFunasaModel> produtoList) {
    produtoMap.clear();
    for (var produto in produtoList) {
      produtoMap[produto.id] = produto;
    }
  }

  updateEixoToMap(List<EixoModel> eixoList) {
    eixoInfoMap.clear();
    for (var eixo in eixoList) {
      eixoInfoMap[eixo.id] = EixoInfo(eixo: eixo, expandir: false);
    }
  }
}

class SetorPainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<SetorPainelListBlocEvent>();
  Stream<SetorPainelListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final SetorPainelListBlocState _state = SetorPainelListBlocState();
  final _stateController = BehaviorSubject<SetorPainelListBlocState>();

  Stream<SetorPainelListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  SetorPainelListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioLogado) {
      eventSink(UpdateUsuarioIDEvent(usuarioLogado));
      eventSink(UpdateSetorPainelIDEvent());
      eventSink(UpdateProdutoListEvent());
      eventSink(UpdateEixoListEvent());
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = false;
    if (_state.setorPainelList != null) {
      _state.isDataValid = true;
    }
  }

  _mapEventToState(SetorPainelListBlocEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _state.usuarioLogado = event.usuarioLogado;
    }

    if (event is UpdateSetorPainelIDEvent) {
      _state.setorPainelList.clear();

      final streamDocsRemetente = _firestore
          .collection(SetorCensitarioPainelModel.collection)
          .where("setorCensitarioID.id",
              isEqualTo: _state.usuarioLogado.setorCensitarioID.id)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              SetorCensitarioPainelModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente
          .listen((List<SetorCensitarioPainelModel> setorPainelList) {
        if (setorPainelList.length > 1) {
          setorPainelList
              .sort((a, b) => a.painelID.nome.compareTo(b.painelID.nome));
        }
        _state.setorPainelList = setorPainelList;
        _state.updateSetorPainelTreeProdutoEixo(setorPainelList);

        if (!_stateController.isClosed) _stateController.add(_state);
        print(_state.setorPainelList.length);
      });
    }

    if (event is UpdateProdutoListEvent) {
      _state.produtoMap.clear();

      final streamDocsRemetente =
          _firestore.collection(ProdutoFunasaModel.collection).snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map(
              (doc) => ProdutoFunasaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ProdutoFunasaModel> produtoList) {
        if (produtoList.length > 1) {
          produtoList.sort((a, b) => a.id.compareTo(b.id));
        }
        _state.updateProdutoToMap(produtoList);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdateEixoListEvent) {
      _state.eixoInfoMap.clear();

      final streamDocsRemetente =
          _firestore.collection(EixoModel.collection).snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => EixoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<EixoModel> eixoList) {
        _state.updateEixoToMap(eixoList);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdateExpandeRetraiEixoMapEvent) {
      if(_state.eixoInfoMap[event.eixoID].expandir!=null)
      _state.eixoInfoMap[event.eixoID].expandir =
          !_state.eixoInfoMap[event.eixoID].expandir;
    }
    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em SetorPainelListBloc  = ${event.runtimeType}');
  }
}
