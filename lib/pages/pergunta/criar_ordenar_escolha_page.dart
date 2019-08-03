// import 'package:pmsbmibile3/components/eixo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:pmsbmibile3/pages/page_arguments.dart';
// import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';

// class CriarOrdenarEscolha extends StatelessWidget {
//   final EditarApagarPerguntaBloc bloc;

//   CriarOrdenarEscolha(this.bloc);

//   _textoTopo(text) {
//     return Padding(
//       padding: EdgeInsets.only(top: 10),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16, color: Colors.blue),
//       ),
//     );
//   }

//   _listarPerguntaEscolha() {
//     return StreamBuilder<EditarApagarPerguntaBlocState>(
//       stream: bloc.state,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text("ERROR");
//         }
//         if (!snapshot.hasData) {
//           return Text("SEM DADOS");
//         }
//         List<Widget> list = List<Widget>();
//         snapshot.data.escolhas.forEach((k, v) {
//           list.add(Card(
//             elevation: 10,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                     flex: 3,
//                     child: ListTile(
//                       leading: Icon(Icons.info),
//                       title: Text(v.texto),
//                     )),
//                 Expanded(
//                   flex: 2,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       IconButton(
//                           icon: Icon(Icons.arrow_downward),
//                           onPressed: () {
//                             // Mover pra baixo na ordem
//                           }),
//                       IconButton(
//                           icon: Icon(Icons.arrow_upward),
//                           onPressed: () {
//                             // Mover pra cima na ordem
//                           }),
//                       IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             // Editar uma nova escolha
//                             Navigator.pushNamed(
//                                 context, "/pergunta/editar_apagar_escolha",
//                                 arguments: EditarApagarEscolhaPageArguments(
//                                     bloc, k));
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ));
//         });
//         return ListView(
//           children: list,
//         );
//       },
//     );
//   }

//   _body() {
//     return Container(
//         alignment: Alignment(0.0, 0.0),
//         child: Column(children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(top: 10),
//             child: EixoAtualUsuario(),
//           ),
//           StreamBuilder<EditarApagarPerguntaBlocState>(
//             stream: bloc.state,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text("ERROR");
//               }
//               if (!snapshot.hasData) {
//                 return Text("SEM DADOS");
//               }
//               return Column(
//                 children: <Widget>[
//                   _textoTopo(
//                       "Questionario: ${snapshot.data.questionario.nome}"),
//                   _textoTopo("Pergunta: ${snapshot.data.titulo}"),
//                 ],
//               );
//             },
//           ),
//           Padding(padding: EdgeInsets.all(10)),
//           Expanded(child: _listarPerguntaEscolha())
//         ]));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         appBar: AppBar(
//           // backgroundColor: Colors.red,
//           automaticallyImplyLeading: true,
//           title: Text('Criar ordenar escolha'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // Adicionar uma nova escolha
//             Navigator.pushNamed(context, "/pergunta/editar_apagar_escolha",
//                 arguments: EditarApagarEscolhaPageArguments(bloc, null));
//           },
//           child: Icon(Icons.add),
//           backgroundColor: Colors.blue,
//         ),
//         body: _body());
//   }
// }
