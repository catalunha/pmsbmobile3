import 'package:flutter/material.dart' show Widget, Container;
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_texto.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_numero.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_unica.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_multipla.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_imagem_arquivo.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_coordenada.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page_bloc.dart'
    show AplicandoPerguntaPageBloc;

class MapaPerguntasWidget {
  static Widget getWigetPergunta(AplicandoPerguntaPageBloc bloc,
      PerguntaTipoEnum tipo, PerguntaAplicadaModel pergunta) {
    assert(tipo != null);
    switch (tipo) {
      case PerguntaTipoEnum.Texto:
        return PerguntaTipoTextoWidget();
        break;
      case PerguntaTipoEnum.Imagem:
        return PerguntaWigdetImagemArquivo(
          arquivoTipo: ArquivoTipo.image,
        );
        break;
      case PerguntaTipoEnum.Arquivo:
        return PerguntaWigdetImagemArquivo(arquivoTipo: ArquivoTipo.aplication);
        break;
      case PerguntaTipoEnum.Numero:
        return PerguntaTipoNumeroWidget();
        break;
      case PerguntaTipoEnum.Coordenada:
        return PerguntaWigdetCoordenada();
        break;
      case PerguntaTipoEnum.EscolhaUnica:
        return PerguntaEscolhaUnicaWidget(pergunta);
        break;
      case PerguntaTipoEnum.EscolhaMultipla:
        return PerguntaEscolhaMultiplaWidget(pergunta);
        break;
    }
  }
}
