import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_texto.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_numero.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_unica.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_multipla.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_imagem_arquivo.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_coordenada.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page_bloc.dart';

Widget getWigetPergunta(AplicandoPerguntaPageBloc bloc, PerguntaTipoEnum tipo,
    PerguntaAplicadaModel pergunta) {
  assert(tipo != null);

  return StreamBuilder<AplicandoPerguntaPageBlocState>(
    stream: bloc.state,
    builder: (context, snapshot) {
      Widget returnWidget;

      if (!snapshot.hasData)
        return Center(
          child: Text("SEM DADOS"),
        );

      switch (tipo) {
        case PerguntaTipoEnum.Texto:
          returnWidget = PerguntaTipoTextoWidget(
            perguntaAplicadaID: snapshot.data.perguntaAtual.id,
            initialize: () {
              if (snapshot.data.perguntaAtual.texto == null) return false;
              return snapshot.data.perguntaAtual.texto.isNotEmpty;
            },
            initialValue: snapshot.data.perguntaAtual.texto,
            updateText: (text) {
              bloc.dispatch(
                  UpdateTextoRespostaAplicandoPerguntaPageBlocEvent(text));
            },
          );
          break;
        case PerguntaTipoEnum.Imagem:
          returnWidget = PerguntaWigdetImagemArquivo(
            arquivoTipo: ArquivoTipo.image,
          );
          break;
        case PerguntaTipoEnum.Arquivo:
          returnWidget = PerguntaWigdetImagemArquivo(
            arquivoTipo: ArquivoTipo.aplication,
          );
          break;
        case PerguntaTipoEnum.Numero:
          returnWidget = PerguntaTipoNumeroWidget(
              perguntaAplicadaID: snapshot.data.perguntaAtual.id,
              initialize: () {
                if (snapshot.data.perguntaAtual.numero == null) return false;
                return true;
              },
              initialValue: snapshot.data.perguntaAtual.numero.toString(),
              onChanged: (text) {
                bloc.dispatch(
                    UpdateNumeroRespostaAplicandoPerguntaPageBlocEvent(text));
              });
          break;
        case PerguntaTipoEnum.Coordenada:
          returnWidget = PerguntaWigdetCoordenada();
          break;
        case PerguntaTipoEnum.EscolhaUnica:
          returnWidget = PerguntaEscolhaUnicaWidget(pergunta);
          break;
        case PerguntaTipoEnum.EscolhaMultipla:
          returnWidget = PerguntaEscolhaMultiplaWidget(pergunta);
          break;
      }
      return returnWidget;
    },
  );
}
