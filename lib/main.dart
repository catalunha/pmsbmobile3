import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/produto/product_visual.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/state/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Provider<DatabaseService>.value(
        value: DatabaseService(),
        child: MaterialApp(
          title: 'PMSB',
          theme: ThemeData.dark(),
          initialRoute: "/",
          routes: {
            "/": (context) => HomePage(),

            //perfil
            "/perfil": (context) => PerfilPage(),
            "/perfil/editar_variavel": (context) => PerfilEditarVariavelPage(),

            "/questionario/home":(context) => QuestionarioHomePage(),
            "/pergunta/home":(context) => PerguntaHomePage(),
            "/aplicacao/home":(context) => AplicacaoHomePage(),
            "/resposta/home":(context) => RespostaHomePage(),
            "/sintese/home":(context) => SinteseHomePage(),

            //produto
            "/produto": (context) => ProductPage(),
            "/produto/adicionar_editar": (context) => AddEditProduct(),
            "/produto/lista": (context) => ProductList(),
            "/produto/visual": (context) => ProductVisual(),
            "/produto/editar_visual": (context) => EditVisual(),

            //comunicacao
            "/noticias/noticias_visualizadas": (context) =>
                NoticiasVisualizadasPage(),
            "/comunicacao": (context) => CommunicationPage(),
            "/comunicacao/criar_editar": (context) => CommunicationCreateEdit(),

            //administração
            "/administracao/home":(context) => AdministracaoHomePage(),
          },
        ),
      ),
    );
  }
}
