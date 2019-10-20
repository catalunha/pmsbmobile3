import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class PainelListBlocEvent {}

class UpdateUsuarioIDEvent extends PainelListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdatePainelListEvent extends PainelListBlocEvent {}

class UpdateProdutoListEvent extends PainelListBlocEvent {}

class UpdateEixoListEvent extends PainelListBlocEvent {}

class UpdateExpandeRetraiEixoMapEvent extends PainelListBlocEvent {
  final String eixoID;

  UpdateExpandeRetraiEixoMapEvent(this.eixoID);
}

class EixoInfo {
  final EixoModel eixo;
  bool expandir;
  EixoInfo({this.eixo, this.expandir});
}

class PainelInfo {
  final PainelModel painel;
  bool destacarSeDestinadoAoUsuarioLogado = false;
  PainelInfo({this.painel, this.destacarSeDestinadoAoUsuarioLogado});
}

class PainelListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioLogado;

  List<PainelModel> painelList = List<PainelModel>();

  Map<String, ProdutoFunasaModel> produtoMap =
      Map<String, ProdutoFunasaModel>();

  Map<String, EixoInfo> eixoInfoMap = Map<String, EixoInfo>();

  Map<String, Map<String, List<PainelInfo>>> painelTreeProdutoEixo =
      Map<String, Map<String, List<PainelInfo>>>();

  updateProdutoEixoMap(List<PainelModel> painelList) {
    painelTreeProdutoEixo.clear();
    String _produto;
    String _eixo;
    bool _destacarSeDestinadoAoUsuarioLogado;
    for (PainelModel painel in painelList) {
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
      if (painelTreeProdutoEixo[_produto] == null) {
        painelTreeProdutoEixo[_produto] = {_eixo: []};
      }
      if (painelTreeProdutoEixo[_produto][_eixo] == null) {
        painelTreeProdutoEixo[_produto][_eixo] = [];
      }
      painelTreeProdutoEixo[_produto][_eixo].add(PainelInfo(
          painel: painel,
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

class PainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<PainelListBlocEvent>();
  Stream<PainelListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PainelListBlocState _state = PainelListBlocState();
  final _stateController = BehaviorSubject<PainelListBlocState>();

  Stream<PainelListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PainelListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateUsuarioIDEvent(usuarioID));
    });
    eventSink(UpdatePainelListEvent());
    eventSink(UpdateProdutoListEvent());
    eventSink(UpdateEixoListEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = false;
    if (_state.painelList != null) {
      _state.isDataValid = true;
    }
    if (_state.produtoMap != null) {
      _state.isDataValid = true;
    }
    if (_state.eixoInfoMap != null) {
      _state.isDataValid = true;
    }
    if (_state.painelTreeProdutoEixo != null) {
      _state.isDataValid = true;
    }

  }

  _mapEventToState(PainelListBlocEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _state.usuarioLogado = event.usuarioID;
    }
    if (event is UpdatePainelListEvent) {
      _state.painelList.clear();

      final streamDocsRemetente =
          _firestore.collection(PainelModel.collection).snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => PainelModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<PainelModel> painelList) {
        if (painelList.length > 1) {
          painelList.sort((a, b) => a.nome.compareTo(b.nome));
        }
        // _state.painelList = painelList;
        _state.updateProdutoEixoMap(painelList);
        if (!_stateController.isClosed) _stateController.add(_state);
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
      _state.eixoInfoMap[event.eixoID].expandir =
          !_state.eixoInfoMap[event.eixoID].expandir;
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelListBloc  = ${event.runtimeType}');
  }
}

/*
A: {
  adm:[
    painelInfo1,
    painelInfo2,
  ]
  rs:[
    painelInfo1,
    painelInfo2,
  ]
},
A: {
  adm:[
    painelInfo1,
    painelInfo2,
  ],
  aa:[
    painelInfo1,
    painelInfo2,
  ]
}
*/
