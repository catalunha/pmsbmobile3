import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class ControleEditarCriarPage extends StatefulWidget {
  @override
  _ControleEditarCriarPageState createState() =>
      _ControleEditarCriarPageState();
}

class _ControleEditarCriarPageState extends State<ControleEditarCriarPage> {
  int botaoradioSelecionado;
  @override
  void initState() {
    super.initState();
    botaoradioSelecionado = 0;
  }

  setBotaoRadioSelecionado(int val) {
    setState(() {
      botaoradioSelecionado = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("Criar e Editar Quadro"),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      child: Column(
        children: <Widget>[Expanded(child: mainQuadro())],
      ),
    );
  }

  Widget mainQuadro() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.10,
        vertical: height * 0.02,
      ),
      child: Container(
        child: ListView(
          children: <Widget>[
            textoTitulo("Crie um novo Quadro"),
            textoSubtitulo(
                "Supervisione, gerencie e atualize seu trabalho em um só local, para que as tarefas continuem dentro do conograma."),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                color: Colors.white24,
                width: MediaQuery.of(context).size.width * 0.05,
                height: 1,
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            textoQuadro("Nome do Quadro"),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.black12,
                    hintText: 'Nome da diretoria do quadro'),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            textoQuadro("Descrição (Opcional)"),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black12,
                ),
              ),
              //RadioListTile(
              // value: 1,
              // groupValue: 1,
              // title: Text("Botão 1"),
              //),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  RadioListTile(
                    title: Text(
                      "Público",
                      style: PmsbStyles.textoPrimario,
                    ),
                    subtitle: Text(
                      "Qualquer pessoa pode ver este quadro. Você escolhe quem pode editar",
                      style: PmsbStyles.textoSecundario,
                    ),
                    value: 1,
                    groupValue: botaoradioSelecionado,
                    activeColor: PmsbColors.cor_destaque,
                    onChanged: (val) {
                      print("Radio $val");
                      setBotaoRadioSelecionado(val);
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      "Privado",
                      style: PmsbStyles.textoPrimario,
                    ),
                    subtitle: Text(
                        "Você escolhe quem pode ver e se comprometer com este quadro."),
                    value: 2,
                    groupValue: botaoradioSelecionado,
                    activeColor: PmsbColors.cor_destaque,
                    onChanged: (val) {
                      print("Radio $val");
                      setBotaoRadioSelecionado(val);
                    },
                  ),
                  RaisedButton(
                    child: Text("Criar Quadro"),
                    color: PmsbColors.cor_destaque,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/controle/editar_criar_quadro");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textoTitulo(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
            color: PmsbColors.texto_primario,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textoSubtitulo(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_terciario,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 18,
        ),
      ),
    );
  }
}
