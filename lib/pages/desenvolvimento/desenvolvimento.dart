import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';

import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/perfil_model.dart';

class Desenvolvimento extends StatefulWidget {
  @override
  _DesenvolvimentoState createState() => _DesenvolvimentoState();
}

class _DesenvolvimentoState extends State<Desenvolvimento> {
  @override
  Widget build(BuildContext context) {
    fsw.Firestore _firestore = Bootstrap.instance.firestore;
    return DefaultScaffold(
      title: Text('Desenvolvimento'),
      body: ListView(
        children: <Widget>[
          Text(
              'Algumas vezes precisamos fazer alimentação das coleções, teste de telas ou outras ações dentro do aplicativo em desenvolvimento. Por isto criei estes botões para facilitar de forma rápida estas ações.'),
          RaisedButton(
            onPressed: () {
              // +++ Criar Perfil
              // Map<String, dynamic> perfil = {
              //   "contentType": "text",
              //   "nome": "Numero do CPF"
              // };
              // _firestore.collection(Perfil.collection).document().setData(
              //     perfil,
              //     merge: true);
              // ---
              // +++ Criar UsuarioPerfil
              // Map<String, dynamic> usuarioPerfilModel = {
              //   "usuarioID": {
              //     "id": "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2",
              //     "nome": "cata"
              //   },
              //   "perfilID": {
              //     "id": "Lk5Fsn33myT14r2HDAp",
              //     "nome": "Numero do CPF",
              //     "contentType": "text"
              //   },
              // };
              // _firestore
              //     .collection(UsuarioPerfilModel.collection)
              //     .document()
              //     .setData(usuarioPerfilModel,
              //         merge: true);
              // ---
              // +++ Listar NoticiaModel
              // _firestore
              //     .collection(NoticiaModel.collection)
              //     .document('-LkB9elzgUkl5OHFyjoB')
              //     .snapshots()
              //     .listen((snap) {
              //   print('>> snap.data.toString() >> ${snap.data.toString()}');
              //   NoticiaModel noticia = NoticiaModel(id:snap.documentID).fromMap(snap.data);
              //   print(noticia.toMap());
              // });
              // ---
              // +++ Criar NoticiaModel
              Map<String, dynamic> noticiaModel = Map<String, dynamic>();
              noticiaModel["titulo"] = "outra noticia";
              noticiaModel["textoMarkdown"] = "textoMarkdown-valor1";
              noticiaModel["usuarioIDEditor"] = {
                "id": "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2",
                "nome": "UsuarioIDNome"
              };
              
              noticiaModel["publicada"] =false;
              noticiaModel["publicar"] = DateTime.now().toUtc();
              noticiaModel["usuarioIDDestino"] = {
                "fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2": {
                  "id": true,
                  "nome": "nome-valor",
                  "visualizada": false
                }
              };

              print('>> noticiaModel >> ${noticiaModel}');
              _firestore
                  .collection(NoticiaModel.collection)
                  .document()
                  .setData(noticiaModel, merge: true);
              // ---
            },
            child: Text('Prof Catalunha'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('Paulo Cruz'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('Natã Bandeira'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('Ellen Milhomem'),
          ),
        ],
      ),
    );
  }
}
