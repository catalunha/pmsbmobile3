import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/lista_usuarios_modal.dart';

class EquipeWrapWidget extends StatefulWidget {
  @override
  _EquipeWrapWidgetState createState() => _EquipeWrapWidgetState();
}

class _EquipeWrapWidgetState extends State<EquipeWrapWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textoQuadro("Equipe"),
              SizedBox(width: 5),
              IconButton(
                  icon: Icon(
                    Icons.person_add,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ListaUsuariosModal(
                              selecaoMultipla: true,
                            ));
                  })
            ],
          ),
          Container(
            //color: Colors.red,
            // width: MediaQuery.of(context).size.width * 0.77,
            child: Wrap(
              direction: Axis.horizontal,
              textDirection: TextDirection.ltr,
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('BS')),
                  label: Text('Bruno'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('TL')),
                  label: Text('Tiago'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('SM')),
                  label: Text('Susana'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('MJ')),
                  label: Text('Mariana'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 5),
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
