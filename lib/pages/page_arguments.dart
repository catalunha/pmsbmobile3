class PerguntaHomePageArguments {
  final String questionarioID;

  PerguntaHomePageArguments({this.questionarioID});
}

class EditarApagarPerguntaPageArguments {
  final String questionarioID;
  final String perguntaID;

  EditarApagarPerguntaPageArguments({this.questionarioID, this.perguntaID});
}

class EditarApagarEscolhaPageArguments {
  final bloc;
  final escolhaID;

  EditarApagarEscolhaPageArguments(this.bloc, this.escolhaID);
}

class PerguntaIDEscolhaIDPageArguments {
  final perguntaID;
  final escolhaUID;

  PerguntaIDEscolhaIDPageArguments(this.perguntaID, this.escolhaUID);
}

class DefinirRequisitosPageArguments {
  final bloc;
  final referencia;
  final String requisitoId;
  final String perguntaSelecionadaId;

  DefinirRequisitosPageArguments(this.bloc, this.referencia, this.requisitoId, this.perguntaSelecionadaId);
}

class AplicandoPerguntaPageArguments {
  final String questionarioID;
  final String perguntaID;

  AplicandoPerguntaPageArguments(this.questionarioID, {this.perguntaID});
}

class ChatPageArguments {
  final String chatID;
  final String modulo;
  final String titulo;

  ChatPageArguments({this.modulo, this.titulo, this.chatID});
}

class ControlePageArguments {
  final String tarefa;
  final String acao;
  final String acaoNome;

  ControlePageArguments({this.tarefa, this.acao,this.acaoNome});
}

class ItemRespostaPageCRUDArguments {
  final String item;
  final String resposta;

  ItemRespostaPageCRUDArguments({this.item, this.resposta});
}
