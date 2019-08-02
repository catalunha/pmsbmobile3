import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_crud_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_list_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_preview_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_escolha_marcar_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'package:pmsbmibile3/api/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);
    return 
        MaterialApp(
          title: 'PMSB-TO-22',
          //theme: ThemeData.dark(),
          initialRoute: "/",
          routes: {
            //homePage
            "/": (context) => HomePage(authBloc),

            //Desenvolvimento
            "/desenvolvimento": (context) => Desenvolvimento(),

            //upload
            "/upload": (context) => UploadPage(authBloc),

            //perfil
            "/perfil": (context) => PerfilPage(),
            "/perfil/configuracao": (context) => ConfiguracaoPage(authBloc),
            "/perfil/crudtext": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerfilCRUDPage(settings.arguments);
            },
            "/perfil/crudarq": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerfilCRUDArqPage(settings.arguments);
            },

            //questionario
            "/questionario/home": (context) => QuestionarioHomePage(authBloc),
            "/questionario/home": (context) => QuestionarioHomePage(),
            "/questionario/form": (context) => QuestionarioFormPage(
                  authBloc,
                  ModalRoute.of(context).settings.arguments,
                ),

            //pergunta
            "/pergunta/home": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerguntaHomePage(settings.arguments);
            },
            "/pergunta/criar_pergunta": (context) => CriarPerguntaTipoPage(),
            "/pergunta/criar_editar": (context) {
              final settings = ModalRoute.of(context).settings;
              final EditarApagarPerguntaPageArguments args = settings.arguments;
              return EditarApagarPerguntaPage(
                questionarioID: args.questionarioID,
                perguntaID: args.perguntaID,
              );
            },
            "/pergunta/escolha_list": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerguntaEscolhaListPage(settings.arguments);
            },
            "/pergunta/escolha_crud": (context) {
              final settings = ModalRoute.of(context).settings;
              final PerguntaIDEscolhaIDPageArguments args = settings.arguments;
              return PerguntaEscolhaCRUDPage(args.perguntaID, args.escolhaUID);
            },
            "/pergunta/pergunta_preview": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerguntaPreviewPage(perguntaID: settings.arguments);
            },
            "/pergunta/pergunta_requisito_marcar": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerguntaRequisitoEscolhaMarcarPage(
                  perguntaID: settings.arguments);
            },
            "/pergunta/pergunta_requisito": (context) {
              final settings = ModalRoute.of(context).settings;
              return PerguntaRequisitoPage(
                  perguntaID: settings.arguments);
            },

            //aplicacao
            "/aplicacao/home": (context) => AplicacaoHomePage(authBloc),
            "/aplicacao/momento_aplicacao": (context) {
              final settings = ModalRoute.of(context).settings;
              return MomentoAplicacaoPage(
                authBloc,
                questionarioAplicadoID: settings.arguments,
              );
            },
            "/aplicacao/selecionar_questionario": (context) {
              final args = ModalRoute.of(context).settings.arguments;
              return AplicacaoSelecionarQuestionarioPage(args);
            },
            "/aplicacao/aplicando_pergunta": (context) {
              final args = ModalRoute.of(context).settings.arguments;
              return AplicacaoPerguntaPage(args);
            },
            "/aplicacao/pendencias": (context) {
              final args = ModalRoute.of(context).settings.arguments;
              return PendenciasPage(args);
            },
            "/aplicacao/visualizar_respostas": (context) =>
                VisualizarRespostasPage(),
            "/aplicacao/definir_requisitos": (context) {
              final DefinirRequisitosPageArguments args =
                  ModalRoute.of(context).settings.arguments;
              return DefinirRequisistosPage(args.bloc, args.referencia);
            },

            //resposta
            "/resposta/home": (context) => RespostaHomePage(),
            "/resposta/resposta_questionario": (context) =>
                RespostaQuestionarioPage(),
            "/resposta/questionario_resposta": (context) =>
                QuestionarioRespostaPage(),

            //sintese
            "/sintese/home": (context) => SinteseHomePage(),

            //produto
            "/produto/home": (context) => ProdutoHomePage(authBloc),
            "/produto/crud": (context) {
              final settings = ModalRoute.of(context).settings;
              return ProdutoCRUDPage(settings.arguments, authBloc);
            },
            "/produto/texto": (context) {
              final settings = ModalRoute.of(context).settings;
              return ProdutoTextoPage(
                settings.arguments,
              );
            },
            "/produto/arquivo_list": (context) {
              final settings = ModalRoute.of(context).settings;
              ProdutoArguments args = settings.arguments;
              return ProdutoArquivoListPage(
                  produtoID: args.produtoID, tipo: args.tipo);
            },
            "/produto/arquivo_crud": (context) {
              final settings = ModalRoute.of(context).settings;
              ProdutoArguments args = settings.arguments;
              return ProdutoArquivoCRUDPage(
                  produtoID: args.produtoID,
                  arquivoID: args.arquivoID,
                  tipo: args.tipo);
            },

            //comunicacao
            "/comunicacao/home": (context) => ComunicacaoHomePage(),
            "/noticias/noticias_visualizadas": (context) => NoticiaLidaPage(),
            "/comunicacao/crud_page": (context) => ComunicacaoCRUDPage(),

            //administração
            "/administracao/home": (context) => AdministracaoHomePage(),
            "/administracao/perfil": (context) => AdministracaoPerfilPage(),

            //controle
            "/controle/home": (context) => ControleHomePage(),
          },
      //   ),
      // ),
    );
  }
}
