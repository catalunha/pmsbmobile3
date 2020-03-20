import 'dart:async';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/desenvolvimento/desenvolvimento_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pmsbmibile3/bootstrap.dart';

import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class Desenvolvimento extends StatefulWidget {
  @override
  _DesenvolvimentoState createState() => _DesenvolvimentoState();
}

class _DesenvolvimentoState extends State<Desenvolvimento> {
  final bloc = DesenvolvimentoPageBloc(Bootstrap.instance.firestore);
  final fw.Firestore _firestore = Bootstrap.instance.firestore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        backToRootPage: true,
        title: Text('Desenvolvimento - teste'),
        body: StreamBuilder<PageState>(
            stream: bloc.stateStream,
            builder: (BuildContext context, AsyncSnapshot<PageState> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(child: Text('Erro.')),
                );
              }
              return ListView(
                children: <Widget>[
                  Text(
                      'Algumas vezes precisamos fazer alimentação das coleções, teste de telas ou outras ações dentro do aplicativo em desenvolvimento. Por isto criei estes botões para facilitar de forma rápida estas ações.'),
                  ListTile(
                    title: Text('Criar Usuario em UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await usuarioPMSBWEB('Aq96qoxA0zgLfNDPGPCzFRAYtkl2');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Atualizar routes de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarRoutes('YaTtTki7PZPPHznqpVtZrW6mIa42');
                        // await atualizarRoutesTodos();
                      },
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Atualizar eixo de acesso de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarEixoAcesso('ysqq0XARJnZoxIzIc43suDm7gaK2');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Teste delete.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarEixoAcesso('SftB5Ix0d4MaHLEs8LASoT7KKl13');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Testar comandos firebase.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await testarFirebaseCmds();
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  Future testarFirebaseCmds() async {
    final docRef = await _firestore
        .collection(UsuarioModel.collection)
        .where('routes', arrayContains: '/comunicacao/home')
        .getDocuments();
    for (var item in docRef.documents) {
      print('Doc encontrados: ${item.documentID}');
    }
  }

  Future atualizarRoutesTodos() async {
    var collRef =
        await _firestore.collection(UsuarioModel.collection).getDocuments();

    for (var documentSnapshot in collRef.documents) {
      if (documentSnapshot.data.containsKey('routes')) {
        List<dynamic> routes = List<dynamic>();

        routes.addAll(documentSnapshot.data['routes']);
        print(routes.runtimeType);
        routes.addAll([
          // Drawer
          // '/',
          // '/upload',
          // '/questionario/home',
          // '/aplicacao/home',
          // '/resposta/home',
          // '/sintese/home',
          // '/produto/home',
          // '/comunicacao/home',
          // '/administracao/home',
          // '/controle/home',
          // "/perfil/configuracao",
          // endDrawer
          '/perfil/configuracao',
          '/perfil',
          // '/painel/home',
          '/modooffline',
          "/versao",
        ]);

        await documentSnapshot.reference
            .setData({"routes": routes}, merge: true);
      } else {
        print('Sem routes ${documentSnapshot.documentID}');
      }
    }
  }

  Future atualizarRoutes(String userId) async {
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    var snap = await docRef.get();
    List<dynamic> routes = List<dynamic>();
    routes.addAll(snap.data['routes']);
    print(routes.runtimeType);
    routes.addAll([
      //Drawer
      // '/',
      // '/upload',
      // '/questionario/home',
      // '/aplicacao/home',
      // '/resposta/home',
      // '/sintese/home',
      // '/produto/home',
      // '/comunicacao/home',
      // '/administracao/home',
      // '/controle/home',
      // "/perfil/configuracao",
      // endDrawer
      '/perfil/configuracao',
      '/perfil',
      // '/painel/home',
      '/modooffline',
      "/versao",
    ]);

    await docRef.setData({"routes": routes}, merge: true);
  }

  Future atualizarEixoAcesso(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'saude', nome: 'Saúde'),
        EixoID(id: 'administracao', nome: 'Administração'),
      ],
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
  }

  Future usuarioCatalunhaUFT(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Catalunha UFT',
      celular: '0',
      email: 'catalunha@uft.edu.br',
      routes: [
        '/',
        '/desenvolvimento',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home',
        '/administracao/home',
        '/controle/home'
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coord'),
      eixoID: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAtual: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'administracao', nome: 'Administração'),
        EixoID(id: 'saude', nome: 'Saúde'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'pal'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }
}
