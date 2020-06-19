import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/etiqueta_card_widget.dart';

class EtiquetaWrapWidget extends StatefulWidget {
  final List<Etiqueta> etiquetas;

  const EtiquetaWrapWidget({Key key, @required this.etiquetas})
      : super(key: key);

  @override
  _EtiquetaWrapWidgetState createState() => _EtiquetaWrapWidgetState();
}

class _EtiquetaWrapWidgetState extends State<EtiquetaWrapWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textoQuadro("Etiquetas"),
            IconButton(icon: Icon(Icons.label), onPressed: () {}),
          ],
        ),
        Wrap(
            direction: Axis.horizontal,
            textDirection: TextDirection.ltr,
            spacing: 8.0,
            runSpacing: 4.0,
            children: gerarListaEtiquetasWidgets()),
      ],
    );
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
