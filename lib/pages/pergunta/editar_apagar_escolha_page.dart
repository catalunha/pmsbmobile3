// import 'package:flutter/material.dart';
// import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';
// import 'package:pmsbmibile3/components/eixo.dart';

// class EscolhaTextoField extends StatefulWidget {
//   final EditarApagarPerguntaBloc bloc;

//   EscolhaTextoField(this.bloc);

//   @override
//   _EscolhaTextoFieldState createState() {
//     return _EscolhaTextoFieldState();
//   }
// }

// class _EscolhaTextoFieldState extends State<EscolhaTextoField> {
//   bool initial = true;
//   final _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<EditarApagarPerguntaBlocState>(
//       stream: widget.bloc.state,
//       builder: (context, snapshot) {
//         if (initial &&
//             snapshot.hasData &&
//             snapshot.data.escolhas[snapshot.data.itemEscolhaID] != null) {
//           _controller.text =
//               snapshot.data.escolhas[snapshot.data.itemEscolhaID].texto;
//           initial = false;
//         }
//         return TextField(
//           controller: _controller,
//           onChanged: (text) {
//             widget.bloc
//                 .dispatch(UpdateItemEscolhaEditarApagarPerguntaBlocEvent(text));
//           },
//           keyboardType: TextInputType.multiline,
//           maxLines: null,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class EditarApagarEscolhaPage extends StatelessWidget {
//   final EditarApagarPerguntaBloc bloc;
//   final String escolhaID;

//   EditarApagarEscolhaPage(this.bloc, this.escolhaID) {
//     bloc.dispatch(UpdateItemEscolhaIDEditarApagarPerguntaBlocEvent(escolhaID));
//   }

//   _botaoDeletar(context) {
//     return SafeArea(
//       child: Row(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(5.0),
//             child: RaisedButton(
//               // color: Colors.red,
//               onPressed: () {
//                 // DELETAR ESTA PERGUNTA
//                 bloc.dispatch(
//                     DeletarItemEscolhaEditarApagarPerguntaBlocEvent());
//                 Navigator.pop(context);
//               },
//               child: Row(
//                 children: <Widget>[
//                   Text('Apagar', style: TextStyle(fontSize: 20)),
//                   Icon(Icons.delete)
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _areaTexto() {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: EscolhaTextoField(bloc),
//     );
//   }

//   _textoTopo(text) {
//     return Padding(
//       padding: EdgeInsets.only(top: 10),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16, color: Colors.blue),
//       ),
//     );
//   }

//   _listaTitulos() {
//     return Column(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(top: 10),
//           child: EixoAtualUsuario(),
//         ),
//         _textoTopo("RS 01 - Questionarios de ..."),
//         _textoTopo("Pergunta tipo escolha unica"),
//         _textoTopo("Edição das escolhas"),
//         Padding(padding: EdgeInsets.all(5)),
//         Divider(color: Colors.black, height: 5),
//       ],
//     );
//   }

//   _body(context) {
//     return Container(
//       child: ListView(
//         children: <Widget>[
//           Padding(padding: EdgeInsets.all(5)),
//           _listaTitulos(),
//           Padding(
//               padding: EdgeInsets.all(5.0),
//               child: Text(
//                 "Titulo da escolha:",
//                 style: TextStyle(fontSize: 15, color: Colors.blue),
//               )),
//           SafeArea(child: _areaTexto()),
//           if (escolhaID != null) _botaoDeletar(context),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           // backgroundColor: Colors.red,
//           automaticallyImplyLeading: true,
//           title: Text('Editar ou apagar escolha'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // Salvar nova escolha
//             bloc.dispatch(AddItemEscolhaEditarApagarPerguntaBlocEvent());
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.thumb_up),
//           backgroundColor: Colors.blue,
//         ),
//         body: _body(context));
//   }
// }
