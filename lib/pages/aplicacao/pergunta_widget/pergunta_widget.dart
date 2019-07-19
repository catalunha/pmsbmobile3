export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_texto.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_numero.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_unica.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_multipla.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_imagem_arquivo.dart';
export 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_coordenada.dart';

import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget.dart';
import 'package:flutter/material.dart';

class MapaPerguntasWidget {

  MapaPerguntasWidget();

  Map<TipoPergunta, dynamic> _mapaPerguntasTipo = {
    TipoPergunta.Texto: _widgetTipoTexto,
    TipoPergunta.Imagem: _widgetTipoImagem,
    TipoPergunta.Arquivo: _widgetTipoArquivo,
    TipoPergunta.Numero: _widgetTipoNumero,
    TipoPergunta.Coordenada: _widgetTipoCoordenada,
    TipoPergunta.UnicaEscolha: _wigetTipoPerguntaUnica,
    TipoPergunta.MultiplaEscolha: _wigetTipoPerguntaMultipla
  };

  getWigetPergunta({@required TipoPergunta tipo, dynamic entrada}){
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
    return new PerguntaWigdetImagemArquivo(arquivoTipo: ArquivoTipo.image,);
  }

  static _widgetTipoArquivo({entrada}) {
    return new PerguntaWigdetImagemArquivo(arquivoTipo: ArquivoTipo.aplication);
  }

  static _widgetTipoTexto({entrada}) {
    return PerguntaTipoTextoWidget();
  }

  static _widgetTipoNumero({entrada}) {
    return PerguntaTipoNumeroWidget();
  }

}
