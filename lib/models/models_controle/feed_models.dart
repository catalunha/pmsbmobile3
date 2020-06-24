import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';

enum FeedType {
  texto,
  url,
  historico,
}

class FeedModel {
  UsuarioQuadroModel usuario;
  String dataPostagem;
  FeedType feedType;
  String valorFeed;

  FeedModel({this.usuario, this.dataPostagem, this.feedType, this.valorFeed});
}
