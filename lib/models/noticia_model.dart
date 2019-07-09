import 'package:pmsbmibile3/models/base_model.dart';

enum OpcaoDestinatario {Todos, Eixo, Cargo, Usuario}

class Destinatario{
  final OpcaoDestinatario opcao;
  final String destinatarioId;
  Destinatario({this.opcao, this.destinatarioId});
}

class NoticiaModel extends FirestoreModel{
  static final String collection = "Noticia";

  String userId;

  String titulo;
  int numero;
  DateTime dataPublicacao;
  DateTime dataCriacao;
  String conteudoMarkdown;
  List<Destinatario> destinatarios;

  NoticiaModel({
    String id,
    this.userId,
    this.titulo,
    this.numero,
    this.dataPublicacao,
    this.dataCriacao,
    this.conteudoMarkdown,
    this.destinatarios,
  }) : super(id);

  @override
  NoticiaModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map["id"];
    if(map.containsKey("userId")) userId = map["userId"];
    if(map.containsKey("titulo")) titulo = map["titulo"];
    if(map.containsKey("numero")) numero = map["numero"];
    if(map.containsKey("dataPublicacao")) dataPublicacao = map["dataPublicacao"];
    if(map.containsKey("dataCriacao")) dataCriacao = map["dataCriacao"];
    if(map.containsKey("conteudoMarkdown")) conteudoMarkdown = map["conteudoMarkdown"];
    if(map.containsKey("destinatarios") && map["destinatarios"].runtimeType == List){
      //assert(map["destinatarios"].runtimeType == List);
      destinatarios = List<Destinatario>();
      var lista = map["destinatarios"] as List<Map<String, dynamic>>;
      for (int index = 0; index < lista.length; index++){
        if(lista[index].containsKey("opcao") && lista[index].containsKey("destinatarioId")){
          destinatarios.add(Destinatario(opcao: lista[index]["opcao"], destinatarioId: lista[index]["destinatarioId"]));
        }
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId":userId,
      "titulo":titulo,
      "numero":numero,
      "dataPublicacao":dataPublicacao,
      "dataCriacao":dataCriacao,
      "conteudoMarkdown":conteudoMarkdown,
      "destinatarios":destinatarios,
    };
  }
}