import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'administracao_perfil_page_bloc.dart';

class AdministracaoPerfilPage extends StatelessWidget {
  final bloc = AdministracaoPerfilPageBloc();
  @override
  Widget build(BuildContext context) {
    _body() {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: SquareImage(
                      image: NetworkImage(
                        "https://pingendo.github.io/pingendo-bootstrap/assets/user_placeholder.png",
                      ),
                    )),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nome: #nomeProjeto"),
                        Text("Celular: #celular"),
                        Text("Email: #email"),
                        Text("Eixo: #eixo"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Padding(padding: EdgeInsets.all(10),child: Text("Perfil do usuario:",style: TextStyle(fontSize: 16),)),
            Table(border: TableBorder.all(width: 1.0), children: [
              TableRow(children: [
                Text(" Item", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(" Valor", style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
              TableRow(children: [
                Text(" #Item"),
                Text(" #valor"),
              ]),
              TableRow(children: [
                Text(" #Item"),
                Text(" #valor"),
              ]),
              TableRow(children: [
                Text(" #Item"),
                Text(" #arquivo",style: TextStyle(color: Colors.blue),),
              ]),
            ]),
            Padding(padding: EdgeInsets.all(10)),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text("Visualizar dados e perfil"),
        ),
        body: _body());
  }
}
