import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';

import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class PainelListBlocEvent {}

class UpdateUsuarioIDEvent extends PainelListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdatePainelListEvent extends PainelListBlocEvent {}

class UpdateProdutoEvent extends PainelListBlocEvent {}

class UpdateEixoMapEvent extends PainelListBlocEvent {}

class UpdateExpandeRetraiEixoMapEvent extends PainelListBlocEvent {
  final String eixoID;

  UpdateExpandeRetraiEixoMapEvent(this.eixoID);
}

class EixoMap {
  final EixoModel eixo;
  bool expandir;
  EixoMap({this.eixo, this.expandir});
}

class PainelInfo {
  final PainelModel painel;
  bool destacar = false;
  PainelInfo({this.painel, this.destacar});
}

class PainelListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioID;

  List<PainelModel> painelList = List<PainelModel>();
  Map<String, List<PainelInfo>> paneilSemDPE = Map<String, List<PainelInfo>>();

  Map<String, ProdutoFunasaModel> produtoMap =
      Map<String, ProdutoFunasaModel>();

  Map<String, EixoMap> eixoMap = Map<String, EixoMap>();

  Map<String, Map<String, List<PainelInfo>>> painelPorProdutoEixo =
      Map<String, Map<String, List<PainelInfo>>>();

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

  updateProdutoEixoMap() {
    painelPorProdutoEixo.clear();
    paneilSemDPE.clear();
    paneilSemDPE["*"] = [];

    for (PainelModel painel in painelList) {
      if (painel?.produto?.id != null &&
          painel?.eixo?.id != null &&
          painel.produto.id.isNotEmpty &&
          painel.eixo.id.isNotEmpty) {
        // print('painel: ${painel.produto.id} | ${painel.eixo.id}| ${painel.nome}');
        if (painelPorProdutoEixo[painel.produto.id] == null) {
          painelPorProdutoEixo[painel.produto.id] = {painel.eixo.id: []};
        }
        if (painelPorProdutoEixo[painel.produto.id][painel.eixo.id] == null) {
          painelPorProdutoEixo[painel.produto.id][painel.eixo.id] = [];
        }
        painelPorProdutoEixo[painel.produto.id][painel.eixo.id].add(PainelInfo(
            painel: painel,
            destacar: painel?.usuarioQVaiResponder?.id == usuarioID?.id));
        // print('painelPorProdutoEixo: ${painelPorProdutoEixo}');
      } else {
        if (painel.eixo == null || painel.produto == null)
          paneilSemDPE["*"].add(PainelInfo(painel: painel, destacar: false));
        // print('painel: ${painel.id}');
      }
      // print('painelPorProdutoEixo: ${paneilSemDPE}');
    }
  }

  // updateProdutoMap() {
  //   painelMapList.clear();
  //   for (var painel in painelList) {
  //     if (painel?.produto?.id != null) {
  //       if (painelMapList[painel.produto.id] == null)
  //         painelMapList[painel.produto.id] = [];

  //       painelMapList[painel.produto.id].add(painel);
  //     }
  //   }
  // }

  updateProdutoToMap(List<ProdutoFunasaModel> produtoList) {
    produtoMap.clear();
    for (var produto in produtoList) {
      produtoMap[produto.id] = produto;
    }
  }

  updateEixoToMap(List<EixoModel> eixoList) {
    eixoMap.clear();
    for (var eixo in eixoList) {
      eixoMap[eixo.id] = EixoMap(eixo: eixo, expandir: false);
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
    eventSink(UpdateProdutoEvent());
    eventSink(UpdateEixoMapEvent());
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
    if (_state.eixoMap != null) {
      _state.isDataValid = true;
    }
    if (_state.painelPorProdutoEixo != null) {
      _state.isDataValid = true;
    }
    if (_state.paneilSemDPE != null) {
      _state.isDataValid = true;
    }
  }

  _mapEventToState(PainelListBlocEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
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
        _state.painelList = painelList;
        _state.updateProdutoEixoMap();
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdateProdutoEvent) {
      _state.produtoMap.clear();

      final streamDocsRemetente =
          _firestore.collection(ProdutoFunasaModel.collection).snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map(
              (doc) => ProdutoFunasaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ProdutoFunasaModel> produtoList) {
        _state.updateProdutoToMap(produtoList);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdateEixoMapEvent) {
      _state.eixoMap.clear();

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
      _state.eixoMap[event.eixoID].expandir =
          !_state.eixoMap[event.eixoID].expandir;
      if (!_stateController.isClosed) _stateController.add(_state);
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelListBloc  = ${event.runtimeType}');
  }
}
