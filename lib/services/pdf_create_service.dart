import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:queries/collections.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfCreateService {
  static fsw.Firestore _firestore = Bootstrap.instance.firestore;

  static pdfwidgetForControleTarefaDoUsuario(
      {UsuarioModel usuarioModel, bool remetente, bool concluida}) async {
    fsw.Query queryTarefasDoUsuario;
    if (remetente) {
      queryTarefasDoUsuario = _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: usuarioModel.id)
          .where("setor.id", isEqualTo: usuarioModel.setorCensitarioID.id)
          .where("concluida", isEqualTo: concluida);
    } else {
      queryTarefasDoUsuario = _firestore
          .collection(ControleTarefaModel.collection)
          .where("destinatario.id", isEqualTo: usuarioModel.id)
          .where("setor.id", isEqualTo: usuarioModel.setorCensitarioID.id)
          .where("concluida", isEqualTo: concluida);
    }

    // List<Map<String, dynamic>> tarefasDoUsuarioListMap =
    //     List<Map<String, dynamic>>();

    final fsw.QuerySnapshot tarefasDoUsuarioSnapshot =
        await queryTarefasDoUsuario.getDocuments();
    final tarefaList =
        tarefasDoUsuarioSnapshot.documents.map((fsw.DocumentSnapshot doc) {
      return ControleTarefaModel(id: doc.documentID).fromMap(doc.data);
    }).toList();
    List<Widget> itemPDFList = List<Widget>();

    for (var tarefa in tarefaList) {
      // Map<String, dynamic> tarefasDoUsuarioMap = Map<String, dynamic>();
      // Detalhes da tarefa
      // tarefasDoUsuarioMap["tarefanome"] = tarefa.nome;
      itemPDFList.add(Header(level: 1, text: 'Tarefa: ${tarefa.nome}'));
      itemPDFList
          .add(Paragraph(text: 'Alguns dados importantes sobre esta tarefa.'));
      itemPDFList.add(Bullet(text: 'Setor: ${tarefa.setor.nome}'));
      itemPDFList.add(Bullet(text: 'Remetente: ${tarefa.remetente.nome}'));
      itemPDFList
          .add(Bullet(text: 'Destinatário: ${tarefa.destinatario.nome}'));
      itemPDFList.add(Bullet(text: 'Início: ${tarefa.inicio.toString()}'));
      itemPDFList.add(Bullet(text: 'Fim: ${tarefa.fim.toString()}'));
      itemPDFList
          .add(Bullet(text: 'Atualizada: ${tarefa.modificada.toString()}'));
      if (tarefa.concluida) {
        itemPDFList.add(Bullet(text: 'CONCLUÍDA: SIM'));
      } else {
        itemPDFList.add(Bullet(text: 'concluída: não'));
      }
      itemPDFList.add(Bullet(text: 'id: ${tarefa.id}'));
      itemPDFList.add(Bullet(text: 'Referencia: ${tarefa.referencia}'));

      itemPDFList.add(Paragraph(text: 'Lista de ações desta tarefa:'));
      // Descricao das ações
      final acaoQuery = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: tarefa.id)
          .orderBy("ordem", descending: false);

      final fsw.QuerySnapshot acaoSnapshot = await acaoQuery.getDocuments();
      final acaoList = acaoSnapshot.documents.map((fsw.DocumentSnapshot doc) {
        return ControleAcaoModel(id: doc.documentID).fromMap(doc.data);
      }).toList();

      int ordem = 1;
      for (var acao in acaoList) {
        if (acao.concluida) {
          itemPDFList.add(Header(
            level: 1,
            text: '[CONCLUÍDA] Ação ${ordem} : ${acao.nome}',
          ));
        } else {
          itemPDFList.add(Header(
            level: 1,
            text: 'Ação ${ordem} : ${acao.nome}',
          ));
        }
        itemPDFList.add(Bullet(text: 'Observação:  ${acao.observacao}'));
        if (acao.url != null && acao.url != '') {
          itemPDFList.add(UrlLink(
              child: Bullet(
                  text: 'Arquivo anexado. Click para visualizar.',
                  bulletColor: PdfColors.blue),
              destination: '${acao.url}'));
        }
        itemPDFList
            .add(Bullet(text: 'Atualizada:  ${acao.modificada.toString()}'));
        itemPDFList.add(Bullet(text: 'id:  ${acao.id}'));
        itemPDFList.add(Bullet(text: 'Referência:  ${acao.referencia}'));
        ordem++;
      }
    }
    final Document pdf = Document();
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
              child: Text('Relatorio das Tarefas do Usuario',
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
          if (itemPDFList.isEmpty) {
            itemPDFList.add(Paragraph(text: 'Sem tarefas deste usuário.'));
          }
          return itemPDFList;
        }));

    return pdf;
  }

  static pdfwidgetForControleTarefa(ControleTarefaModel controleTarefa) async {
    final acaoQuery = _firestore
        .collection(ControleAcaoModel.collection)
        .where("tarefa.id", isEqualTo: controleTarefa.id)
        .orderBy("ordem", descending: false);

// var controleAcaoSnapList = acaoQuery.documents;

    final fsw.QuerySnapshot acaoSnapshot = await acaoQuery.getDocuments();
    final acaoList = acaoSnapshot.documents.map((fsw.DocumentSnapshot doc) {
      return ControleAcaoModel(id: doc.documentID).fromMap(doc.data);
    }).toList();

    final Document pdf = Document();
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
              child: Text('Relatorio da Tarefa',
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
                    Text('Relatório da Tarefa', textScaleFactor: 2),
                    // FlutterLogo()
                  ])));

          itens.add(Header(level: 1, text: 'Tarefa: ${controleTarefa.nome}'));
          itens.add(
              Paragraph(text: 'Alguns dados importantes sobre esta tarefa.'));
          itens.add(Bullet(text: 'Setor: ${controleTarefa.setor.nome}'));
          itens
              .add(Bullet(text: 'Remetente: ${controleTarefa.remetente.nome}'));
          itens.add(Bullet(
              text: 'Destinatário: ${controleTarefa.destinatario.nome}'));
          itens
              .add(Bullet(text: 'Início: ${controleTarefa.inicio.toString()}'));
          itens.add(Bullet(text: 'Fim: ${controleTarefa.fim.toString()}'));
          itens.add(Bullet(
              text: 'Atualizada: ${controleTarefa.modificada.toString()}'));
          if (controleTarefa.concluida) {
            itens.add(Bullet(text: 'CONCLUÍDA: SIM'));
          } else {
            itens.add(Bullet(text: 'concluída: não'));
          }
          itens.add(Bullet(text: 'id: ${controleTarefa.id}'));
          itens.add(Bullet(text: 'Referencia: ${controleTarefa.referencia}'));

          itens.add(Paragraph(text: 'Lista de ações desta tarefa:'));
          int ordem = 1;
          for (var acao in acaoList) {
            if (acao.concluida) {
              itens.add(Header(
                level: 1,
                text: '[CONCLUÍDA] Ação ${ordem} : ${acao.nome}',
              ));
            } else {
              itens.add(Header(
                level: 1,
                text: 'Ação ${ordem} : ${acao.nome}',
              ));
            }
            itens.add(Bullet(text: 'Observação:  ${acao.observacao}'));
            if (acao.url != null && acao.url != '') {
              itens.add(UrlLink(
                  child: Bullet(
                      text: 'Arquivo anexado. Click para visualizar.',
                      bulletColor: PdfColors.blue),
                  destination: '${acao.url}'));
            }
            itens.add(
                Bullet(text: 'Atualizada:  ${acao.modificada.toString()}'));
            itens.add(Bullet(text: 'id:  ${acao.id}'));
            itens.add(Bullet(text: 'Referência:  ${acao.referencia}'));
            ordem++;
          }

          return itens;
        }));
    return pdf;
  }

  static createPdfForQuestionarioAplicadoModel(
      QuestionarioAplicadoModel questionarioAplicado) async {
    print('criando');
    final Document pdf = Document();

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
    List<List<String>> tabela = List<List<String>>();
    tabela.add(['Pergunta', 'Respondida']);
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
              if (pergunta['pergunta.imagem'].runtimeType != String) {
                Map<String, dynamic> anexo = pergunta['pergunta.arquivo'];
                int contador = 1;
                for (var item in anexo.entries) {
                  itens.add(UrlLink(
                      child: Bullet(
                          text:
                              'Arquivo ${contador.toString()}. Click para visualizar.',
                          bulletColor: PdfColors.blue),
                      destination: '${item.value}'));
                  contador++;
                }
              } else {
                itens.add(Paragraph(text: '${pergunta['pergunta.arquivo']}'));
              }
            }
            if (pergunta['pergunta.tipo'] == 'imagem') {
              if (pergunta['pergunta.imagem'].runtimeType != String) {
                Map<String, dynamic> anexo = pergunta['pergunta.imagem'];
                int contador = 1;
                for (var item in anexo.entries) {
                  itens.add(UrlLink(
                      child: Bullet(
                          text:
                              'Imagem ${contador.toString()}. Click para visualizar.',
                          bulletColor: PdfColors.blue),
                      destination: '${item.value}'));
                  contador++;
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
                itens.add(Paragraph(text: '${pergunta['pergunta.escolha']}'));
              }
            }

            itens.add(Paragraph(text: 'Outras informações importantes: '));
            itens.add(
                Bullet(text: 'Observação: ${pergunta['pergunta.observacao']}'));
            itens.add(Bullet(text: '${pergunta['pergunta.foiRespondida']}'));
            itens
                .add(Bullet(text: '${pergunta['pergunta.temRespostaValida']}'));
            itens.add(Bullet(text: '${pergunta['pergunta.temPendencias']}'));
            itens.add(Bullet(text: 'Id: ${pergunta['pergunta.id']}'));
            tabela.add(<String>[
              '${pergunta['pergunta.ordem']} - ${pergunta['pergunta.titulo']}',
              '${pergunta['pergunta.foiRespondida']}'
            ]);
          } // Fim perguntaAplicadaList
          itens.add(Padding(padding: const EdgeInsets.all(20)));
          itens.add(Paragraph(text: 'Resumo: '));
          itens.add(
              Table.fromTextArray(context: context, data: tabela.toList()));
          return itens;
        }));

    print('criado ${pdf.toString()}');

    return pdf;
  }
}
