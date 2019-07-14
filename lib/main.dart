import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page.dart';
import 'package:pmsbmibile3/pages/controle/controle_home_page.dart';
import 'package:pmsbmibile3/pages/produto/product_visual.dart';
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
            //perfil
            "/perfil": (context) => PerfilPage(),
            "/perfil/editar_variavel": (context) => PerfilEditarVariavelPage(),
            "/perfil/configuracao": (context) => ConfiguracaoPage(),
            //questionario
            "/questionario/home": (context) => QuestionarioHomePage(),
            "/questionario/adicionar_editar": (context) =>
                AdicionarEditarQuestionarioPage(),

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

            //home
            "/aplicacao/home": (context) => AplicacaoHomePage(),
            "/aplicacao/momento_aplicacao": (context) => MomentoAplicacaoPage(),
            "/aplicacao/aplicando_pergunta": (context) =>
                AplicacaoPerguntaPage(),

            //resposta
            "/resposta/home": (context) => RespostaHomePage(),
            "/resposta/resposta_questionario": (context) =>
                RespostaQuestionarioPage(),
            "/resposta/questionario_resposta": (context) =>
                QuestionarioRespostaPage(),

            //sintese
            "/sintese/home": (context) => SinteseHomePage(),

            //produto
            "/produto": (context) => ProductPage(),
            "/produto/adicionar_editar": (context) => AddEditProduct(),
            "/produto/lista": (context) => ProductList(),
            "/produto/visual": (context) => ProductVisual(),
            "/produto/editar_visual": (context) => EditVisual(),

            //comunicacao
            "/comunicacao": (context) => CommunicationPage(),
            "/noticias/noticias_visualizadas": (context) =>
                NoticiasVisualizadasPage(),
            "/comunicacao/criar_editar": (context) => CommunicationCreateEdit(),

            //administração
            // Kpt5ah4pkdZXhcsUD5it
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
