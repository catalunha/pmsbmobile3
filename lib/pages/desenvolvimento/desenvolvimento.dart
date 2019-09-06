import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/desenvolvimento/desenvolvimento_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';

import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/perfil_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/bootstrap.dart';

class Desenvolvimento extends StatefulWidget {
  @override
  _DesenvolvimentoState createState() => _DesenvolvimentoState();
}

class _DesenvolvimentoState extends State<Desenvolvimento> {
  final bloc = DesenvolvimentoPageBloc(Bootstrap.instance.firestore);
  final fw.Firestore _firestore = Bootstrap.instance.firestore;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    // bloc.eventSink(
    //     UpdateProdutoIDArquivoIDEvent(widget.produtoID, widget.arquivoID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // fsw.Firestore _firestore = Bootstrap.instance.firestore;
    return DefaultScaffold(
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
                    title: Text('Criar Usuário em UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await usuarioPMSBWEB('Aq96qoxA0zgLfNDPGPCzFRAYtkl2');
                        // await usuarioCatalunhaUFT(
                        //     'mEYtvJ0QgkgcuvKI3Tr4xRH0OgQ2');
                        //Administração
                        // await usuarioAurelio('hQ5HviPFAsN74tDBDqD3KCABOf32');
                        // await usuarioJoaquina('98daMqALQRO1rpsakt5d6Dx26742');
                        // await usuarioGirlene('qnbwLQuiuXYJxKUFx5sHPZ3CgG92');
                        //Coordenadores
                        // await usuarioSergio('jkKgYjZ3zSf6cZ6T7ZrLxp5R9Am2');
                        await usuarioPortela('0s0pMoclpwPs2CwUWDAmeCdPz5s1');
                        // await usuarioBob('SftB5Ix0d4MaHLEs8LASoT7KKl13');
                        // await usuarioCleiton('9MZTcuTI3ofGW67tO5J1mTLHPl03');
                        // await usuarioRui('I2hXlyGuTHdXufAiu6jDp05m3ft1');
                        // await usuarioTatiana('oPZZYu1MOSU6AGcggVqptuLtVqn1');
                        //Outros
                        // await usuarioJuniezer('ysqq0XARJnZoxIzIc43suDm7gaK2');
                        //+++Equipe do sergio
                        // await usuarioDaise('3QQj89dTIzP2agsab2cDURfNRrx2');//daise1992@uft.edu.br
                        // await usuarioIcaro(
                        //     'otFKSENFI5Y5fkqsQCUrisVtcCh2'); //oliveiraicaro386@gmail.com
                        // await usuarioRenan(
                        //     '5rdZil1Vg5XD0mX9ZE1fM42q7wz2'); //renanaquilliscb@gmail.com
                        // await usuarioBruno(
                        //     'KvM6uM9U0MeTupzhj9TPuSdT55k1'); //brunoferronatobarros@gmail.com

                        // // await usuarioJucilene(
                        // //     'qgCxh7Rw2CRGmzySw8DGBUSDj9B2'); //jucilene@uft.edu.br
                        // await usuarioJuliana(
                        //     '6xReJevwK0d3DCQHmkRYpIoGN0g1'); //juliana_costa@uft.edu.br
                        // await usuarioWesley(
                        //     'wEcNvxpSt8d30pfoXMdH53jrSKu1'); //wesley.pinheiro@uft.edu.br
                        //---Equipe do sergio
                        //+++Equipe do Portela
                        // await usuarioIsabela(
                        //     'db2zlu1yOyaIuirS1gaVf21wlhv2'); //isabela.moura@uft.edu.br
                        // await usuarioClaudio(
                        //     'D2NnomLYGINlwNmieeTSh6F1z0c2'); //claudio.azevedo@mail.uft.edu.br
                        // await usuarioRosinete(
                        //     'G8IgMv0qhwgVuVSpzRmEWW1Fx2s1'); //ns.rosinete@gmail.com

                        

                        //---Equipe do Portela
                        //+++Equipe do Rui
                        // await usuarioAlesi(
                        //     'YaTtTki7PZPPHznqpVtZrW6mIa42'); //alesitmendes@gmail.com
                        // await usuarioGuilherme(
                        //     'Nuq3pIk3q8Q6aoNGVreZnRZzQE82'); //andregm@uft.edu.br
                        // await usuarioAna(
                        //     'N4xPaHBcyJSJeMOlhbjn2IrWjF73'); //anapaulafelicio@mail.uft.edu.br
                        // await usuarioAndre(
                        //     'lecuW7fVRsT6hJjTKmUtrAxcI9F2'); //andrema@uft.edu.br

                        //---Equipe do Rui
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Atualizar routes de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarRoutes('nsD07Jb8cqRy9liyX82JwDSq8d22');
                      },
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Atualizar eixo de acesso de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarEixoAcesso('SftB5Ix0d4MaHLEs8LASoT7KKl13');
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
                        // await atualizarEixoAcesso('ysqq0XARJnZoxIzIc43suDm7gaK2');

                        // Future<StorageReference> a = _storage.getReferenceFromUrl(
                        //     'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/05bcd37e-d1ad-4d0e-84c2-4ad27e8b05a0?alt=media&token=b727c190-4bae-4e8e-b45c-8569395dbf60');
                        // a.then((doc) {
                        //   doc.delete();
                        // });
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  Future atualizarRoutes(String userId) async {
    List<dynamic> routes = [
      '/',
      '/desenvolvimento',
      '/upload',
      '/questionario/home',
      '/aplicacao/home',
      '/resposta/home',
      '/sintese/home',
      '/produto/home',
      '/comunicacao/home_page',
      '/administracao/home',
      '/controle/home'
    ];
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData({"routes": routes}, merge: true);
    // print('>>> ok <<< ');
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

  Future usuarioPMSBWEB(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'PMSB TO 22',
      celular: '22',
      email: 'pmsb.web@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coo'),
      eixoID: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAcesso: [EixoID(id: 'estatisticadsti', nome: '')],
      eixoIDAtual: EixoID(id: 'estatisticadsti', nome: ''),
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'pal'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioAurelio(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Aurelio',
      celular: '123',
      email: 'aureliopicanco@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'direcao', nome: 'Direção'),
      eixoIDAtual: EixoID(id: 'direcao', nome: 'Direção'),
      eixoIDAcesso: [
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'administracao', nome: 'Administração'),
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioJoaquina(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Joaquina',
      celular: '123',
      email: 'joaquinagoulart@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'administracao', nome: 'Administração'),
      eixoIDAtual: EixoID(id: 'administracao', nome: 'Administração'),
      eixoIDAcesso: [
        EixoID(id: 'administracao', nome: 'Administração'),
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioSergio(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Sergio Queiroz',
      celular: '123',
      email: 'sergioqueiroz@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioPortela(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Thiago Portelinha',
      celular: '123',
      email: 'thiagoportelinha@mail.uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAtual: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioTatiana(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Tatiana',
      celular: '123',
      email: 'tatyfw@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
      eixoIDAtual:
          EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioGirlene(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Maciel',
      celular: '123',
      email: 'maciel@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'direcao', nome: 'Direção'),
      eixoIDAtual: EixoID(id: 'direcao', nome: 'Direção'),
      eixoIDAcesso: [
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'administracao', nome: 'Administração'),
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioBob(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Bob',
      celular: '123',
      email: 'bob@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/produto/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAtual: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAcesso: [
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioCleiton(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Cleiton Milagres',
      celular: '123',
      email: 'cleiton.milagres@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/comunicacao/home_page',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAtual: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAcesso: [
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioRui(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Rui',
      celular: '123',
      email: 'andradersilva@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home_page',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coordenador'),
      eixoID: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAtual: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioJuniezer(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Juniezer Souza',
      celular: '123',
      email: 'juniezersouza@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/produto/home',
        '/comunicacao/home_page',
        '/administracao/home',
        '/controle/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAtual: EixoID(id: 'comunicacao', nome: 'Comunicação'),
      eixoIDAcesso: [
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido')
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  //+++Equipe do sergio
  Future usuarioDaise(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'daise1992',
      celular: '123',
      email: 'daise1992@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'saude', nome: 'Saúde'),
      eixoIDAtual: EixoID(id: 'saude', nome: 'Saúde'),
      eixoIDAcesso: [
        EixoID(id: 'saude', nome: 'Saúde'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioIcaro(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'oliveiraicaro386',
      celular: '123',
      email: 'oliveiraicaro386@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioRenan(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'renanaquilliscb',
      celular: '123',
      email: 'renanaquilliscb@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioBruno(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'brunoferronatobarros',
      celular: '123',
      email: 'brunoferronatobarros@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioJucilene(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'jucilene',
      celular: '123',
      email: 'jucilene@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioJuliana(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'juliana_costa',
      celular: '123',
      email: 'juliana_costa@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }

  Future usuarioWesley(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'wesley.pinheiro',
      celular: '123',
      email: 'wesley.pinheiro@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAtual:
          EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }
  //---Equipe do sergio
  //+++Equipe do Portela

  Future usuarioIsabela(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'isabela.moura',
      celular: '123',
      email: 'isabela.moura@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAtual: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAcesso: [
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }
  Future usuarioClaudio(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'claudio',
      celular: '123',
      email: 'claudio.azevedo@mail.uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAtual: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAcesso: [
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }


Future usuarioRosinete(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'rosinete',
      celular: '123',
      email: 'ns.rosinete@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'estagiario', nome: 'Estagiário'),
      eixoID: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAtual: EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      eixoIDAcesso: [
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }


  //---Equipe do Portela
  //+++Equipe do Rui
  Future usuarioAlesi(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'alesitmendes',
      celular: '123',
      email: 'alesitmendes@gmail.com',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAtual: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAcesso: [
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
  }

  Future usuarioGuilherme(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'andregm',
      celular: '123',
      email: 'andregm@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAtual: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAcesso: [
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
  }

  Future usuarioAna(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'anapaulafelicio',
      celular: '123',
      email: 'anapaulafelicio@mail.uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAtual: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAcesso: [
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
  }

  Future usuarioAndre(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'andrema',
      celular: '123',
      email: 'andrema@uft.edu.br',
      routes: [
        '/',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
      ],
      cargoID: CargoID(id: 'bolsista', nome: 'Bolsista'),
      eixoID: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAtual: EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      eixoIDAcesso: [
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'Palmas'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    await docRef.setData(usuarioModel.toMap(), merge: true);
  }
  //---Equipe do Rui

}

//   Future<String> _selecionarNovoArquivo() async {
//     try {
//       var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
//       if (arquivoPath != null) {
//         // // print('>> newfilepath 1 >> ${arquivoPath}');
//         return arquivoPath;
//       }
//     } catch (e) {
//       // print("Unsupported operation" + e.toString());
//     }
//   }
// }

// StreamBuilder<UploadModel>(
//     stream: bloc.uploadBloc.uploadModelStream,
//     builder: (context, snapshot) {
//       dynamic image = FlutterLogo();
//       return Container(
//         child: snapshot.data == null
//             ? image
//             : SquareImage(
//                 image: NetworkImage(snapshot.data.url)),
//       );
//     })

// RaisedButton(
//   onPressed: () {
//     // +++ Criar Perfil
//     // Map<String, dynamic> perfil = {
//     //   "contentType": "text",
//     //   "nome": "Numero do CPF"
//     // };
//     // _firestore.collection(Perfil.collection).document().setData(
//     //     perfil,
//     //     merge: true);
//     // ---
//     // +++ Criar UsuarioPerfil
//     // Map<String, dynamic> usuarioPerfilModel = {
//     //   "usuarioID": {
//     //     "id": "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2",
//     //     "nome": "cata"
//     //   },
//     //   "perfilID": {
//     //     "id": "Lk5Fsn33myT14r2HDAp",
//     //     "nome": "Numero do CPF",
//     //     "contentType": "text"
//     //   },
//     // };
//     // _firestore
//     //     .collection(UsuarioPerfilModel.collection)
//     //     .document()
//     //     .setData(usuarioPerfilModel,
//     //         merge: true);
//     // ---
//     // +++ Listar NoticiaModel
//     // _firestore
//     //     .collection(NoticiaModel.collection)
//     //     .document('-LkB9elzgUkl5OHFyjoB')
//     //     .snapshots()
//     //     .listen((snap) {
//     //   // print('>> snap.data.toString() >> ${snap.data.toString()}');
//     //   NoticiaModel noticia = NoticiaModel(id:snap.documentID).fromMap(snap.data);
//     //   // print(noticia.toMap());
//     // });
//     // ---
//     // +++ Criar NoticiaModel
//     // Map<String, dynamic> noticiaModel = Map<String, dynamic>();
//     // noticiaModel["titulo"] = "outra noticia";
//     // noticiaModel["textoMarkdown"] = "textoMarkdown-valor1";
//     // noticiaModel["usuarioIDEditor"] = {
//     //   "id": "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2",
//     //   "nome": "UsuarioIDNome"
//     // };

//     // noticiaModel["publicada"] =false;
//     // noticiaModel["publicar"] = DateTime.now().toUtc();
//     // noticiaModel["usuarioIDDestino"] = {
//     //   "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2": {
//     //     "id": true,
//     //     "nome": "nome-valor",
//     //     "visualizada": false
//     //   }
//     // };

//     // // print('>> noticiaModel >> ${noticiaModel}');
//     // _firestore
//     //     .collection(NoticiaModel.collection)
//     //     .document()
//     //     .setData(noticiaModel, merge: true);
//     // ---
//     // +++ Criar UsuarioArquivo Perfil.csv
//     // Map<String, dynamic> map = Map<String, dynamic>();
//     // map['usuarioID'] = 'fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2';
//     // map['referencia'] = 'perfil.csv';
//     // map['contentType'] = 'text/csv';
//     // map['storagePath'] = 'gs://pmsb-22-to.appspot.com/csv-teste.csv';
//     // map['titulo'] = 'Planilha com perfil';
//     // map['url'] =
//     //     'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/csv-teste.csv?alt=media&token=5133f286-4987-4f32-adbf-21214492425c';
//     // UsuarioArquivoModel usuarioArquivoModel =
//     //     UsuarioArquivoModel().fromMap(map);
//     // _firestore
//     //     .collection(UsuarioArquivoModel.collection)
//     //     .document()
//     //     .setData(usuarioArquivoModel.toMap(), merge: true);
//     // ---
//     // +++ Criar UsuarioArquivo Perfil.pdf
//     // Map<String, dynamic> map = Map<String, dynamic>();
//     // map['usuarioID'] = 'fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2';
//     // map['referencia'] = 'perfil.pdf';
//     // map['contentType'] = 'application/pdf';
//     // map['storagePath'] = 'gs://pmsb-22-to.appspot.com/md-teste.pdf';
//     // map['titulo'] = 'PDF com perfil';
//     // map['url'] =
//     //     'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/md-teste.pdf?alt=media&token=010896c1-84b0-4672-bd89-dbb089be69fa';
//     // UsuarioArquivoModel usuarioArquivoModel =
//     //     UsuarioArquivoModel().fromMap(map);
//     // _firestore
//     //     .collection(UsuarioArquivoModel.collection)
//     //     .document()
//     //     .setData(usuarioArquivoModel.toMap(), merge: true);
//     // ---
//     // +++ Criar UsuarioArquivo Perfil.md
//     // Map<String, dynamic> map = Map<String, dynamic>();
//     // map['usuarioID'] = 'fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2';
//     // map['referencia'] = 'perfil.md';
//     // map['contentType'] = 'text/markdown';
//     // map['storagePath'] = 'gs://pmsb-22-to.appspot.com/md-teste.md';
//     // map['titulo'] = 'PDF com perfil';
//     // map['url'] =
//     //     'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/md-teste.md?alt=media&token=86bc30a6-f823-41b5-9830-ec4bc24e283c';
//     // UsuarioArquivoModel usuarioArquivoModel =
//     //     UsuarioArquivoModel().fromMap(map);
//     // _firestore
//     //     .collection(UsuarioArquivoModel.collection)
//     //     .document()
//     //     .setData(usuarioArquivoModel.toMap(), merge: true);
//     // ---
//   }, // fim onPressed
//   child: Text('Prof Catalunha'),
// ),
// RaisedButton(
//   onPressed: () {},
//   child: Text('Paulo Cruz'),
// ),
// RaisedButton(
//   onPressed: () {},
//   child: Text('Natã Bandeira'),
// ),
// RaisedButton(
//   onPressed: () {},
//   child: Text('Ellen Milhomem'),
// ),
