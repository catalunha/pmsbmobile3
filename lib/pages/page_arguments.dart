class PerguntaHomePageArguments{
  final String questionarioID;
  PerguntaHomePageArguments({this.questionarioID});
}

class EditarApagarPerguntaPageArguments {
  final String questionarioID;
  final String perguntaID;

  EditarApagarPerguntaPageArguments({this.questionarioID, this.perguntaID});
}

class EditarApagarEscolhaPageArguments{
  final bloc;
  final escolhaID;
  EditarApagarEscolhaPageArguments(this.bloc, this.escolhaID);
}