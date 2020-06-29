import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:pmsbmibile3/widgets/etiqueta_card_widget.dart';

class EtiquetaWrapWidget extends StatefulWidget {
  final List<Etiqueta> etiquetas;

  const EtiquetaWrapWidget({Key key, @required this.etiquetas})
      : super(key: key);

  @override
  _EtiquetaWrapWidgetState createState() => _EtiquetaWrapWidgetState();
}

class _EtiquetaWrapWidgetState extends State<EtiquetaWrapWidget> {
  int botaoradioSelecionado;
  void initState() {
    super.initState();
    botaoradioSelecionado = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textoQuadro("Prioridade"),
            IconButton(icon: Icon(Icons.label), onPressed: () {}),
          ],
        ),
        RadioListTile(
          title: Text(
            "Baixa",
            style: PmsbStyles.textoPrimario,
          ),
          subtitle: Text(
            "Tarefa que não necessita de resolução imediata",
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
            "Alta",
            style: PmsbStyles.textoPrimario,
          ),
          subtitle: Text(
              "Tarefa que necessita de resolução imediata"),
          value: 2,
          groupValue: botaoradioSelecionado,
          activeColor: PmsbColors.cor_destaque,
          onChanged: (val) {
            print("Radio $val");
            setBotaoRadioSelecionado(val);
          },
        ),
      ],
    );
  }

  setBotaoRadioSelecionado(int val) {
    setState(() {
      botaoradioSelecionado = val;
    });
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 5),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 18,
        ),
      ),
    );
  }

  gerarListaEtiquetasWidgets() {
    List<Widget> lista = List<Widget>();
    for (Etiqueta etiqueta in widget.etiquetas) {
      lista.add(EtiquetaCardWidget(
        etiqueta: etiqueta,
      ));
    }
    return lista;
  }
}
