import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class DeleteDocument extends StatefulWidget {
  final Function onDelete;
  const DeleteDocument({this.onDelete});
  @override
  DeleteDocumentState createState() {
    return DeleteDocumentState(this.onDelete);
  }
}

class DeleteDocumentState extends State<DeleteDocument> {
  final Function onDelete;

  final _textFieldController = TextEditingController();
  DeleteDocumentState(this.onDelete);
  @override
  Widget build(BuildContext context) {
    return Container(
          height: 250,
          color: PmsbColors.fundo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Para apagar, digite CONCORDO na caixa de texto abaixo e confirme:  ',
                  style: PmsbStyles.textoPrimario,
                ),
                Container(
                  child: Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Digite aqui",
                        hintStyle: TextStyle(
                            color: Colors.white38, fontStyle: FontStyle.italic),
                      ),
                      controller: _textFieldController,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Botao de cancelar delete
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffEB3349),
                              Color(0xffF45C43),
                              Color(0xffEB3349)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancelar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                          onDelete();
                          _alerta(
                            "O Munícipio foi removido.",
                            () {
                              var count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 3;
                              });
                            },
                          );
                        } else {
                          _alerta(
                            "Verifique se a caixa de texto abaixo foi preenchida corretamente.",
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff1D976C),
                              Color(0xff1D976C),
                              Color(0xff93F9B9)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Confirmar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    
    
    // Row(
    //   children: <Widget>[
    //     Divider(),
    //     IconButton(
    //       tooltip: 'Para apagar digite CONCORDO e depois click aqui.',
    //       icon: Icon(Icons.delete),
    //       onPressed: () {
    //         if (_textFieldController.text == 'CONCORDO') {
    //           onDelete();
    //         }
    //       },
    //     ),
    //     Text('Digite  '),
    //     Container(
    //       child: Flexible(
    //         child: TextField(
    //           controller: _textFieldController,
    //           decoration: InputDecoration(hintText: 'CONCORDO'),

    //         ),
    //       ),
    //     ),
    //     Text('e libere o ícone para apagar !'),
    //   ],
    // );
  }

    Future<void> _alerta(String msgAlerta, Function acao) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PmsbColors.card,
          title: Text(msgAlerta),
          actions: <Widget>[
            FlatButton(child: Text('Ok'), onPressed: acao),
          ],
        );
      },
    );
  }
}
