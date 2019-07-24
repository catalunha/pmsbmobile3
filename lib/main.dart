import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_lida_page.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crud_page.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crudarq_page.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'package:pmsbmibile3/api/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore),
      child: Provider<DatabaseService>.value(
        value: DatabaseService(),
        child: MaterialApp(
          title: 'PMSB',
          //theme: ThemeData.dark(),
          initialRoute: "/",
          routes: {
            "/": (context) => HomePage(),
            //Desenvolvimento
            "/desenvolvimento": (context) => Desenvolvimento(),

            //Upload
            "/upload": (context) => UploadPage(),

            //perfil
            "/perfil": (context) => PerfilPage(),
            "/perfil/crudtext": (context) => PerfilCRUDPage(),
            "/perfil/crudarq": (context) => PerfilCRUDArqPage(),
            "/perfil/configuracao": (context) => ConfiguracaoPage(),

            //questionario
            "/questionario/home": (context) => QuestionarioHomePage(),
            "/questionario/form": (context) => QuestionarioFormPage(),

            //pergunta
            "/pergunta/home": (context) => PerguntaHomePage(),
            "/pergunta/criar_pergunta": (context) => CriarPerguntaTipoPage(),
            "/pergunta/criar_editar": (context) => EditarApagarPerguntaPage(),
            "/pergunta/selecionar_requisito": (context) =>
                SelecionarQuequisitoPerguntaPage(),
            "/pergunta/criar_ordenar_escolha": (context) =>
                CriarOrdenarEscolha(),
            "/pergunta/editar_apagar_escolha": (context) =>
                EditarApagarEscolhaPage(),

            //aplicacao
            "/aplicacao/home": (context) => AplicacaoHomePage(),
            "/aplicacao/momento_aplicacao": (context) => MomentoAplicacaoPage(),
            "/aplicacao/aplicando_pergunta": (context) =>
                AplicacaoPerguntaPage(),
            "/aplicacao/pendencias": (context) => PendenciasPage(),
            "/aplicacao/visualizar_respostas": (context) =>
                VisualizarRespostasPage(),
            "/aplicacao/definir_requisitos": (context) =>
                DefinirRequisistosPage(),

            //resposta
            "/resposta/home": (context) => RespostaHomePage(),
            "/resposta/resposta_questionario": (context) =>
                RespostaQuestionarioPage(),
            "/resposta/questionario_resposta": (context) =>
                QuestionarioRespostaPage(),

            //sintese
            "/sintese/home": (context) => SinteseHomePage(),

            //produto
            "/produto/home": (context) => ProdutoHomePage(),
            "/produto/crud": (context) {
              final settings = ModalRoute.of(context).settings;
              return ProdutoCRUDPage(settings.arguments);
            },
            "/produto/texto": (context) {
              final settings = ModalRoute.of(context).settings;
              return ProdutoTextoPage(settings.arguments);
            },
            "/produto/imagem": (context) {
              final settings = ModalRoute.of(context).settings;
              return ProdutoImagemListPage(settings.arguments);
            },
            "/produto/imagem_crud": (context) {
              final settings = ModalRoute.of(context).settings;
              ProdutoArguments args = settings.arguments;
              return ProdutoImagemCRUDPage(args.produtoID,args.arquivoID);
            },

            //produto0
            // "/produto": (context) => ProductPage(),
            "/produto/adicionar_editar": (context) => AddEditProduct(),
            "/produto/lista": (context) => ProductList(),
            "/produto/visual": (context) => ProductVisual(),
            "/produto/editar_visual": (context) => EditVisual(),

            //comunicacao
            "/comunicacao/home_page": (context) => ComunicacaoHomePage(),
            "/noticias/noticias_visualizadas": (context) => NoticiaLidaPage(),
            "/comunicacao/crud_page": (context) => ComunicacaoCRUDPage(),

            //administração
            "/administracao/home": (context) => AdministracaoHomePage(),
            "/administracao/perfil": (context) => AdministracaoPerfilPage(),

            //controle
            "/controle/home": (context) => ControleHomePage(),
          },
        ),
      ),
    );
  }
}
