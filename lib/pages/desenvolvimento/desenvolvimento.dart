import 'dart:async';
import 'dart:io';
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
              // // Criar Perfis
              // _firestore.collection(Perfil.collection).document().setData(
              //     {"contentType": "text", "nome": "Numero do CPF"},
              //     merge: true);
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
