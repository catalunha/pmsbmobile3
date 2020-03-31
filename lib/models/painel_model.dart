import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class PainelModel extends FirestoreModel {
  static final String collection = "Painel";

    String nome;

    /// Os tipos pode ser: texto | numero | booleano | urlimagem | urlarquivo
    String tipo;

    UsuarioID usuarioQEditou;
    UsuarioID usuarioQVaiResponder;
    EixoID eixo;
    ProdutoFunasaID produto;
    dynamic modificado;

  PainelModel(
      {String id,
      this.nome,
      this.tipo,
      this.usuarioQEditou,
      this.usuarioQVaiResponder,
      this.eixo,
      this.produto,
      this.modificado})
      : super(id);

  PainelModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('tipo')) tipo = map['tipo'];

    modificado = map.containsKey('modificado') && map['modificado'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['modificado'].millisecondsSinceEpoch)
        : null;

    usuarioQEditou = map.containsKey('usuarioID') && map['usuarioID'] != null
        ? new UsuarioID.fromMap(map['usuarioID'])
        : null;

    usuarioQVaiResponder = map.containsKey('usuarioQVaiResponder') &&
            map['usuarioQVaiResponder'] != null
        ? new UsuarioID.fromMap(map['usuarioQVaiResponder'])
        : null;

    eixo = map.containsKey('eixo') && map['eixo'] != null
        ? new EixoID.fromMap(map['eixo'])
        : null;
    produto = map.containsKey('produto') && map['produto'] != null
        ? new ProdutoFunasaID.fromMap(map['produto'])
        : null;

    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (tipo != null) data['tipo'] = this.tipo;
    if (modificado != null) data['modificado'] = modificado;

    if (this.usuarioQEditou != null) {
      data['usuarioID'] = this.usuarioQEditou.toMap();
    }
    if (this.usuarioQVaiResponder != null) {
      data['usuarioQVaiResponder'] = this.usuarioQVaiResponder.toMap();
    }
    if (this.eixo != null) {
      data['eixo'] = this.eixo.toMap();
    }
    if (this.produto != null) {
      data['produto'] = this.produto.toMap();
    }
    return data;
  }
}
