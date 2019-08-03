import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_texto.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_numero.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_escolha_unica.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_escolha_multipla.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_imagem_arquivo.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_coordenada.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';

class PerguntaAplicada extends StatelessWidget {
  PerguntaAplicada(this.perguntaAplicada, {Key key})
      : assert(perguntaAplicada != null),
        super(key: key);
  final PerguntaAplicadaModel perguntaAplicada;

  @override
  Widget build(BuildContext context) {
    final tipo = PerguntaTipoModel.ENUM[perguntaAplicada.tipo.id];

    Widget returnWidget;

    switch (tipo) {
      case PerguntaTipoEnum.Texto:
        returnWidget = PerguntaTexto(perguntaAplicada);
        break;
      case PerguntaTipoEnum.Imagem:
      case PerguntaTipoEnum.Arquivo:
        returnWidget = PerguntaWigdetImagemArquivo(perguntaAplicada);
        break;
      case PerguntaTipoEnum.Numero:
        returnWidget = PerguntaNumero(perguntaAplicada);
        break;
      case PerguntaTipoEnum.Coordenada:
        returnWidget = PerguntaCoordenada(perguntaAplicada);
        break;
      case PerguntaTipoEnum.EscolhaUnica:
        returnWidget = PerguntaEscolhaUnica(perguntaAplicada);
        break;
      case PerguntaTipoEnum.EscolhaMultipla:
        returnWidget = PerguntaEscolhaMultipla(perguntaAplicada);
        break;
    }
    return returnWidget;
  }
}
