import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:queries/collections.dart';

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
// Última edição em: ${questionarioModel.modificado.toDate()}

    texto.writeln("""
# ${questionarioModel.nome}

Último editor: ${questionarioModel.editou.nome}


Uso do sistema: Questionário id: ${questionarioModel.id}

Lista de perguntas: 

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

      // +++ escolhas
      escolhaList.clear();
      if (pergunta.tipo.id == 'escolhaunica' ||
          pergunta.tipo.id == 'escolhamultipla') {
        if (pergunta.escolhas != null && pergunta.escolhas.isNotEmpty) {
          var dicEscolhas = Dictionary.fromMap(pergunta.escolhas);
          var escolhasAscOrder = dicEscolhas
              // Sort Ascending order by value ordem
              .orderBy((kv) => kv.value.ordem)
              // Sort Descending order by value ordem
              // .orderByDescending((kv) => kv.value.ordem)
              .toDictionary$1((kv) => kv.key, (kv) => kv.value);
          print(escolhasAscOrder.toMap());
          Map<String, Escolha> escolhaMap = escolhasAscOrder.toMap();
          escolhaList.writeln("#### ${pergunta.tipo.nome}");
          escolhaMap?.forEach((k, v) {
            escolhaList.writeln("""
1. **${v.texto}**
""");
          });
        }
      }
      // --- escolhas

      //+++ requisitos
      requisitoList.clear();
      if (pergunta.requisitos != null && pergunta.requisitos.isNotEmpty) {
        requisitoList.writeln("#### Requisitos");
        for (var perguntaRequisito in pergunta.requisitos.values) {
          if (perguntaRequisito.label != null) {
            requisitoList.writeln("""
- ${perguntaRequisito.label}.
            """);
          }
          if (perguntaRequisito.escolha != null) {
            requisitoList.writeln("""
- ${perguntaRequisito.escolha.label} (${perguntaRequisito.escolha.marcada}).
            """);
          }
        }
      }
      //--- requisitos

      texto.writeln("""
## ${contador} - ${pergunta.titulo}

### ${pergunta.textoMarkdown}

${escolhaList}

${requisitoList}


Uso do sistema: Pergunta Tipo: ${pergunta.tipo.nome}. Pergunta id: ${pergunta.id}

-----

""");
      contador++;
    } //Fim pergunta
    return texto.toString();
  }


  static generateMdFromQuestionarioAplicadoModel(
      QuestionarioAplicadoModel questionarioAplicadoModel) async {
    final fsw.Firestore _firestore = Bootstrap.instance.firestore;
    StringBuffer texto = StringBuffer();
    StringBuffer escolhaList = StringBuffer();
    StringBuffer imagem = StringBuffer();
    StringBuffer arquivo = StringBuffer();
    StringBuffer coordenada = StringBuffer();
    int contador = 1;
// - Modificado: ${questionarioAplicadoModel.modificado.toDate()}

    texto.writeln("""
# Questionário Aplicado : ${questionarioAplicadoModel.nome}

- Questionário referencia: ${questionarioAplicadoModel.referencia}
- Questionário eixo: ${questionarioAplicadoModel.eixo.nome}
- Questionário setor: ${questionarioAplicadoModel.setorCensitarioID.nome}
- Aplicador: ${questionarioAplicadoModel.aplicador.nome}

Lista de perguntas: 

---
""");

    final perguntasRef = _firestore
        .collection(PerguntaAplicadaModel.collection)
        .where("questionario.id", isEqualTo: questionarioAplicadoModel.id)
        .orderBy("ordem", descending: false);

    final fsw.QuerySnapshot perguntasSnapshot =
        await perguntasRef.getDocuments();
    final perguntasList =
        perguntasSnapshot.documents.map((fsw.DocumentSnapshot doc) {
      return PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data);
    }).toList();

    for (var pergunta in perguntasList) {
      //+++ imagem
      imagem.clear();
      if (pergunta.tipo.id == 'imagem') {
        if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
          imagem.writeln("#### Imagens");
          pergunta.arquivo?.forEach((k, v) {
            imagem.write("""
[${v.nome}](${v.url})

![${v.nome}](${v.url})
""");
          });
        }
      }
      //--- imagem
      //+++ arquivo
      arquivo.clear();
      if (pergunta.tipo.id == 'arquivo') {
        if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
          arquivo.writeln("#### Arquivos");
          pergunta.arquivo?.forEach((k, v) {
            arquivo.write("""
[${v.nome}](${v.url})
""");
          });
        }
      }
      //--- arquivo
      //+++ coordenada
      coordenada.clear();
      if (pergunta.tipo.id == 'coordenada') {
        if (pergunta.coordenada != null && pergunta.coordenada.isNotEmpty) {
          coordenada.writeln("#### Arquivos");
          pergunta.coordenada?.forEach((coord) {
            coordenada.write("""
- (${coord.latitude},${coord.longitude})
""");
          });
        }
      }
      //--- coordenada
      //+++ escolhas
      escolhaList.clear();
      if (pergunta.tipo.id == 'escolhaunica' ||
          pergunta.tipo.id == 'escolhamultipla') {
        if (pergunta.escolhas != null && pergunta.escolhas.isNotEmpty) {

 var dicEscolhas = Dictionary.fromMap(pergunta.escolhas);
          var escolhasAscOrder = dicEscolhas
              // Sort Ascending order by value ordem
              .orderBy((kv) => kv.value.ordem)
              // Sort Descending order by value ordem
              // .orderByDescending((kv) => kv.value.ordem)
              .toDictionary$1((kv) => kv.key, (kv) => kv.value);
          print(escolhasAscOrder.toMap());
          Map<String, Escolha> escolhaMap = escolhasAscOrder.toMap();

          escolhaList.writeln("#### ${pergunta.tipo.nome}");
          escolhaMap.forEach((k, v) {
            if (v.marcada) {
              escolhaList.write("""
[x] ${v.texto} 
""");
            } else {
              escolhaList.write("""
[ ] ${v.texto} 
""");
            }
          });
        }
      }
      //--- escolhas

// - Pergunta id: ${pergunta.id}
      texto.writeln("""
## ${contador} - ${pergunta.titulo}
${pergunta.textoMarkdown}
${escolhaList}
${imagem}
${arquivo}
${coordenada}

Obs: ${pergunta.observacao}.  

Informações: Tipo: ${pergunta.tipo.nome}. Id: ${pergunta.id} . 

---
        """);
      contador++;
    }
    //Fim pergunta
    return texto.toString();
  }
}

// final perguntasRef = _firestore
//         .collection(PerguntaModel.collection)
//         .where("questionario.id", isEqualTo: questionarioAplicadoModel.id)
//         .orderBy("ordem", descending: false);

//     final fsw.QuerySnapshot perguntasSnapshot =
//         await perguntasRef.getDocuments();
//     final perguntasList =
//         perguntasSnapshot.documents.map((fsw.DocumentSnapshot doc) {
//       return PerguntaModel(id: doc.documentID).fromMap(doc.data);
//     }).toList();

//     // perguntasList.forEach((pergunta) {
//     for (var pergunta in perguntasList) {
//       escolhaList.clear();
//       requisitoList.clear();
//       // Imprimindo as escolhas
//       if (pergunta.escolhas != null) {
//         escolhaList.writeln("#### Escolhas");
//         pergunta.escolhas?.forEach((k, v) {
//           escolhaList.writeln("""
// 1. **${v.texto}**
// """);
//         });
//       } //fim escolhas

//       //+++ Imprimindo os requisitos
//       if (pergunta.requisitos != null) {
//         requisitoList.writeln("#### Requisitos");

//         for (var perReq in pergunta.requisitos.values) {
//           String label;
//           label=perReq?.escolha?.label ?? "Pergunta.";
// //           requisitoList.writeln("""
// // - ${perReq.label}
// // """);

//           final perguntasReqRef = _firestore
//               .collection(PerguntaModel.collection)
//               .where("questionario.id", isEqualTo: questionarioAplicadoModel.id)
//               .where("referencia", isEqualTo: perReq.referencia);
//           final fsw.QuerySnapshot perguntasDoReqSnapshot =
//               await perguntasReqRef.getDocuments();
//           final perguntasReqList =
//               perguntasDoReqSnapshot.documents.map((fsw.DocumentSnapshot doc) {
//             return PerguntaModel(id: doc.documentID).fromMap(doc.data);
//           }).toList();

//           perguntasReqList.forEach((pergReq) {
//             requisitoList.writeln("""
// - ${pergReq.titulo}.
//   - ${label}
// """);
//           });
//         }
//       } //--- Imprimindo os requisitos

//       texto.writeln("""
// ## ${contador} - ${pergunta.titulo}

// ### ${pergunta.textoMarkdown}

// ${escolhaList}

// ${requisitoList}

// Pergunta tipo: ${pergunta.tipo.nome}. Ordem: ${pergunta.ordem}

// -----

// """);
//       contador++;
//     }
