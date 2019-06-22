import 'package:flutter/material.dart';

class ConfiguracaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: ListView(
          children: <Widget>[
            SelecionarEixo(),
            SelecionarSetorCensitario(),
            SelecionarTema(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AtualizarNumeroCelular(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AtualizarNomeNoProjeto(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AtualizarImagemPerfil(),
            ),
          ],
        ),
      ),
    );
  }
}

class SelecionarEixo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesEixo());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Eixo para sua visibilidade"),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}

class OpcoesEixo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Eixo 1"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Eixo 2"),
        ),
      ],
    );
  }
}

class SelecionarSetorCensitario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (context) => OpcoesSetorCensitario());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Setor Censitário"),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}

class OpcoesSetorCensitario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Setor 1"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Setor 2"),
        ),
      ],
    );
  }
}

class SelecionarTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesTema());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Tema"),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}

class OpcoesTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Dark"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Light"),
        ),
      ],
    );
  }
}

class AtualizarNumeroCelular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Atualizar numero celular"),
        TextField(),
      ],
    );
  }
}

class AtualizarNomeNoProjeto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Atualizar numero celular"),
        TextField(),
      ],
    );
  }
}

class AtualizarImagemPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Atualizar numero celular"),
        TextField(),
      ],
    );
  }
}
