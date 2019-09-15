import 'dart:io';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:queries/collections.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:image/image.dart' as image;

class PdfCreateService {
  static fsw.Firestore _firestore = Bootstrap.instance.firestore;

  static createPdfForQuestionarioAplicadoModel(
      QuestionarioAplicadoModel questionarioAplicado) async {
    print('criando');
    final Document pdf = Document();
    // pdf.addPage(Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (Context context) {
    //       return Center(
    //         child: Text("Hello World"),
    //       ); // Center
    //     }));

    final perguntasRef = _firestore
        .collection(PerguntaAplicadaModel.collection)
        .where("questionario.id", isEqualTo: questionarioAplicado.id)
        .orderBy("ordem", descending: false);

    final fsw.QuerySnapshot perguntasSnapshot =
        await perguntasRef.getDocuments();
    final perguntasList =
        perguntasSnapshot.documents.map((fsw.DocumentSnapshot doc) {
      return PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data);
    }).toList();

    List<Map<String, dynamic>> perguntaAplicadaList =
        List<Map<String, dynamic>>();

    for (var pergunta in perguntasList) {
      Map<String, dynamic> perguntaAplicada = Map<String, dynamic>();

      perguntaAplicada['pergunta.ordem'] = pergunta.ordem;
      perguntaAplicada['pergunta.titulo'] = pergunta.titulo;
      perguntaAplicada['pergunta.textoMarkdown'] = pergunta.textoMarkdown;
      perguntaAplicada['pergunta.observacao'] = pergunta.observacao;
      perguntaAplicada['pergunta.tipo.nome'] = pergunta.tipo.nome;
      perguntaAplicada['pergunta.tipo'] = pergunta.tipo.id;

      perguntaAplicada['pergunta.id'] = pergunta.id;
      perguntaAplicada['pergunta.temPendencias'] =
          pergunta.temPendencias ? "Tem pendências" : "Não tem pendências";
      perguntaAplicada['pergunta.foiRespondida'] =
          pergunta.foiRespondida ? "Foi respondida" : "Não foi respondida";
      perguntaAplicada['pergunta.temRespostaValida'] =
          pergunta.temRespostaValida ? "Tem informação válida" : "";

      //+++ texto
      if (pergunta.tipo.id == 'texto') {
        if (pergunta.texto != null) {
          perguntaAplicada['pergunta.texto'] = pergunta.texto;
        } else {
          perguntaAplicada['pergunta.texto'] = 'Nada informado.';
        }
      }
      //--- texto
      //+++ numero
      if (pergunta.tipo.id == 'numero') {
        if (pergunta.numero != null) {
          perguntaAplicada['pergunta.numero'] = pergunta.numero.toString();
        } else {
          perguntaAplicada['pergunta.numero'] = 'Nada informado.';
        }
      }
      //--- numero
      //+++ imagem
      if (pergunta.tipo.id == 'imagem') {
        if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
          Map<String, String> anexo = Map<String, String>();
          for (var item in pergunta.arquivo.entries) {
            anexo[item.key] = item.value.url;
            // perguntaAplicada['pergunta.imagem'][item.key] = item.value.url;
          }
          perguntaAplicada['pergunta.imagem'] = anexo;
        } else {
          perguntaAplicada['pergunta.imagem'] = 'Nada informado.';
        }
      }
      //--- imagem
      //+++ arquivo
      if (pergunta.tipo.id == 'arquivo') {
        if (pergunta.arquivo != null && pergunta.arquivo.isNotEmpty) {
          Map<String, String> anexo = Map<String, String>();
          for (var item in pergunta.arquivo.entries) {
            anexo[item.key] = item.value.url;
            // perguntaAplicada['pergunta.arquivo'][item.key] = item.value.url;
          }
          perguntaAplicada['pergunta.arquivo'] = anexo;
        } else {
          perguntaAplicada['pergunta.arquivo'] = 'Nada informado.';
        }
      }
      //--- arquivo
      //+++ coordenada
      if (pergunta.tipo.id == 'coordenada') {
        if (pergunta.coordenada != null && pergunta.coordenada.isNotEmpty) {
          Map<String, String> anexo = Map<String, String>();
          int contador = 1;
          for (var item in pergunta.coordenada) {
            anexo[contador.toString()] = '(${item.latitude},${item.longitude})';
            contador++;
          }
          perguntaAplicada['pergunta.coordenada'] = anexo;
        } else {
          perguntaAplicada['pergunta.coordenada'] = 'Nada informado.';
        }
      }
      //--- coordenada
      //+++ escolhas
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
          Map<String, String> anexo = Map<String, String>();
          int contador = 1;
          for (var item in escolhaMap.entries) {
            if (item?.key != null) {
              String marcada = item.value.marcada ? 'X' : '';
              anexo[contador.toString()] = '[${marcada}] ${item.value.texto}';
              contador++;
              // perguntaAplicada['pergunta.escolha'][item.key] =
              //     '[${marcada}] ${item.value.texto}';
            }
          }
          perguntaAplicada['pergunta.escolha'] = anexo;
        } else {
          perguntaAplicada['pergunta.escolha'] = 'Nada informado.';
        }
      }
      //--- escolhas
      perguntaAplicadaList.add(perguntaAplicada);
    }

    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Relatorio de questionário aplicado',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text(
                  'Pagina ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) {
          List<Widget> itens = List<Widget>();

          itens.add(Header(
              level: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Relatório de Questionário Aplicado',
                        textScaleFactor: 2),
                    // FlutterLogo()
                  ])));

          itens.add(Header(
              level: 1, text: 'Questionário: ${questionarioAplicado.nome}'));
          itens.add(Header(
              level: 2,
              text: 'Referência: ${questionarioAplicado.referencia}'));
          itens.add(Paragraph(
              text: 'Alguns dados importantes sobre este questionário.'));
          itens.add(Bullet(text: 'Eixo: ${questionarioAplicado.eixo.nome}'));
          itens.add(Bullet(
              text: 'Setor: ${questionarioAplicado.setorCensitarioID.nome}'));
          itens.add(Bullet(
              text: 'Aplicador: ${questionarioAplicado.aplicador.nome}'));
          itens.add(Bullet(
              text: 'Aplicado: ${questionarioAplicado.aplicado.toDate()}'));
          itens.add(Bullet(text: 'id: ${questionarioAplicado.id}'));
          // itens.add(Header(level: 1, text: 'Lista das Perguntas'));

          for (var pergunta in perguntaAplicadaList) {
            itens.add(Header(
                level: 1,
                text:
                    'Pergunta ${pergunta['pergunta.ordem']} - ${pergunta['pergunta.titulo']}'));
            itens.add(Header(
                level: 2, text: '${pergunta['pergunta.textoMarkdown']}'));
            itens.add(Paragraph(
                text: 'Resposta tipo: ${pergunta['pergunta.tipo.nome']}.'));

            if (pergunta['pergunta.tipo'] == 'texto') {
              itens.add(Paragraph(text: '${pergunta['pergunta.texto']}'));
            }
            if (pergunta['pergunta.tipo'] == 'numero') {
              itens.add(Paragraph(text: '${pergunta['pergunta.numero']}'));
            }
            if (pergunta['pergunta.tipo'] == 'arquivo') {
              if (pergunta['pergunta.arquivo'].runtimeType == Map()) {
                Map<String, dynamic> anexo = pergunta['pergunta.arquivo'];
                for (var item in anexo.entries) {
                  itens.add(Bullet(text: '${item.value}'));
                  // itens.add(AnnotationLink('${item.value}'));
                }
              } else {
                itens.add(Paragraph(text: '${pergunta['pergunta.arquivo']}'));
              }
            }
            if (pergunta['pergunta.tipo'] == 'imagem') {
              if (pergunta['pergunta.imagem'].runtimeType != String) {
                Map<String, dynamic> anexo = pergunta['pergunta.imagem'];
                for (var item in anexo.entries) {
                  itens.add(Bullet(text: '${item.value}'));

                  // final img =
                  //     image.decodeImage(File(item.value).readAsBytesSync());
                  // final pdfImage = PdfImage(
                  //   pdf.document,
                  //   image: img.data.buffer.asUint8List(),
                  //   width: img.width,
                  //   height: img.height,
                  // );
                  // itens.add(Center(
                  //   child: Image(pdfImage),
                  // ));
                  // itens.add(AnnotationLink('${item.value}'));
                }
              } else {
                itens.add(Paragraph(text: '${pergunta['pergunta.imagem']}'));
              }
            }

            if (pergunta['pergunta.tipo'] == 'coordenada') {
              if (pergunta['pergunta.coordenada'].runtimeType != String) {
                Map<String, dynamic> anexo = pergunta['pergunta.coordenada'];
                for (var item in anexo.entries) {
                  itens.add(Bullet(text: '${item.value}'));
                }
              } else {
                itens
                    .add(Paragraph(text: '${pergunta['pergunta.coordenada']}'));
              }
            }

           if (pergunta['pergunta.tipo'] == 'escolhaunica' ||
            pergunta['pergunta.tipo'] == 'escolhamultipla') {
              if (pergunta['pergunta.escolha'].runtimeType != String) {
                Map<String, dynamic> anexo = pergunta['pergunta.escolha'];
                for (var item in anexo.entries) {
                  itens.add(Bullet(text: '${item.value}'));
                }
              } else {
                itens
                    .add(Paragraph(text: '${pergunta['pergunta.escolha']}'));
              }
            }

                itens
                    .add(Paragraph(text: 'Observação: ${pergunta['pergunta.observacao']}'));
                itens
                    .add(Paragraph(text: 'Outras informações importantes: '));
                  itens.add(Bullet(text: '${pergunta['pergunta.foiRespondida']}'));
                  itens.add(Bullet(text: '${pergunta['pergunta.temRespostaValida']}'));
                  itens.add(Bullet(text: '${pergunta['pergunta.temPendencias']}'));
                  itens.add(Bullet(text: 'Id: ${pergunta['pergunta.id']}'));

          } // Fim perguntaAplicadaList

          // List<Widget> itens = <Widget>[
          //     Header(
          //         level: 0,
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Text('Relatório de Questionário Aplicado2',
          //                   textScaleFactor: 2),
          //               // FlutterLogo()
          //             ])),
          //     Header(level: 1, text: 'Questionario nome...'),
          //     Header(level: 2, text: 'Questionario referencia...'),
          //     Paragraph(
          //         text:
          //             'dados'),
          //     Bullet(
          //         text:
          //             'A subset of the PostScript page description programming language, for generating the layout and graphics.'),
          //     Table.fromTextArray(context: context, data: const <List<String>>[
          //       <String>['Date', 'PDF Version', 'Acrobat Version'],
          //       <String>['1993', 'PDF 1.0', 'Acrobat 1'],

          //     ]),
          //   ];

          return itens;
        }));

    print('criado ${pdf.toString()}');

    return pdf;
  }
}
