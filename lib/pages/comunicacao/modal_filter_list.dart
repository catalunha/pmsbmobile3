
import 'package:flutter/material.dart';

void modalEscolhaDeTipoFiltro(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Escolha o item para filtrar a notícia:",
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                onTap: () {},
                title: Text("Numero"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Titulo"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Data de inicio"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Data de fim"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Tem anexo"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Lidas"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Não lidas"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Destinos"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {},
                title: Text("Arquivadas"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        );
      });
}
