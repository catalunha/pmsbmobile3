import 'package:pmsbmibile3/models/base_model.dart';

class IAConfigModel extends FirestoreModel {
  static final String collection = "IAConfig";

  int numero;
  String simNome;
  String parcialNome;
  String naoNome;
  String azul;
  String vermelho;
  String verde;
  String lilas;
  String observacoes;
  int simPontos;
  int parcialPontos;
  int naoPontos;
  int itensNumero;

  IAConfigModel({
    String id,
    this.numero,
    this.simNome,
    this.parcialNome,
    this.naoNome,
    this.azul,
    this.vermelho,
    this.verde,
    this.lilas,
    this.observacoes,
    this.simPontos,
    this.parcialPontos,
    this.naoPontos,
    this.itensNumero,
  }) : super(id);

  @override
  IAConfigModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('simNome')) simNome = map['simNome'];
    if (map.containsKey('parcialNome')) parcialNome = map['parcialNome'];
    if (map.containsKey('naoNome')) naoNome = map['naoNome'];
    if (map.containsKey('azul')) azul = map['azul'];
    if (map.containsKey('vermelho')) vermelho = map['vermelho'];
    if (map.containsKey('verde')) verde = map['verde'];
    if (map.containsKey('lilas')) lilas = map['lilas'];
    if (map.containsKey('observacoes')) observacoes = map['observacoes'];
    if (map.containsKey('simPontos')) simPontos = map['simPontos'];
    if (map.containsKey('parcialPontos')) parcialPontos = map['parcialPontos'];
    if (map.containsKey('naoPontos')) naoPontos = map['naoPontos'];
    if (map.containsKey('itensNumero')) itensNumero = map['itensNumero'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (numero != null) data['numero'] = this.numero;
    if (simNome != null) data['simNome'] = this.simNome;
    if (parcialNome != null) data['parcialNome'] = this.parcialNome;
    if (naoNome != null) data['naoNome'] = this.naoNome;
    if (azul != null) data['azul'] = this.azul;
    if (vermelho != null) data['vermelho'] = this.vermelho;
    if (verde != null) data['verde'] = this.verde;
    if (lilas != null) data['lilas'] = this.lilas;
    if (observacoes != null) data['observacoes'] = this.observacoes;
    if (simPontos != null) data['simPontos'] = this.simPontos;
    if (parcialPontos != null) data['parcialPontos'] = this.parcialPontos;
    if (naoPontos != null) data['naoPontos'] = this.naoPontos;
    if (itensNumero != null) data['itensNumero'] = this.itensNumero;
    return data;
  }
}
