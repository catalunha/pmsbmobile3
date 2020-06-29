import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

List<UsuarioQuadroModel> lista = <UsuarioQuadroModel>[
  UsuarioQuadroModel(
    urlImagem: "",
    nome: "Mateus",
  ),
  UsuarioQuadroModel(
    nome: "Ana",
    urlImagem: "",
  ),
  UsuarioQuadroModel(
    nome: "Aline",
    urlImagem: "",
  ),
  UsuarioQuadroModel(
    nome: "Lucas",
    urlImagem: "",
  ),
];

class ListaUsuariosModal extends StatefulWidget {
  final bool selecaoMultipla;

  const ListaUsuariosModal({Key key, @required this.selecaoMultipla})
      : super(key: key);

  @override
  _ListaUsuariosModalState createState() => _ListaUsuariosModalState();
}

class _ListaUsuariosModalState extends State<ListaUsuariosModal> {
  // Variavel selecao usuario unico : marca posicao do usario na lista
  int botaoradioSelecionado;
  // Variavel selecao Multiplos usuarios : Lista de true ou false que determina que usario foi selecionado 
  List<bool> mapaUsuarios;

  @override
  void initState() {
    // Preenchimento da lista de usuario, usa posicao do usuario pra referenciar na posicao da lista
    if (this.widget.selecaoMultipla) {
      mapaUsuarios = List<bool>();
      lista.forEach(
        (element) {
          mapaUsuarios.add(false);
        },
      );
    }
    super.initState();
  }

  // RETORNOS DO WIDGET

  retornoUsuarioUnico() {
    // Retorno do usuario selecionado
    print("O usario selecionado foi ${lista[botaoradioSelecionado].nome}");
  }

  retornoMultiplosUsuarios() {  
    // Retornar lista de usuarios selecionados em lista mapaUsuarios
  }

  @override
  Widget build(BuildContext context) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        color: PmsbColors.navbar,
        height: 600.0,
        width: 400.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 10,
                ),
                Container(
                  child: Text("Selecione a equipe",
                      style: PmsbStyles.textoPrimario),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Container(
                color: Colors.white24,
                height: 1,
                width: 300,
              ),
            ),
            Expanded(
              child: ListView(
                children: gerarListaUsuarioWidet(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: PmsbColors.cor_destaque,
                  onPressed: () {
                    this.widget.selecaoMultipla
                        ? retornoMultiplosUsuarios()
                        : retornoUsuarioUnico();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Salvar",
                      style: PmsbStyles.textoSecundario,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
    return dialogWithImage;
  }

  List<Widget> gerarListaUsuarioWidet() {
    List<Widget> listaWidget = List<Widget>();

    for (UsuarioQuadroModel usuario in lista) {
      listaWidget.add(this.widget.selecaoMultipla
          ? addUseMultiplo(usuario)
          : addUserUnico(usuario));
    }
    return listaWidget;
  }

  addUserUnico(UsuarioQuadroModel usuario) {
    return RadioListTile(
      title: Text(
        usuario.nome,
        style: PmsbStyles.textoPrimario,
      ),
      secondary: CircleAvatar(
        backgroundImage: NetworkImage(usuario.urlImagem),
        backgroundColor: Colors.lightBlue[100],
        child: Text((usuario.nome[0] + usuario.nome[1]).toUpperCase()),
      ),
      value: lista.indexOf(usuario),
      groupValue: botaoradioSelecionado,
      activeColor: PmsbColors.cor_destaque,
      onChanged: (val) {
        setBotaoRadioSelecionado(val);
      },
    );
  }

  addUseMultiplo(UsuarioQuadroModel usuario) {
    int pos = (lista.indexOf(usuario));
    return CheckboxListTile(
      value: this.mapaUsuarios[pos],
      title: Text(usuario.nome),
      onChanged: (bool newValue) {
        setState(() {
          this.mapaUsuarios[pos] = newValue;
        });
      },
      secondary: CircleAvatar(
        backgroundImage: NetworkImage(usuario.urlImagem),
        backgroundColor: Colors.lightBlue[100],
        child: Text((usuario.nome[0] + usuario.nome[1]).toUpperCase()),
      ),
    );
  }

  setBotaoRadioSelecionado(int val) {
    setState(() {
      botaoradioSelecionado = val;
    });
  }
}
