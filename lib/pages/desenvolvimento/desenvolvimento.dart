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
                    title: Text('Atualizar routes de usuario.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // List<dynamic> routes = [
                        //   '/',
                        //   '/desenvolvimento',
                        //   '/upload',
                        //   '/questionario/home',
                        //   '/aplicacao/home',
                        //   '/resposta/home',
                        //   '/sintese/home',
                        //   '/produto/home',
                        //   '/comunicacao/home_page',
                        //   '/administracao/home',
                        //   '/controle/home'
                        // ];
                        // final docRef = _firestore
                        //     .collection(UsuarioModel.collection)
                        //     .document('nsD07Jb8cqRy9liyX82JwDSq8d22');

                        // await docRef.setData({"routes": routes}, merge: true);
                        // print('>>> ok <<< ');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Criar Usuario em UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // UsuarioModel usuarioModel = UsuarioModel(
                        //   id: 'mEYtvJ0QgkgcuvKI3Tr4xRH0OgQ2',
                        //   ativo: true,
                        //   nome: 'uft',
                        //   celular: '0',
                        //   email: 'catalunha@uft.edu.br',
                        //   routes: ['/'],
                        //   cargoID: CargoID(id: 'coordenador',nome: 'Coo'),
                        //   eixoID: EixoID(id: 'estatisticadsti',nome: ''),
                        //   eixoIDAcesso: [EixoID(id: 'estatisticadsti',nome: '')],
                        //   eixoIDAtual: EixoID(id: 'estatisticadsti',nome: ''),
                        //   setorCensitarioID: SetorCensitarioID(id: 'palmas',nome: 'pal'),
                        // );
                        // final docRef = _firestore
                        //     .collection(UsuarioModel.collection)
                        //     .document('mEYtvJ0QgkgcuvKI3Tr4xRH0OgQ2');

                        // await docRef.setData(usuarioModel.toMap(), merge: true);
                        // print('>>> ok <<< ');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Timestamp'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        final docRef = _firestore
                            .collection(QuestionarioModel.collection)
                            .document('-LkcyH14YG3LUeRwQhlM');

                        await docRef.setData({"modificado":Bootstrap.instance.FieldValue.serverTimestamp()}, merge: true);
                      },
                    ),
                  ),

                  // Text('arquivoRascunho: ' + (snapshot.data?.arquivo ?? '...')),
                ],
              );
            }));
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
