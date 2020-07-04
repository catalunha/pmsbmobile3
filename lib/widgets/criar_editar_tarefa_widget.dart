import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class CriarEditarTarefaWidget extends StatefulWidget {
  final bool editar;

  const CriarEditarTarefaWidget({Key key, @required this.editar})
      : super(key: key);

  @override
  _CriarEditarTarefaWidgetState createState() =>
      _CriarEditarTarefaWidgetState();
}

class _CriarEditarTarefaWidgetState extends State<CriarEditarTarefaWidget> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.height * 0.40
        : MediaQuery.of(context).size.height * 0.60;

    double _width = MediaQuery.of(context).size.width > 1000
        ? MediaQuery.of(context).size.width * 0.45
        : MediaQuery.of(context).size.width * 0.65;

    Dialog dialogWithImage = Dialog(
      child: Container(
        color: PmsbColors.navbar,
        height: _height,
        width: _width,
        child: ListView(
          children: <Widget>[
            Container(
              width: _width,
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                        (widget.editar ? "Editar" : "Criar nova") + " tarefa",
                        style: PmsbStyles.textStyleListPerfil01),
                  ),
                  IconButton(
                    hoverColor: Colors.white12,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                color: Colors.white24,
                height: 1,
                width: _width,
              ),
            ),
            textoQuadro("Titulo da tarefa"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black12,
                ),
              ),
            ),
            textoQuadro("Descrição"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black12,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: PmsbColors.cor_destaque,
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        color: PmsbColors.navbar,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
    return dialogWithImage;
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 14,
        ),
      ),
    );
  }
}
