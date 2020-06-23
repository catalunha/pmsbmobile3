import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/acao_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class AcaoListWidget extends StatefulWidget {
  final List<Acao> acoes;

  const AcaoListWidget({Key key, @required this.acoes}) : super(key: key);

  @override
  _AcaoListWidgetState createState() => _AcaoListWidgetState();
}

class _AcaoListWidgetState extends State<AcaoListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textoQuadro("Ações"),
            IconButton(icon: Icon(Icons.add_box), onPressed: () {}),
          ],
        ),
        Column(
          children: gerarListaAcoesWidgets(),
        ),
      ],
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

  List<Widget> gerarListaAcoesWidgets() {
    List<Widget> lista = List<Widget>();
    for (Acao acao in widget.acoes) {
      lista.add(CheckboxListTile(
        value: acao.status,
        title: Text(acao.titulo),
        onChanged: (bool newValue) {
          setState(() {
            acao.status = newValue;
          });
        },
        secondary: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: () {}),
      ));
    }
    return lista;
  }
}
