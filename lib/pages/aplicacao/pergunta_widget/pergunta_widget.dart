export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_texto.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_numero.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_unica.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_multipla.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_imagem_arquivo.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_coordenada.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_texto.dart';

class MapaPerguntasWidget {

  MapaPerguntasWidget();

  Map<String, dynamic> _mapaPerguntasTipo = {
    "texto": _widgetTipoTexto,
    "imagem": _widgetTipoImagem,
    "arquivo": _widgetTipoArquivo,
    "numero": _widgetTipoNumero,
    "coordenada": _widgetTipoCoordenada,
    "escolha_unica": _wigetTipoPerguntaUnica,
    "escolha_multipla": _wigetTipoPerguntaMultipla
  };

  getWigetPergunta({@required String tipo, dynamic entrada}){
    return _mapaPerguntasTipo[tipo](entrada:entrada);
  }

  static _wigetTipoPerguntaUnica({@required entrada}) {
    return new PerguntaEscolhaUnicaWidget(listaOpcoes: entrada);
  }

  static _wigetTipoPerguntaMultipla({@required entrada}) {
    return new PerguntaEscolhaMultiplaWidget(entrada: entrada);
  }

  static _widgetTipoCoordenada({entrada}) {
    return new PerguntaWigdetCoordenada();
  }

  static _widgetTipoImagem({entrada}) {
    return new PerguntaWigdetImagemArquivo();
  }

  static _widgetTipoArquivo({entrada}) {
    return new PerguntaWigdetImagemArquivo();
  }

  static _widgetTipoTexto({entrada}) {
    return perguntaTipoTexto();
  }

  static _widgetTipoNumero({entrada}) {
    return perguntaTipoNumero();
  }

}
