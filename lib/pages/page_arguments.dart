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

  DefinirRequisitosPageArguments(this.bloc, this.referencia);
}

class AplicandoPerguntaPageArguments {
  final String questionarioID;
  final String perguntaID;

  AplicandoPerguntaPageArguments(this.questionarioID, this.perguntaID);
}
