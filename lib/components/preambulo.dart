import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';


// class PreambuloTexto extends StatelessWidget {
//   final String text;

//   const PreambuloTexto(this.text, {Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 2),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16, color: Colors.blue),
//       ),
//     );
//   }
// }


class PreambuloTexto extends StatelessWidget {
  
  final String text;

  const PreambuloTexto(this.text);

  @override
  
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.black12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " ${this.text} ",
          style: PmsbStyles.textStyleListPerfil01,
        ),
      ),
    );
  }
}

class Preambulo extends StatefulWidget {
  final bool eixo;
  final bool setor;
  final questionarioID;
  final bool questionarioAplicado;
  final bool referencia;

  const Preambulo({
    Key key,
    this.eixo = false,
    this.setor = false,
    this.questionarioAplicado = false,
    this.questionarioID,
    this.referencia = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PreambuloState();
  }
}

class _PreambuloState extends State<Preambulo> {
  PreambuloBloc bloc;

  @override
  void initState() {
    bloc = PreambuloBloc(widget.questionarioID, widget.questionarioAplicado);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PreambuloBlocState>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PreambuloTexto(
                    "${widget.eixo ? snapshot.data?.usuario?.eixoIDAtual?.nome : ""} - ${widget.setor ? snapshot.data?.usuario?.setorCensitarioID?.nome : ""}"),
                if (widget.questionarioID != null)
                  PreambuloTexto("Q: ${snapshot.data?.questionario?.nome}"),
                if (widget.referencia && widget.questionarioID != null)
                  PreambuloTexto("R: ${snapshot.data?.questionario?.referencia}"),
              ],
            ),
          );
        });
  }
}

class PreambuloBlocState {
  UsuarioModel usuario;
  dynamic questionario;
}

class PreambuloBloc {
  final String _questionarioID;
  final bool _questionarioAplicado;
  final _state = PreambuloBlocState();

  final _firestore = Bootstrap.instance.firestore;
  final _authBLoc = Bootstrap.instance.authBloc;
  final _outputController = BehaviorSubject<PreambuloBlocState>();
  StreamSubscription _perifl;

  Stream<PreambuloBlocState> get stream => _outputController.stream;

  PreambuloBloc(this._questionarioID, this._questionarioAplicado) {
    _perifl = _authBLoc.perfil.listen((usuario) {
      _state.usuario = usuario;
      _outputController.add(_state);
    });
    if (_questionarioID != null) {
      final collection = _questionarioAplicado
          ? QuestionarioAplicadoModel.collection
          : QuestionarioModel.collection;
      _firestore
          .collection(collection)
          .document(_questionarioID)
          .get()
          .then((doc) {
        if (_questionarioAplicado) {
          final q =
              QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data);
          _state.questionario = q;
        } else {
          final q = QuestionarioModel(id: doc.documentID).fromMap(doc.data);
          _state.questionario = q;
        }
        _outputController.add(_state);
      });
    }
  }

  void dispose() {
    _perifl.cancel();
    _outputController.close();
  }
}
