import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class GeradorMdService {
  static generateMdFromUsuarioModel(UsuarioModel usuarioModel) {
    return """
${usuarioModel.nome}
====================================================

![alt text](${usuarioModel.foto.url})

### Id: ${usuarioModel.id}
### Celular: ${usuarioModel.celular}
### Email: ${usuarioModel.email}
### Eixo: ${usuarioModel.eixoID.nome}

## Perfil em construção
""";
  }

  static generateMdFromNoticiaModelList(List<NoticiaModel> noticiaModelList) {
    String texto = '';
    noticiaModelList.forEach((noticia) {
      texto += """
# Noticias  Publicadas

## ${noticia.titulo}
id: ${noticia.id}

${noticia.textoMarkdown}

---
""";
    });
    return texto;
  }

  static generateMdFromQuestionarioModel(
      QuestionarioModel questionarioModel) async {
    final fsw.Firestore _firestore = Bootstrap.instance.firestore;
    StringBuffer texto = new StringBuffer();
    StringBuffer escolhaList = new StringBuffer();
    StringBuffer requisitoList = new StringBuffer();
    int contador = 1;
    texto.writeln("""
# Questionário: ${questionarioModel.nome}

<sub>Questionário id: ${questionarioModel.id}</sub>

Último editor: ${questionarioModel.editou.nome}

Em: ${questionarioModel.modificado.toDate()}

Lista de perguntas: 

---
---

""");
    final perguntasRef = _firestore
        .collection(PerguntaModel.collection)
        .where("questionario.id", isEqualTo: questionarioModel.id)
        .orderBy("ordem", descending: false);

    final fsw.QuerySnapshot perguntasSnapshot =
        await perguntasRef.getDocuments();
    final perguntasList =
        perguntasSnapshot.documents.map((fsw.DocumentSnapshot doc) {
      return PerguntaModel(id: doc.documentID).fromMap(doc.data);
    }).toList();

    // perguntasList.forEach((pergunta) {
    for (var pergunta in perguntasList) {
      escolhaList.clear();
      requisitoList.clear();
      // Imprimindo as escolhas
      if (pergunta.escolhas != null) {
        escolhaList.writeln("#### Escolhas");
        pergunta.escolhas?.forEach((k, v) {
          escolhaList.writeln("""
1. **${v.texto}** <sub>(id: ${k})</sub>
""");
        });
      } //fim escolhas

      //+++ Imprimindo os requisitos
      if (pergunta.requisitos != null) {
        requisitoList.writeln("#### Requisitos");

        for (var perReq in pergunta.requisitos.values) {
//           requisitoList.writeln("""
// 1. reqUid${perReq.referencia}
// """);

          final perguntasReqRef = _firestore
              .collection(PerguntaModel.collection)
              .where("questionario.id", isEqualTo: questionarioModel.id)
              .where("referencia", isEqualTo: perReq.referencia);
          final fsw.QuerySnapshot perguntasDoReqSnapshot =
              await perguntasReqRef.getDocuments();
          final perguntasReqList =
              perguntasDoReqSnapshot.documents.map((fsw.DocumentSnapshot doc) {
            return PerguntaModel(id: doc.documentID).fromMap(doc.data);
          }).toList();

          perguntasReqList.forEach((pergReq) {
            requisitoList.writeln(
                "- ${pergReq.titulo} <sub>(id: ${pergReq.id} ref: ${pergReq.referencia})</sub>");
          });
        }
      } //--- Imprimindo os requisitos

      texto.writeln("""
## ${contador} - ${pergunta.titulo}

### ${pergunta.textoMarkdown}

${escolhaList}

${requisitoList}


Pergunta tipo: ${pergunta.tipo.nome}. <sub>Pergunta id: ${pergunta.id} ordem: ${pergunta.ordem}</sub>

-----

""");
      contador++;
    } //Fim pergunta
    return texto.toString();
  }
}
