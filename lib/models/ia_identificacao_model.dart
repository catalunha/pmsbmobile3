import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class IAIdentificacaoModel extends FirestoreModel {
  static final String collection = "IAIdentificacao";
  String proponente;
  String municipioIntegranteTED;
  String objeto;
  String processoTED;
  String processoDeProjetoN;
  String vigenciaAnualInicio;
  String vigenciaAnualFim;
  String dataInicioExecucao;
  String previsaoConclusao;
  String prazoFinalPrestacaoContas;

  Map<String, Celula> celula;

  IAIdentificacaoModel({
    String id,
    this.proponente,
    this.municipioIntegranteTED,
    this.objeto,
    this.processoTED,
    this.processoDeProjetoN,
    this.celula,
  }) : super(id);

  @override
  IAIdentificacaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('proponente')) proponente = map['proponente'];
    if (map.containsKey('municipioIntegranteTED'))
      municipioIntegranteTED = map['municipioIntegranteTED'];
    if (map.containsKey('objeto')) objeto = map['objeto'];
    if (map.containsKey('processoTED')) processoTED = map['processoTED'];
    if (map.containsKey('processoDeProjetoN'))
      processoDeProjetoN = map['processoDeProjetoN'];
    if (map.containsKey('vigenciaAnualInicio'))
      vigenciaAnualInicio = map['vigenciaAnualInicio'];
    if (map.containsKey('vigenciaAnualFim'))
      vigenciaAnualFim = map['vigenciaAnualFim'];
    if (map.containsKey('dataInicioExecucao'))
      dataInicioExecucao = map['dataInicioExecucao'];
    if (map.containsKey('previsaoConclusao'))
      previsaoConclusao = map['previsaoConclusao'];
    if (map.containsKey('prazoFinalPrestacaoContas'))
      prazoFinalPrestacaoContas = map['prazoFinalPrestacaoContas'];

    if (map["celula"] is Map) {
      celula = Map<String, Celula>();
      for (var item in map["celula"].entries) {
        celula[item.key] = Celula.fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (proponente != null) data['proponente'] = this.proponente;
    if (municipioIntegranteTED != null)
      data['municipioIntegranteTED'] = this.municipioIntegranteTED;
    if (objeto != null) data['objeto'] = this.objeto;
    if (processoTED != null) data['processoTED'] = this.processoTED;
    if (processoDeProjetoN != null)
      data['processoDeProjetoN'] = this.processoDeProjetoN;
    if (vigenciaAnualInicio != null)
      data['vigenciaAnualInicio'] = this.vigenciaAnualInicio;
    if (vigenciaAnualFim != null)
      data['vigenciaAnualFim'] = this.vigenciaAnualFim;
    if (dataInicioExecucao != null)
      data['dataInicioExecucao'] = this.dataInicioExecucao;
    if (previsaoConclusao != null)
      data['previsaoConclusao'] = this.previsaoConclusao;
    if (prazoFinalPrestacaoContas != null)
      data['prazoFinalPrestacaoContas'] = this.prazoFinalPrestacaoContas;

    if (celula != null && celula is Map) {
      data["celula"] = Map<String, dynamic>();
      for (var item in celula.entries) {
        data["celula"][item.key] = item.value.toMap();
      }
    }
    return data;
  }
}
