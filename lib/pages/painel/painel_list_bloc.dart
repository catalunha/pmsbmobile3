import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';

import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';
import 'dart:convert'; 
class PainelListBlocEvent {}

class UpdatePainelListEvent extends PainelListBlocEvent {}

class UpdateProdutoEvent extends PainelListBlocEvent {}

class PainelListBlocState {
  bool isDataValid = false;

  List<PainelModel> painelList = List<PainelModel>();
  Map<String, List<PainelModel>> painelMapList =
      Map<String, List<PainelModel>>();
  Map<String, ProdutoFunasaModel> produtoMap =
      Map<String, ProdutoFunasaModel>();

  Map<String, Map<String, List<PainelModel>>> painelPorProdutoEixo =
      Map<String, Map<String, List<PainelModel>>>();



// class Painel{
//   String produto;
//   String eixo;
//   String item;
//   Painel(this.produto,this.eixo,this.item);
// }
// void main() {
//   Map<String,Map<String, List<Painel>>> map = Map<String,Map<String, List<Painel>>>();
//   List<Painel> painelList = List<Painel>();
//   painelList.add(Painel('a','adm','item1'));
//   painelList.add(Painel('a','adm','item2'));
//   painelList.add(Painel('b','adm','item1'));
//   map.clear();
//   for(Painel painel in painelList){
//     if(map[painel.produto]==null){
//       map[painel.produto]={painel.eixo:[]};
//     }
//     map[painel.produto][painel.eixo].add(painel);  
    
    
//   }
// print(map);
// }

  updateProdutoEixoMap() {
    painelPorProdutoEixo.clear();
    for (PainelModel painel in painelList) {
      if (painel?.produto?.id != null && painel?.eixo?.id != null) {
        print('painel: ${painel}');
        if (painelPorProdutoEixo[painel.produto.id] == null || painelPorProdutoEixo[painel.produto.id][painel.eixo.id] == null){
          painelPorProdutoEixo[painel.produto.id]={painel.eixo.id:[]};
        }else{
                  print(
            'painelPorProdutoEixo0: ${painelPorProdutoEixo[painel.produto.id]}');

        }
        print(
            'painelPorProdutoEixo1: ${painelPorProdutoEixo[painel.produto.id][painel.eixo.id]}');

        painelPorProdutoEixo[painel.produto.id][painel.eixo.id].add(painel);
                print(
            'painelPorProdutoEixo2: ${painelPorProdutoEixo}');
      }
    }
  }

  updateProdutoMap() {
    painelMapList.clear();
    for (var painel in painelList) {
      if (painel?.produto?.id != null) {
        if (painelMapList[painel.produto.id] == null)
          painelMapList[painel.produto.id] = [];

        painelMapList[painel.produto.id].add(painel);
      }
    }
  }

  updateProdutoToMap(List<ProdutoFunasaModel> produtoList) {
    produtoMap.clear();
    for (var produto in produtoList) {
      produtoMap[produto.id] = produto;
    }
  }
}

class PainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;

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
  PainelListBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
    eventSink(UpdatePainelListEvent());
    eventSink(UpdateProdutoEvent());
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
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(PainelListBlocEvent event) async {
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
        _state.updateProdutoMap();
        _state.updateProdutoEixoMap();
        print('painelPorProdutoEixo: ${_state.painelPorProdutoEixo}');
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
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelListBloc  = ${event.runtimeType}');
  }
}
