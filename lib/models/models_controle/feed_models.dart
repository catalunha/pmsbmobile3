import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';

enum FeedType {
  texto,
  url,
  imagem,
}

class FeedModel {
  UsuarioQuadroModel usuario;
  String dataPostagem;
  List<FeedElementModel> listaElements;

  FeedModel({this.usuario,this.dataPostagem}){
    this.listaElements = List<FeedElementModel>();
  }
}

class FeedElementModel {
  FeedType feedType;
  String valorFeed;

  FeedElementModel(

  );
}
