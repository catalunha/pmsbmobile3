import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';


/// classe representa as possibilidade de eixos para o usuario não é mapeada para documentos de uma collection
class PossivelEixoAtual{
  final String eixoId;
  final String eixoNome;

  PossivelEixoAtual({
    String eixoId,
    String eixoNome,
  })
      : assert(eixoId != null),
        assert(eixoNome != null),
        this.eixoId = eixoId,
        this.eixoNome = eixoNome;
}


class UsuarioModel extends FirestoreModel{

  static final String collection = "Usuario";

  String nomeCompleto;

  String nomeProjeto;

  String email;

  String celular;

  String cargoId;

  String cargoNome; //campo duplicado

  String eixoId;

  String eixoNome; // campo duplicado

  String eixoAtualId;

  String eixoAtualNome; // campo duplicado

  List<PossivelEixoAtual> listaPossivelEixoAtual;

  String setorCensitarioId;

  String setorCensitarioNome;

  String imagemPerfilId; //Arquivo

  String imagemPerfilUrl; //campo duplicado

  String get safeImagemPerfilUrl {
    if(isURL(imagemPerfilUrl)) return imagemPerfilUrl;
    return "https://pingendo.github.io/pingendo-bootstrap/assets/user_placeholder.png";
  }

  String get safeNomeProjeto => nomeProjeto != null? nomeProjeto : "estranho";
  List<String> rotasApp;

  UsuarioModel({
    String id,
    this.nomeCompleto,
    this.nomeProjeto,
    this.email,
    this.celular,
    this.cargoId,
    this.cargoNome,
    this.eixoId,
    this.eixoNome,
    this.eixoAtualId,
    this.eixoAtualNome,
    this.listaPossivelEixoAtual,
    this.setorCensitarioId,
    this.setorCensitarioNome,
    this.imagemPerfilId,
    this.imagemPerfilUrl,
    this.rotasApp,
  }):super(id);


  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map["id"];
    if(map.containsKey("nomeCompleto")) nomeCompleto = map["nomeCompleto"];
    if(map.containsKey("email")) email = map["email"];
    if(map.containsKey("celular")) celular = map["celular"];
    if(map.containsKey("cargoId")) cargoId = map["cargoId"];
    if(map.containsKey("eixoNome")) eixoNome = map["eixoNome"];
    if(map.containsKey("eixoAtualId")) eixoAtualId = map["eixoAtualId"];
    if(map.containsKey("eixoAtualNome")) eixoAtualNome = map["eixoAtualNome"];

    if(map.containsKey("setorCensitarioId")) setorCensitarioId = map["setorCensitarioId"];
    if(map.containsKey("setorCensitarioNome")) setorCensitarioNome = map["setorCensitarioNome"];
    if(map.containsKey("imagemPerfilId")) imagemPerfilId = map["imagemPerfilId"];
    if(map.containsKey("imagemPerfilUrl")) imagemPerfilUrl = map["imagemPerfilUrl"];
    if(map.containsKey("rotasApp")) rotasApp = map["rotasApp"];

    if(map.containsKey("listaPossivelEixoAtual")){
      if(map["listaPossivelEixoAtual"] is List) {
        listaPossivelEixoAtual = List<PossivelEixoAtual>();
        List<
            Map<String, String>> possiveisEixos = map["listaPossivelEixoAtual"];
        for (int index = 0; index < possiveisEixos.length; index++) {
          if (possiveisEixos[index].containsKey("eixoId") &&
              possiveisEixos[index].containsKey("eixoNome")) {
            listaPossivelEixoAtual.add(PossivelEixoAtual(
              eixoId: possiveisEixos[index]["eixoId"],
              eixoNome: possiveisEixos[index]["eixoNome"],
            ));
          }
        }
      }
    }

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "nomeCompleto":nomeCompleto,
      "nomeProjeto":nomeProjeto,
      "email":email,
      "celular":celular,
      "cargoId":cargoId,
      "cargoNome":cargoNome,
      "eixoId":eixoId,
      "eixoNome":eixoNome,
      "eixoAtualId":eixoAtualId,
      "eixoAtualNome":eixoAtualNome,
      "listaPossivelEixoAtual":listaPossivelEixoAtual,
      "setorCensitarioId":setorCensitarioId,
      "setorCensitarioNome":setorCensitarioNome,
      "imagemPerfilId":imagemPerfilId,
      "imagemPerfilUrl":imagemPerfilUrl,
      "rotasApp":rotasApp,
    };
  }

}