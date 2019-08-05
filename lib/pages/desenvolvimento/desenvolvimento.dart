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
        title: Text('Desenvolvimento'),
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
                        // await usuarioPMSBWEB('Aq96qoxA0zgLfNDPGPCzFRAYtkl2');
                        // await usuarioAurelio('hQ5HviPFAsN74tDBDqD3KCABOf32');
                        // await usuarioJoaquina('98daMqALQRO1rpsakt5d6Dx26742');
                        // await usuarioSergio('jkKgYjZ3zSf6cZ6T7ZrLxp5R9Am2');
                        // await usuarioPortela('0s0pMoclpwPs2CwUWDAmeCdPz5s1');
                        // // await usuarioTatiana('');
                        // await usuarioGirlene('qnbwLQuiuXYJxKUFx5sHPZ3CgG92');
                        // await usuarioBob('SftB5Ix0d4MaHLEs8LASoT7KKl13');
                        // await usuarioCleiton('9MZTcuTI3ofGW67tO5J1mTLHPl03');
                        // await usuarioRui('I2hXlyGuTHdXufAiu6jDp05m3ft1');
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

                  // ListTile(
                  //   title: Text('Timestamp'),
                  //   trailing: IconButton(
                  //     icon: Icon(Icons.menu),
                  //     onPressed: () async {
                  //       // final docRef = _firestore
                  //       //     .collection(QuestionarioModel.collection)
                  //       //     .document('-LkcyH14YG3LUeRwQhlM');

                  //       // await docRef.setData({"modificado":Bootstrap.instance.FieldValue.serverTimestamp()}, merge: true);
                  //     },
                  //   ),
                  // ),

                  // Text('arquivoRascunho: ' + (snapshot.data?.arquivo ?? '...')),
                ],
              );
            }));
  }

  Future atualizarRoutes(String usuario) async {
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
        _firestore.collection(UsuarioModel.collection).document(usuario);

    await docRef.setData({"routes": routes}, merge: true);
    print('>>> ok <<< ');
  }

  Future usuarioCatalunhaUFT(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'uft',
      celular: '0',
      email: 'catalunha@uft.edu.br',
      routes: ['/'],
      cargoID: CargoID(id: 'coordenador', nome: 'Coo'),
      eixoID: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAcesso: [EixoID(id: 'estatisticadsti', nome: '')],
      eixoIDAtual: EixoID(id: 'estatisticadsti', nome: ''),
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'pal'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
  }

  Future usuarioPortela(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Thiago Portelinha',
      celular: '123',
      email: 'thiagoportelinha@uft.edu.br',
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
    print('>>> ok <<< ');
  }

  Future usuarioTatiana(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: '',
      celular: '123',
      email: '@uft.edu.br',
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
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
    print('>>> ok <<< ');
  }

}

//   Future<String> _selecionarNovoArquivo() async {
//     try {
//       var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
//       if (arquivoPath != null) {
//         // print('>> newfilepath 1 >> ${arquivoPath}');
//         return arquivoPath;
//       }
//     } catch (e) {
//       print("Unsupported operation" + e.toString());
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
//     //   print('>> snap.data.toString() >> ${snap.data.toString()}');
//     //   NoticiaModel noticia = NoticiaModel(id:snap.documentID).fromMap(snap.data);
//     //   print(noticia.toMap());
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

//     // print('>> noticiaModel >> ${noticiaModel}');
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
