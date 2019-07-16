import 'package:pmsbmibile3/models/base_model.dart';

enum TipoPergunta {UnicaEscolha, MultiplaEscolha, Texto, Numero, Arquivo, Imagem, Coordenada }

/// documento dentro da subcollection Questionario/{id}/Pergunta
abstract class Pergunta extends FirestoreModel{
  static final String collection = "Pergunta";
  String variavel;
  int ordem;
  DateTime dataCriacao;
  DateTime dataEdicao;
  String texto;
  TipoPergunta tipo;

  Pergunta({
    String id,
    this.variavel,
    this.ordem,
    this.dataCriacao,
    this.dataEdicao,
    this.tipo,
  }): super(id);
}

class Coordenada{
  Coordenada({this.lat, this.long});
  num lat;
  num long;
}

/*
class PerguntaUnicaEscolha extends Pergunta{
  List<String> listaPossivelEscolha;
  String escolha;
}

class PerguntaMultiplaEscolha extends Pergunta{
  List<String> listaPossivelEscolha;
  List<String> listaEscolha;
}

class PerguntaText extends Pergunta{
  String texto;
}

class PerguntaNumero extends Pergunta{
  num numerpInicial;
  num numeroFinal;
  String unidade;
  num numero;
}

class PerguntaArquivo extends Pergunta{
  String arquivoId;
  String arquivoUrl; // campo duplicado
}

class PerguntaImagem extends Pergunta{
  String imagemId;
  String imagemUrl; // campo duplicado
}
class Coordenada{
  num lat;
  num long;
}
class PerguntaCoordenada extends Pergunta{
  List<Coordenada> listaCoordenada; // campo duplicado
}
*/