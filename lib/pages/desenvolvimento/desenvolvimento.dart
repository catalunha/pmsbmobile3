import 'dart:async';
import 'package:pmsbmibile3/models/ia_config_model.dart';
import 'package:pmsbmibile3/models/ia_execucao_model.dart';
import 'package:pmsbmibile3/models/ia_itens_model.dart';
import 'package:pmsbmibile3/models/ia_produto_model.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/desenvolvimento/desenvolvimento_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pmsbmibile3/bootstrap.dart';

import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class Desenvolvimento extends StatefulWidget {
  @override
  _DesenvolvimentoState createState() => _DesenvolvimentoState();
}

class _DesenvolvimentoState extends State<Desenvolvimento> {
  final bloc = DesenvolvimentoPageBloc(Bootstrap.instance.firestore);
  final fw.Firestore _firestore = Bootstrap.instance.firestore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text('Desenvolvimento - teste'),
        body: StreamBuilder<PageState>(
            stream: bloc.stateStream,
            builder: (BuildContext context, AsyncSnapshot<PageState> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(child: Text('Erro.')),
                );
              }
              return ListView(
                children: <Widget>[
                  Text(
                      'Algumas vezes precisamos fazer alimentação das coleções, teste de telas ou outras ações dentro do aplicativo em desenvolvimento. Por isto criei estes botões para facilitar de forma rápida estas ações.'),
                  ListTile(
                    title: Text('IA - Execucao.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await iaExecucao();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('IA - Produto.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await iaProduto();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('IA - Itens.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await iaItens();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('IA - Config.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await iaConfig();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Criar Usuario em UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        //Desenvolvimento
                        // await usuarioPMSBWEB('Aq96qoxA0zgLfNDPGPCzFRAYtkl2');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Atualizar routes de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarRoutes('YaTtTki7PZPPHznqpVtZrW6mIa42');
                        // await atualizarRoutesTodos();
                      },
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Atualizar eixo de acesso de UsuarioCollection.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarEixoAcesso('ysqq0XARJnZoxIzIc43suDm7gaK2');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Teste delete.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await atualizarEixoAcesso('SftB5Ix0d4MaHLEs8LASoT7KKl13');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Testar comandos firebase.'),
                    trailing: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () async {
                        // await testarFirebaseCmds();
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  Future iaConfig() async {
    final corRef = _firestore.collection(IAConfigModel.collection);

    await corRef.document().setData(IAConfigModel(
          simNome: 'Sim',
          parcialNome: 'Parcialmente',
          naoNome: 'Não',
          azul:
              'Alicação normal da avaliação, ou seja, cabem as respostas para as alternativas SIM ou NÃO ou PARCIALMENTE com suas respecitvas pontuações. Se a resposta for NÃO (a célula encontra-se desbloqueada para receber a resposta NÃO), o produto deve ser devolvido para o parceiro visando ajuste/alinhamento ao TR.',
          vermelho:
              'Bloqueia a tecla NÃO, para evitar que o produto seja devolvido ou reprovado, mas também não pontua. Ou seja, se a resposta for NÃO, não reprova, mas também não pontua no quesito. O analista deve tratar deste ponto com o parceiro, buscando convergência com o TR, se for possível/se viável, dependerá do seu bom senso. Na planilha, a célula tem um B (bloqueada).',
          verde:
              'Faz a função da tecla NA (não se aplica),ou seja, se o que for perguntado não existir no município, não faz sentido responder às perguntas seguintes correlacionadas ao quesito. A solução eletrônica mais simples encontrada para este tipo de caso foi bloquear as células dos quesitos que não devem ser respondidos com a expressão "Passe para a próxima questão". Este tipo de bloqueio atua eletronicamente até que o cursor seja posicionado no próximo quesito a ser respondido. No formulário original, antes de serem inseridas as respostas, essas células estão tarjadas de amarelo.',
          lilas:
              'A pergunta é longa porque só faz sentido se o PMSB atendeu a um conjunto de aspectos, ainda que seja PARCIALMENTE, mas se não atendeu a nenhum, a resposta é NÃO e o produto é reprovado, ou pode ser devolvido ao parceiro para ajuste, fica a critério do bom senso do analista. ',
          observacoes: '',
          simPontos: 10,
          parcialPontos: 5,
          naoPontos: 0,
          itensNumero: 360,
        ).toMap());
  }

  Future iaExecucao() async {
    List<List<String>> itens = [
      ['A', 'ATIVIDADES INICIAIS'],
      ['', 'Portaria de nomeação do Comitê Executivo'],
      ['', 'Mapeamento dos Atores Locais'],
      ['', 'Proposta de Composição do Comitê de Coordenação'],
      ['', 'Proposta com a Definição dos Setores de Mobilização Social (SM)'],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['B', 'ESTRATÉGIA PARTICIPATIVA'],
      [
        '',
        'Decreto de nomeação do Comitê de Coordenação e respectivo regimento interno'
      ],
      [
        '',
        'Relatório da Estratégia de Mobilização, Participação Social e Comunicação do PMSB, aprovada por deliberação do Comitê de Coordenação'
      ],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['C', 'DIAGNÓSTICO TÉCNICO-PARTICIPATIVO'],
      [
        '',
        'Relatório do Diagnóstico Técnico-Participativo e apresentação do Quadro com o Resumo Analítico do Diagnóstico do PMSB'
      ],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['D', 'PROGNÓSTICO DO PMSB'],
      [
        '',
        'Relatório do Prognóstico do PMSB: cenário de referência para a gestão dos serviços; objetivos e metas; prospectivas técnicas para abastecimento de água, esgotamento sanitário, manejo de águas pluviais, manejo de resíduos sólidos'
      ],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['E', 'PROPOSTAS DO PMSB'],
      [
        '',
        'Relatório com a proposição de Programas, Projetos e Ações do PMSB e respectivo Quadro 3 com as Propostas do PMSB'
      ],
      [
        '',
        'Quadro 4 com o resultado da aplicação da Metodologia de Hierarquização das Propostas do PMSB'
      ],
      ['', 'Programação da Execução do PMSB com apresentação do Quadro 5'],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['F', 'INDICADORES DE DESEMPENHO DO PMSB'],
      ['', 'Proposta de Indicadores de Desempenho do PMSB'],
      ['', 'Relatório de Acompanhamento das Atividades'],
      ['G', 'APROVAÇÃO DO PMSB'],
      [
        '',
        'Documento Consolidado do PMSB, com a incorporação das contribuições pacatuados na Audiência Pública e por deliberação do Comitê de Coordenação'
      ],
      [
        '',
        'Minuta do Projeto de Lei para aprovação do PMSB, tendo o Documento Consolidado como anexo'
      ],
      [
        '',
        'Resumo Executivo do PMSB, de acordo com escopo mínimo estabelecido no TR'
      ],
      ['', 'Relatório de Acompanhamento das Atividades']
    ];

    int numero = 1;
    print('iaExecucao $numero');
    final corRef = _firestore.collection(IAExecucaoModel.collection);
    itens.forEach((linha) async {
      await corRef.document().setData(IAExecucaoModel(
              numero: numero++, produto: linha[0], descricao: linha[1])
          .toMap());
    });
    print('iaExecucao $numero');
  }

  Future iaProduto() async {
    List<List<String>> itens = [
      ['4', 'Itens de Controle Geral do TED', ''],
      ['5', 'Controle do Produto A - ATIVIDADES INICIAIS', ''],
      [
        '6',
        'Controle do Produto B - ESTRATÉGIA DE MOBILIZAÇÃO, PARTICIPAÇÃO SOCIAL E COMUNICAÇÃO',
        ''
      ],
      [
        '7',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - CARACTERIZAÇÃO TERRITORIAL DO MUNICÍPIO (C1)'
      ],
      [
        '8',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - QUADRO INSTITUCIONAL DA POLÍTICA E DA GESTÃO DOS SERVIÇOS DE SANEAMENTO BÁSICO (C2)'
      ],
      [
        '9',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - SERVIÇO DE ABASTECIMENTO DE ÁGUA (C3)'
      ],
      [
        '10',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - SERVIÇO DE ESGOTAMENTO SANITÁRIO (C4)'
      ],
      [
        '11',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - SERVIÇO DE MANEJO DE ÁGUAS PLUVIAIS (C5)'
      ],
      [
        '12',
        'Controle do Produto C',
        'Relatório do Diagnóstico Técnico-Participativo - SERVIÇO DE MANEJO DE RESÍDUOS SÓLIDOS (C6)'
      ],
      [
        '13',
        'Controle do Produto D',
        'Relatório do PROGNÓSTICO DO PMSB: Cenário de Referência para a gestão dos serviços e definição de Objetivos e Metas (D1)'
      ],
      [
        '14',
        'Controle do Produto D',
        'Relatório do PROGNÓSTICO DO PMSB: Prospectivas Técnicas para cada um dos componentes do saneamento básico (D2)'
      ],
      [
        '15',
        'Controle do Produto E',
        'Relatório com as PROPOSTAS DO PMSB: Programas, Projetos e Ações e Metodologia para Hierarquização das Propostas do PMSB (E1)'
      ],
      [
        '16',
        'Controle do Produto E',
        'Relatório com a PROGRAMAÇÃO DA EXECUÇÃO DO PMSB (E2)'
      ],
      [
        '17',
        'Controle do Produto F - Relatório sobre os INDICADORES DE DESEMPENHO DO PMSB',
        ''
      ],
      [
        '18',
        'Controle do Produto G - Minuta do Projeto de Lei para APROVAÇÃO DO PMSB, tendo o Documento Consolidado como Anexo e Registro da Audiência Pública',
        ''
      ],
    ];
    int numero = 30;
    print('iaProduto $numero');

    final corRef = _firestore.collection(IAProdutoModel.collection);
    itens.forEach((linha) async {
      await corRef.document().setData(IAProdutoModel(
              numero: numero++,
              indice: linha[0],
              titulo: linha[1],
              subtitulo: linha[2])
          .toMap());
    });
    print('iaProduto $numero');
  }

  Future iaItens() async {
    List<List<String>> itens = [
      [
        "FkhMejGmzKsKWo38IgO3",
        "4.1",
        "Foi emitida ordem de serviço para o início dos trabalhos?"
      ],
      [
        "FkhMejGmzKsKWo38IgO3",
        "4.2",
        "A execução do PMSB está de acordo com o(s) projeto(s) aprovado(s) [Plano de trabalho, Planilha Orçamentária]? O cronograma de execução do PMSB, definido pelo Comitê  Executor, inclusive com relação ao repasse de recursos entre a Funasa e o parceiro (proponente/gestão recebedora), que deve obedecer ao desembolso previsto quando da aprovação do Plano de Trabalho e da Planilha Orçamentária pela Funasa. Caso o cronograma de execução do Plano não esteja coerente com o desembolso previsto, o parceiro (gestão recebedora) deverá ser notificado a apresentar justificativas da alteração do Plano de Trabalho, que, por sua vez, deverá ser analisada pelo NICT. Se as alterações não tiverem embasamento técnico, o parceiro (gestão recebedora) deverá ser notificado a retomar o desembolso previsto inicialmente."
      ],
      [
        "FkhMejGmzKsKWo38IgO3",
        "4.3",
        "Houve proposta de alteração do projeto aprovado? "
      ],
      [
        "FkhMejGmzKsKWo38IgO3",
        "4.4",
        "A proposta de alteração do projeto foi aprovada pela Funasa?  "
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.1",
        "Foi publicada Portaria de nomeação do Comitê Executivo?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.2",
        "A composição do Comitê Executivo atende aos requisitos do TR quanto ao perfil técnico e multidisciplinar?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.3",
        "A equipe técnica mínima do Comitê Executivo estabelecida no Anexo 1 do TR foi considerada?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.4",
        "Apresenta o mapeamento dos atores locais?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.5",
        "Apresenta proposta para a composição do Comitê de Coordenação, tendo por base o mapeamento dos atores locais?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.6",
        "Apresenta a definição dos setores de mobilização (SM) do PMSB, de maneira a promover ampla participação da população do município? "
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.7",
        "O Comitê Executivo foi o responsável pelo mapeamento dos atores locais?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.8",
        "O Comitê Executivo elaborou a proposta de composição do Comitê de Coordenação, tendo por base o mapeamento dos atores locais?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.9",
        "O Comitê Executivo participou tecnicamente da definição dos setores de mobilização?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.10",
        "A definição dos setores de mobilização observou a distribuição territorial e organização social das comunidades?"
      ],
      [
        "spNantMXEqgF3K3BEnfY",
        "5.11",
        "O Relatório de Acompanhamento das Atividades do Produto A traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além disto, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.1",
        "Foi apresentado o Decreto de nomeação do Comitê de Coordenação com respectivo regimento interno, de acordo com o Anexo 2 do TR?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.1.1",
        "A composição do Comitê de Coordenação atende satisfatoriamente a proposta feita pelo Comitê Executivo?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2",
        "Apresenta o Relatório da Estratégia de Mobilização, Participação Social e Comunicação, tendo sido aprovada por deliberação do Comitê de Coordenação?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.1",
        "A Estratégia Participativa apresentada atende aos requisitos da Diretriz Metodológica do TR com relação à previsão de chamamento da população no início do processo para informar e mobilizar sobre a realização do PMSB?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.2",
        "A Estratégia Participativa apresentada atende aos requisitos da Diretriz Metodológica do TR com relação à territorialização do município em setores de mobilização (SM) na área urbana e, sobretudo, na área rural para realização dos eventos setoriais?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.3",
        "A Estratégia Participativa apresentada atende aos requisitos da Diretriz Metodológica do TR com relação à realização das oficinas de capacitação dos 2 Comitês do PMSB? "
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.4",
        "A Estratégia Participativa apresentada atende aos requisitos da Diretriz Metodológica do TR com relação  ao uso de versões preliminares e de versões finais como mecanismo para promover a apreciação das propostas pela população e para incorporar as contribuições que forem pactutadas nos eventos participativos do PMSB?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.5",
        "A Estratégia Participativa apresentada atende aos requisitos da Diretriz Metodológica do TR com relação à audiência pública para aprovação do PMSB?  "
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.6",
        "Apresenta informações sobre a dinâmica social que permitam a compreensão de como a população local se organiza e a identificação de agentes sociais estratégicos a serem envolvidos no processo de mobilização social para a elaboração e a implantação do PMSB?           "
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.7",
        "Identifica e avalia os programas de educação em saúde e mobilização social existentes no município e respectivos agentes envolvidos?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.8",
        "Apresenta cronograma de atividades nos setores de mobilização que indique minimamente data e local?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.9",
        "Identifica o sistema e as formas de comunicação local viáveis no município e sua capacidade de difusão para alcançar toda a população?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.10",
        "Prevê ferramentas de divulgação e de mobilização da população como faixas, convites, folder, cartazes, anúncio em rádio, jornal, redes sociais, corpo a corpo entre outras formas comunicação local e a sua divulgação em todo o município, contemplando necessariamente a área rural do município? "
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.11",
        "Prevê a disponibilização de infraestrutura e logística necessárias para a realização dos eventos setoriais (área urbana e rural) e da audiência pública?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.2.12",
        "Prevê registro da memória dos eventos, tal como estabelecido no escopo dos Relatórios de Acompanhamento das Atividades?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.3",
        "O Relatório de Acompanhamento das Atividades do Produto B traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bom como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "mLqtTgiGmUdeFU9Yjc86",
        "6.4",
        "Foi emitido Parecer de Aprovação do Produto B pelo Comitê de Coordenação?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.1",
        "Identifica a área de planejamento do PMSB, considerando: área urbana, área rural do município; incluindo as áreas dispersas (comunidades quilombolas, indígenas e tradicionais, se houver) e as áreas onde mora população de baixa renda (favelas, ocupações irregulares, assentamentos precários, entre outras denominações), como determina a Resolução no 75/2009 do Conselho das Cidades?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.1.1",
        "A área rural do município é definida com base em critérios? Sejam critérios próprios do município ou na ausência desses, referenciados no Programa Nacional de Saneamento Rural (PNSR)?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.1.2",
        "Apresenta mapas e/ou imagens de satélite de maneira a caracterizar a área de planejamento com relação a: estado, mesorregião ou microrregião a qual pertence; delimitação do perímetro urbano e da área rural, municípios vizinhos e/ou limítrofes, com respectivas distâncias e principais vias de acesso, inclusive do município com relação à capital do estado ou outros polos regionais?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.1.3",
        "Na ilustração em mapas e/ou imagens satélite da área de planejamento, os setores de mobilização são também identificados?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.1.4",
        "Apresenta o contexto sobre a  evolução do município ao longo da sua história, especificamente, com relação à formação do município, a relevância dos recursos naturais e ambientais nesse processo, o tipo de urbanização, entre outros aspectos naturais e antrópicos que caracterizam esse território e que influenciam o saneamento básico? (É desejável a ilustração do contexto com fotos)."
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.2",
        "Apresenta a caracterização física do município segundo aspectos geológico-geomorfológicos, pedológicos, características do relevo, climáticos e meteorológicos, tipo de vegetação; situação das águas superficiais e subterrâneas; destacando os que têm a ver com o planejamento das ações de saneamento (alternativas tecnológicas, programação de obras, processos de gestão, entre outros)? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.3",
        "Apresenta a caracterização socioeconômica do município abrangendo os aspectos do perfil demográfico da população?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.3.1",
        "Considera a densidade demográfica e analisa o crescimento populacional a partir de dados populacionais referentes a, preferencialmente, os quatro últimos censos, apresentando estrutura etária?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.3.2",
        "Apresenta tabelas e gráficos para ilustrar essa evolução, distinguindo o comportamento da população urbana, da população rural e os rebatimentos na população total do município?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.3.3",
        "Apresenta uma análise dos dados, preferencialmente ilustrada com tabelas e gráficos, com relação aos seguintes aspectos: i) comportamento da taxa de crescimento populacional total (urbana + rural); ii) comportamento da taxa de crescimento da população urbana; iii) comportamento da taxa de crescimento da população rural; iv) análise se a curva de tendência de crescimento da população total se assemelha à curva da população urbana, o que demonstraria predominância da concentração da população do município na área urbana (ou vice-versa para a população rural); v) comparação com o comportamento da taxa de crescimento média nacional; vi) a comparação entre as taxas de urbanização em nível nacional, estadual e municipal?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.3.4",
        "Acata a recomendação do TR de se  destacar da caracterização territorial e da evolução do perfil demográfico da população local as variáveis que influenciam mais diretamente o planejamento das ações de saneamento para o PMSB (por exemplo quanto à taxa de crescimento populacional, à relação da população urbana, rural e total, à transição epidemiológica/natalidade, mortalidade , longevidade e fecundidade; ao número de domicílios, e população flutuante, se existir)?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.4",
        "Informa sobre a estrutura territorial do município identificando os padrões de uso e ocupação do solo, a relação urbano-rural, os vetores e a dinâmica de expansão urbana, os eixos de desenvolvimento e, de maneira bastante particular, a existência de áreas dispersas (comunidades quilombolas, indígenas e tradicionais) e a existência das as áreas onde mora população de baixa renda? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.5",
        "Informa sobre a existência de população indígena no município?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.5.1",
        "Existe população indígena no município?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.5.2",
        "Informa se o processo de elaboração do PMSB contemplou alguma estratégia específica para mobilização dessa população?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.5.3",
        "Apresenta informação se a Sesai foi consultada sobre a população indígena existente no município, em termos de diganóstico/caracterização e projetos/ações em andamento e/ou previstos?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.5.4",
        "As informações obtidas junto à Sesai foram consideradas no diagnóstico do PMSB?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6",
        "Informa se existem no município áreas onde mora população de baixa renda como favelas, vilas, ocupações, loteamentos irregulares, assentamentos precários? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6.1",
        "Existem áreas do muncípio onde mora população de baixa renda?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6.2",
        "Apresenta o levantamento dessas áreas de favelas, vias, ocupações, loteamentos irregulares, assentamentos precários? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6.3",
        "Este levantamento incluiu visitas de campo (preferencialmente, acompanhadas pelos Comitês do PMSB) para produzir/complementar dados e informações sobre essas áreas, com registro fotográfico e mapas; além de entrevistas com gestores, técnicos municipais e lideranças comunitárias que atuam na causa da moradia popular no município? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6.4",
        "Identifica as principais deficiências do planejamento físico territorial que justificam a existência dessas áreas carentes e que têm a ver com ocupação territorial desordenada, ausência/inadequação de parâmetros de uso e ocupação do solo, ausência/inadequação de Zonas Especiais de Interesse Social – ZEIS?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.6.5",
        "Apresenta a caracterização dessas áreas de interesse social, onde mora população de baixa renda, com relação a: localização, perímetro, carências relacionadas ao saneamento básico, precariedade habitacional, infraestrutura (energia elétrica, pavimentação, transporte e habitação)?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.7",
        "A caracterização territorial do município apresenta consolidação cartográfica das informações socioeconômicas, físico-territoriais e ambientais?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.8",
        "Apresenta informação sobre a situação fundiária do município e sua relação com os eixos de desenvolvimento da cidade e os projetos de parcelamento e/ou urbanização?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9",
        "Informa sobre as políticas públicas correlatas ao saneamento básico, descrevendo para cada uma: a lei de criação da política e se esta integra um sistema nacional; o conselho municipal e/ou conselho gestor do fundo; o plano municipal; os principais programas, projetos e ações que impactam ou são impactados pelo saneamento básico? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9.1",
        "Nessa descrição sobre políticas públicas correlatas, foram consideradas minimamente as políticas de saúde, habitação de interesse social, meio ambiente, gestão de recursos hídricos e educação? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9.2",
        "Particularmente com relação à política de saúde, o diagnóstico informa sobre: i) indicadores de longevidade, natalidade, mortalidade e funcunidade;ii) as práticas de saúde da comunidade em interface com o saneamento; iii) as causas e indicadores de morbilidade de doenças decorrentes da falta de saneamento, principalmente as doenças infecciosas/parasitárias; iv) o índice nutricional da população infantil de 0 a 2 anos?           "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9.3",
        "Apresenta levantamento da infraestrutura e dos equipamentos públicos, correlacionado-os aos impactos causados no saneamento? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9.4",
        "Apresenta levantamento da energia elétrica com relação a: se existe alguma deficiência nos serviços de saneamento relacionada à disponibilidade de geração e distribuição de energia elétrica no município; ii) se o município participa de algum programa voltado de redução de consumo de energia elétrica e combate ao desperdício, e se os prestadores dos  serviços de saneamento básico implementam algum programa de redução de perdas?  "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.9.5",
        "Apresenta levantamento da situação da pavimentação e do transporte com relação ao índice de pavimentação de vias e logradouros públicos existente no município, tendo em vista que o estado de conservação da infraestrutura influencia a vida útil dos equipamentos e  rotinas operacionais adotadas no saneamento básico? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.10",
        "Informa se a população local faz uso de transporte fluvial?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.10.1",
        "A população faz uso de transporte fluvial?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.10.2",
        "Informa como o uso de transporte fluvial interfere na forma como o município presta os serviços, pois o estado de conservação dos recursos ambientais influencia os equipamentos e  rotinas operacionais adotadas no saneamento básico?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.11",
        "Apresenta levantamento dos cemitérios existentes no município, onde estão localizados, em termos de contexto territorial e ambiental (cursos d´água, solo, vegetação, população de entorno, etc.) visando correlacionar eventuais tipos de impactos negativos que afetam o bom funcionamento dos serviços de saneamento básico? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.12",
        "Analisa a questão da segurança pública dos sistemas de saneamento, se existe alguma programação/rotina de proteção, controle do acesso e de vigilância visando garantir as condições adequadas de operação e manutenção de mananciais, aterros sanitários, centrais de triagem de resíduos, bacias de contenção e de amortecimento, ETA, ETE, EE, entre outros? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.13",
        "Analisa o calendário dos eventos festivos do município do ponto de vista dos impactos que causam para o saneamento básico, seja pelas demandas da população flutuante que passa a exigir mais dos sistemas implantados, seja pelas necessidades de reforço das rotinas operacionais dos serviços, como equipes e turnos extras para fazer a limpeza dos locais usados, para fortalecer a fiscalização, entre outros? "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.14",
        "Apresenta uma descrição analítca do nível de desenvolvimento local, segundo aspectos ligados a renda, pobreza, desigualdade e atividade econômica do município?"
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.14.1",
        "Apresenta o levantamento e a análise segundo os seguinte índices: IDHM (evolução e posição comparada e análise segundo suas variáveis de  longevidade, de educação, e padrão de vida segundo a renda), GINI (mensura a desigualdade segundo o grau de concentração de renda, ou seja, aponta a diferença entre os rendimentos dos mais pobres e dos mais ricos)?  "
      ],
      [
        "sSVbafBM80HvLlcqFxH9",
        "7.14.2",
        "Apresenta levantamento analítico do universo de pessoas cadastradas residentes no município que se encontram em situação de extrema pobreza, organizando os dados por: faixa etária, sexo, área urbana ou área rural; número de pessoas em situação de extrema pobreza, número de famílias do CadÚnico / Bolsa Família? "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.1",
        "Apresenta levantamento e apropriação da legislação vigente para o setor e análise dos instrumentos legais que definem as políticas nacional, estadual, regional e municipal de saneamento básico?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.2",
        "Apresenta o  mapeamento de como está a organização do saneamento básico no município, identificando os agentes envolvidos e suas responsabilidades no ciclo da gestão dos serviços (planejamento, regulação, fiscalização, prestação dos serviços, controle social), tomando por base a apropriação que o município fez sobre a legislação pertinente nos diferentes níveis de governo?  "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.2.1",
        "Apresenta o quadro com o resultado da dinâmica proposta no TR (p.72 ) sobre organização dos serviços?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.2.2",
        "Apresenta o quadro com o resultado da dinâmica proposta no TR (p. 74) sobre nível de conformidade legal?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.3",
        "Apresenta descrição analítica dos principais programas existentes em saneamento básico, sejam de iniciativa do governo federal, estadual ou do próprio município, e das áreas correlatas (saúde, educação, habitação de interesse social, meio ambiente, recursos hídricos, etc.)?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.4",
        "Identifica se existe alguma forma de avaliação sobre os serviços prestados à população e, se for o caso, quais os procedimentos adotados (avaliação quantitativa via indicadores, avaliação qualitativa, via processos participativos, entrevistas, grupos focais, visitas de campo, etc.)? "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.5",
        "Apresenta a atual estrutura de remuneração dos serviços: se os serviços prestados são cobrados; por quais meios a cobrança é feita (taxas, tarifas ou outros preços públicos); se existe algum tipo de subsídio para a população de baixa renda e como funciona?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.6",
        "Identifica as formas usadas para registrar e tratar os dados e informações do saneamento básico, seja por meio de banco de dados, planilhas, cadastros, informatizados ou não; e como são disponibilizados? "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.7",
        "Identifica se existem no município experiências de consórcios públicos já implantadas e/ou iniciativas em estudo e/ou negociação e quais são (quais entes federativos consorciados e para qual finalidade)? "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.8",
        "Identifica as rubricas que correspondem às ações do município em saneamento básico e verifica na execução orçamentária dos últimos 4 (quatro) exercícios, o nível de aplicação dos recursos orçamentários em saneamento básico, demonstrando a evolução dos investimentos no setor? "
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.9",
        "Apresenta o resultado da consulta sobre transferências realizadas do governo federal para o município vigentes nos últimos 10 (dez) anos  para a função saneamento, assim como pelo governo estadual?"
      ],
      [
        "GKJi0CWIx1sQ5GKIvDTb",
        "8.10",
        "Identifica as ações de educação ambiental e mobilização social em saneamento e nível de investimento aplicado (principais práticas, hábitos e costumes da população; programas existentes)? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1",
        "Apresenta a descrição geral do serviço de abastecimento de água existente no município (incluindo as áreas urbana, rural, dispersas e aquelas ocupadas por população de baixa renda), considerando sua adequação à realidade local? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.1",
        "Informa sobre a gestão do serviço – como é planejado, regulado, fiscalizado e prestado – até a infraestrutura utilizada (as instalações, as redes, os equipamentos, as rotinas de operação e manutenção), bem como as condições de como os serviços são prestados e as formas de comunicação e de atendimento da população usuária?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.2",
        "Apresenta o levantamento e análise de todas as soluções alternativas individuais usadas pela população que não é atendida por rede geral de abastecimento de água, assim como as soluções alternativas coletivas (Portaria no 2.914/2011, MS, atual PRC n° 5/2017)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.3",
        "A descrição é ilustrada por mapas, fluxogramas, croquis, fotografias e planilhas que permitam uma caracterização satisfatória do serviço?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.4",
        "Em caso de o município trabalhar com mais de um sistema de abastecimento de água para atender à população, é especificado cada sistema de acordo com os itens determinados no TR?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.5",
        "Apresenta dados e informações sobre o sistema: número de ligações, índice de atendimento, volume médio de água bruta, volume médio de água produzida, volume produzido/economia, volume faturado/economia, consumo per capita, índice de reservação, volume de água utilizada, volume de água produzida, volume faturado, índice de perdas, índice de arrecadação, índice de macromedição, índice de hidrometração?   "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.1.6",
        "Identifica as principais deficiências e problemas do serviço de abastecimento de água, correlacionando as suas causas?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.2",
        "Identifica e analisa a qualidade da água bruta captada em função da situação da fonte usada (manancial, poço, nascente) em relação à proteção do entorno, presença de carga orgânica e de poluentes em níveis inaceitáveis, conflitos de uso do recurso hídrico ou ainda deficiência operacional que pode afetar também a disponibilidade para o consumo humano, entre outros aspectos?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.3",
        "Identifica e analisa a potabilidade da água distribuída para o consumo humano, que deve atender aos parâmetros da Portaria nº 2.914/2011 (atual PRC n° 5/2017), visando garantir a segurança da população usuária do serviço?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.4",
        "Identifica e analisa a regularidade do abastecimento em todas as áreas atendidas, correlacionando as causas de problemas verificados que podem estar ligados à intermitência (se de produção, se operacional, se relacionada à disponibilidade de energia elétrica, se de gestão da demanda, etc.)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.5",
        "Identifica e analisa o desabastecimento ou abastecimento irregular em decorrência de escassez do recurso hídrico, do nível de desperdício no consumo, do nível de perdas provocadas pelo prestador de serviços, entre outros?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.5.1",
        "Identifica e analisa as áreas não atendidas pelo serviço público de abastecimento de água, indicando e mapeando quais são essas áreas e população afetada, soluções informais (coletivas e individuais) encontradas pela população para suprir a necessidade de consumo, a exemplo de uso de poços, busca por água implicando em transporte e armazenamento indevidos, entre outras?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.6",
        "Identifica e analisa o uso de poços rasos em áreas urbanas sem controle sobre a qualidade da água, onde é comum a coexistência desses poços com fossas no mesmo terreno e sem as condições de segurança para evitar contaminação?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.6.1",
        "Identifica e analisa a ocorrência de doenças relacionadas com o consumo de água não potável e/ou com a indisponibilidade do serviço para determinadas comunidades?  "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.7",
        "Informa como a Secretaria Municipal de Saúde desempenha sua responsabilidade com relação à vigilância sobre a qualidade da água produzida/distribuída, as práticas operacionais adotadas no sistema, indicando no mínimo a periodicidade das coletas, o percentual de amostras dentro e fora dos padrões?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.8",
        "Apresenta detalhamento de como o prestador de serviços vem procedendo a avaliação sistemática da qualidade da água, sob a perspectiva dos riscos à saúde, com base na ocupação da bacia contribuinte ao manancial, nas características físicas do sistema e nas práticas operacionais adotadas?  "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.8.1",
        "Informa se o prestador disponibiliza na conta de água esta informação, nos termos do Decreto no 5.440/2005?    "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.9",
        "Apresenta levantamento dos recursos hídricos do município, possibilitando a identificação de qual(is) mananciais atenderiam às condições para abastecimento futuro da população do município?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.9.1",
        "Apresenta avaliação preliminar sobre a necessidade de utilização de possível(is) novo(s) manancial(is) para abastecimento futuro da população local (urbana e rural) e as  possibilidades mais prováveis? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.9.2",
        "Antecipa, preliminarmente, algumas variáveis desses prováveis mananciais para abastecimento futuro, como: tipo (superficial ou subterrâneo), vazão (l/s), quando disponível, distância média do núcleo principal de abastecimento (km), características da qualidade de água bruta e condições de entorno (atual e projetada)?   "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.10",
        "Informa se atualmente existe deficit com relação: (i) ao volume de água disponibilizada pelo município para o consumo humano, e (ii) ao volume que seria necessário para atender a toda a população, tomando como referência o per capita informado pelo prestador?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.10.1",
        "Apresenta análise deste deficit considerando a capacidade atual do sistema, envolvendo as áreas urbana e rural e na perspectiva da universalização? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.11",
        "No que se refere à estrutura do consumo, foi identificado e analisado: o per capita atual para cada tipo de uso; foi apresentado em gráfico a distribuição da estrutura de consumo; foram identificadas as faixas de consumo por setor (m3/mês) e o valor da tarifa (R\$ por m3), índice de inadimplência?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.11.1",
        "Apresenta detalhamento do balanço entre consumo e demanda do serviço de abastecimento de água, conforme estabelecido no TR? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.11.2",
        "Identifica e analisa a ocorrência de perdas no sistema (reais e aparentes)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.11.3",
        "Informa quantas economias do sistema de abastecimento de água são ativas e destas quantas são hidrometradas?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.11.4",
        "Informa qual a vida útil média dos hidrômetros e cobertura atingida? "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.12",
        "Caso exista Plano Diretor de Abastecimento de Água para o  município, o diagnóstico do PMSB apresenta análise crítica desse plano diretor, destacando pontos divergentes ou conflitantes com relação ao disposto na legislação e no TR?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.13",
        "Apresenta a estrutura organizacional responsável pelo serviço de abastecimento de água?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.13.1",
        "Apresenta organograma do prestador de serviço, com a descrição do quadro de recursos humanos (número de trabalhadores, cargo/função, vínculo, escolaridade, entre outros aspectos funcionais) e suas atribuições?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.13.2",
        "Identifica os responsáveis por cada função de gestão: quem planeja; quem regula e fiscaliza; quem presta o serviço (autarquia ou empresa municipal, companhia estadual,  prestador privado, outros); quem exerce o controle social (conselho municipal, ou se apenas algum canal do prestador de serviços para receber reclamações/sugestões da população)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.14",
        "Apresenta a Identificação e análise da situação econômico-financeira do serviço de abastecimento de água, tendo por base o que determina a legislação atual sobre a matéria?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.14.1",
        "Apresenta dados apurados junto ao prestador de serviços quanto a receitas e despesas e investimentos, preferencialmente, desagregados por sede municipal e por distritos?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.14.2",
        "Apresenta tabela com os valores do metro cúbico de água tratada em vigência (R\$/m3), por categorias de usuários (tipos de residencial, tipos de comercial, industrial, etc.) e por faixa de consumo (m3/mês)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.14.3",
        "Apresenta quadro que informa a situação atual dos custos e da cobrança dos serviços de saneamento básico: atual nível de perdas; ações para combater o consumo supérfluo, o desperdício; usuários que deveriam ser prioritários (escolas, creches, unidades de saúde, etc.)?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.14.4",
        "Informa se é adotado algum mecanismo para prover o serviço a comunidades que não podem pagar: tarifa social, outro tipo de subsídio?"
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.15",
        "Apresenta, como recomendado no TR, uma análise comparativa, usando indicadores do SNIS quanto ao desempenho do prestador e do serviço comparativamente a municípios de características similares, além da média estadual e nacional?  "
      ],
      [
        "HFIHv7e56FPWWbd8bn1G",
        "9.16",
        "A Estratégia Participativa foi aplicada nesta etapa do Diagnóstico, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1",
        "Apresenta a descrição geral do serviço de esgotamento sanitário existente no município (incluindo as áreas urbana, rural, dispersas e aquelas ocupadas por população de baixa renda), considerando sua adequação à realidade local?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.1",
        "A descrição é ilustrada com mapas, fluxogramas, croquis, fotografias e planilhas para uma caracterização satisfatória do serviço? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.2",
        "Apresenta o levantamento e análise de todas as soluções individuais usadas pela população que não é atendida por rede geral de esgoto, ou até mesmo soluções coletivas, em alguns casos operadas pela própria comunidade?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.3",
        "Apresenta a infraestrutura do sistema convencional existente: redes de coleta de esgoto, estações elevatórias, interceptores, estação de tratamento de esgotos, emissários/forma de lançamento do efluente tratado (gravidade ou recalque)? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.4",
        "Informa se existe alguma área atendida por sistema não convencional de esgotamento sanitário, a exemplo do sistema condominial?   "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.5",
        "Informa se existe a prática de defecação a céu aberto em decorrência da ausência de banheiro?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.6",
        "Informa se é comum o uso de fossas pelos moradores como a solução de esgotamento sanitário adotada? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.7",
        "Informa sobre a existência de lançamento de esgotos na rede de drenagem, indicando, por meio do conhecimento prático da operação do sistema, os principais pontos onde isto ocorre?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.8",
        "Descreve as condições de funcionamento e de manutenção das fossas existentes (se existe um serviço da Prefeitura de caminhão limpa fossa e qual a disposição deste efluente, ou se é feita pelos próprios moradores e os riscos sanitários e ambientais associados)?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.1.9",
        "Descreve as principais características ambientais e de entorno das principais instalações do serviço de esgotamento sanitário, como ETE (se existir), elevatórias e corpos receptores do efluente tratado ou mesmo in natura?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.2",
        "Informa se existe Estação de Tratamento de Esgoto (ETE) no município?"
      ],
      ["PzxpnTIoZsWnMmsIzlqr", "10.2.1", "Existe  ETE no município?"],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.2.2",
        "No caso de existir ETE, informa sobre as condições de funcionamento, mediante levantamento e análise das informações referentes a laudo do controle de qualidade do esgoto afluente e efluente da ETE, analisando se as condições atendem aos parâmetros estabelecidos na legislação vigente, quanto ao padrão de lançamento de efluentes tratados em corpos d'água (histórico de DBO, DQO, sólidos, nitrogênio, fósforo e coliformes?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.3",
        "Informa se existem soluções de saneamento ecológico (baseadas na permacultura e outras)?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.4",
        "Apresenta uma análise da cobertura do serviço no município (urbana e rural), identificando: aquelas com os piores índices de cobertura? quem são as pessoas que moram nessas áreas (perfil socioeconômico); quantas são (densidade populacional)? O mesmo raciocínio foi aplicado para os locais com os melhores índices, de maneira a se revelar as principais desigualdades intramunicipais, em termos de acesso aos serviços?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.5",
        "Levanta e sistematiza os principais problemas e deficiências verificados no sistema de esgotamento sanitário existente no município?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6",
        "Identifica os problemas operacionais e de manutenção no sistema público, tais como: entupimentos e extravasamentos recorrentes e que não são reparados dentro dos parâmetros aceitáveis, lançamento de esgotos na rede de drenagem ocasionando mau cheiro, entupimentos e contaminação de cursos d´água, EEs inoperantes (falta de reserva, energia elétrica intermitente, equipamentos obsoletos), falta ou insuficiência de automação do sistema, ETE parada e/ou com manutenção indevida , ETE operando fora do parâmetro da carga necessária por insuficiência de cobertura da rede coletora e/ou dos interceptores, níveis de tratabilidade do esgoto não alcançados com lançamento de efluente fora dos valores máximos permitidos em termos de carga poluente, geração de incômodos para a população de entorno da ETE?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6.1",
        "Identifica problemas operacionais e de manutenção de fossas usadas pelos moradores que não dispõem de acesso ao sistema público de esgotamento sanitário, com relação a: contaminação de eventuais poços rasos, extravasamento do esgoto das fossas com geração de odores, contaminação do solo superficial e proximidade das pessoas com esgoto in natura,  falta de limpeza periódica das fossas, lançamento do efluente de caminhões limpa fossa em locais inadequados, como o lixão ou aterro sanitário, córregos e rios, entre outros? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6.2",
        "Identifica problemas de gestão do serviço de esgotamento sanitário, seja na área do planejamento com relação a áreas não atendidas ou ao uso de tecnologias inadequadas, seja na área da regulação e fiscalização por exemplo com relação a moradores que mesmo dispondo do acesso ao serviço público não faz sua ligação domiciliar e continua utilizando a fossa em condições inadequadas, ou ainda com relação à falta de parâmetros do regulador para normatizar como deve se dar a manutenção no sistema (tempo para atendimento a partir da reclamação do usuário, recorrência do problema, etc.), falta de canal de comunicação da população com o prestador e o gestor do serviço, entre outros?   "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6.3",
        "Apresenta a situação do esgotamento sanitário de equipamentos públicos e coletivos (postos de saúde, hospitais, escolas, creches, etc.)?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6.4",
        "Analisa se a ocorrência das doenças mais recorrentes que tenham a ver com o convívio da população com esgoto in natura nesses equipamentos públicos e coletivos?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.6.5",
        "Apresenta o mapeamento dos principais pontos de lançamento de esgotos in natura, das áreas com concentração de fossas rudimentares e dos pontos de lançamento do efluente tratado, mas que esteja gerando algum tipo de contaminação fora dos padrões aceitáveis? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.7",
        "Informa sobre a existência no município de atividades geradoras de impactos negativos tais como: laticínios, matadouros, granjas (entre outras disciplinadas na legislação ambiental brasileira e Resoluções do Conama)?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.7.1",
        "Existem essas atividades geradoras de impactos negativos no município?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.7.2",
        "Em caso de existir, apresenta o mapeamento dessas atividades e descreve a situação do licenciamento ambiental, bem como as medidas que já foram tomadas pelo poder público visando sanar os problemas encontrados (TAC, termo de acordo, etc.)?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.7.3",
        "O poder público fiscaliza a situação dessas atividades, considerando que a lei determina que a responsabilidade por eventual impacto gerado é da responsabilidade do agente privado?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.8",
        "Caso exista Plano Diretor de Esgotamento Sanitário para o  município, o diagnóstico do PMSB apresenta análise crítica desse plano diretor, destacando pontos divergentes ou conflitantes com relação ao disposto na legislação e no TR?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.9",
        "Identifica preliminarmente, com base na caracterização territorial, a necessidade de utilização de novo(s) corpos receptores para lançamento futuro do esgoto sanitário produzido pela população local, indicando as possibilidades mais prováveis?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.10",
        "Também com base na caracterização territorial do município, apresenta mapeamento dos principais fundos de vale (em termos de proteção ambiental e de ocupação antrópica)?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.11",
        "Indica, introdutoriamente, as possibilidades para traçado de interceptores que interliguem as redes a uma ETE futura?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.11.1",
        "Indica, também introdutoriamente, potenciais situações futuras de corpos d´água como receptores de esgotos, para reaproveitamento, irrigação ou infiltração no solo e sinalização de possíveis áreas para locação de ETE?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.11.2",
        "Visando subsidiar preliminarmente a projeção de um futuro sistema de esgotamento sanitário e/ou ampliação do existente, indica possível localização da ETE, tanto do ponto de vista do uso e ocupação do solo da área e do entorno, quanto de aspectos operacionais como o relevo que implica no número de elevatórias que serão necessárias ao sistema? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.12",
        "Apresenta balanço entre geração de esgoto e capacidade do sistema, se existente na área de planejamento?    "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.12.1",
        "Analisa a estrutura de produção de esgotos, distinguindo os geradores/usuários (do sistema) em categorias especificas, indicando para cada uma o per capita de esgoto gerado, volume mensal produzido (m3/mês), número de economias? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.12.2",
        "Avalia a estrutura de produção de esgoto sanitário do município, confronta os números com a capacidade instalada atualmente; de maneira a se ter, ainda no âmbito do diagnóstico, uma noção sobre necessidade de ampliação bem como de implantação de um sistema, caso o município ainda não disponha de um?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.13",
        "Apresenta o levantamento das ligações clandestinas de água de chuva na rede de esgoto?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.14",
        "Apresenta o organograma do prestador de serviços, com a descrição do quadro de recursos humanos (número de trabalhadores, cargo/função, escolaridade, entre outros aspectos funcionais), bem como suas atribuições?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.14.1",
        "Identifica o responsável por cada função de gestão do serviço de esgotamento sanitário (quem planeja, quem regula, quem fiscaliza, quem presta o serviço, quem exerce o controle social)?  "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.15",
        "Apresenta dados apurados junto ao prestador do serviço, sobre receitas, despesas e investimentos, desagregados por sede municipal e por distritos?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.16",
        "Apresenta tabela para informar sobre a política tarifária atualmente praticada: os valores do metro cúbico de esgoto coletado, esgoto coletado e tratado (se for o caso), e valor vigente (R\$/m3), por categoria de usuários (tipos de residencial, tipos de comercial, industrial, etc.) e por faixa de produção (m3/mês)?"
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.17",
        "Apresenta, como recomendado no TR, alguns indicadores do SNIS, que servem como referência para avaliação de desempenho do prestador de serviços? "
      ],
      [
        "PzxpnTIoZsWnMmsIzlqr",
        "10.18",
        "A Estratégia Participativa foi aplicada nesta etapa do Diagnóstico, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.1",
        "Apresenta a descrição geral do serviço de manejo de águas pluviais existente no município (incluindo as áreas urbana, rural, dispersas e aquelas ocupadas por população de baixa renda), considerando sua adequação à realidade local?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.1.1",
        "Detalha a descrição geral do serviço, sob a ótica do manejo de águas pluviais, informando sobre: cobertura do serviço, medidas para o controle do escoamento na fonte, redução do nível de impermeabilização do solo, revitalização de fundos de vale e aproveitamento da água de chuva, principais fundos de vale/cursos d´água por onde é feito o escoamento das águas de chuva, indicando as condições de drenagem natural, eventuais áreas verdes utilizadas como recomposição vegetal, as principais estruturas de drenagem?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.1.2",
        "Ilustra com fotos, mapas croquis (se possível georreferenciado) a área formada pelos pontos que recebem as principais contribuições pluviais e respectivas condições de deságue, assim como fluxogramas e fotografias que permitam o entendimento do sistema em operação, incluindo o traçado das galerias, canais e posicionamento das bocas de lobo e saídas de águas?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.2",
        "Verifica no Plano Diretor do Município, caso exista, as diretrizes para o manejo de águas pluviais e medidas de controle que visem: reduzir o assoreamento de cursos d’água e de bacias de detenção, reduzir e erradicar o lançamento de resíduos sólidos nos corpos d’água, controle de escoamentos na fonte, tratamento de fundos de vale, redução do nível de impermeabilização do solo, aproveitamento da água de chuva, entre outras?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.3",
        "Identifica se existe o Plano Municipal de Drenagem Urbana (ou de Manejo de Águas Pluviais)?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.3.1",
        "Existe o Plano Municipal de Drenagem Urbana (ou de Manejo de Águas Pluviais)"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.3.2",
        "Em caso de existir o Plano Municipal de Drenagem Urbana, o diagnóstico do PMSB traz uma análise segundo os aspectos elencados nesta abordagem quanto ao manejo de águas pluviais?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.4",
        "Apresenta levantamento da legislação existente sobre uso e ocupação do solo e seu rebatimento no manejo de águas pluviais?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.4.1",
        "Apresenta o levantamento das informações existentes referentes à fiscalização, o nível de atuação desta quanto ao cumprimento da legislação vigente e por meio de quais mecanismos normativos é exercida?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.4.2",
        "Apresenta o levantamento das situações específicas que indicam como vem se dando o rebatimento da legislação municipal de uso e ocupação do solo na gestão do serviço de manejo de águas pluviais?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.4.3",
        "Informa se existe regulamento municipal para o manejo de águas pluviais e de procedimentos para a fiscalização quanto ao cumprimento da legislação vigente, sobretudo por se tratar de uma nova concepção de drenagem urbana?   "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.5",
        "Descreve a rotina operacional e de manutenção do serviço, incluindo as estruturas de drenagem natural e artificial, levantando junto à secretaria municipal responsável: a periodicidade da limpeza dos canais, bueiros, bocas de lobo e outros dispositivos do sistema; se a manutenção é sistemática ou apenas em situação de emergência; equipamentos utilizados, pessoal envolvido, como as ações são planejadas; se existe canal de comunicação com as comunidades; estratégia de educação ambiental e sanitária com a população?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.5.1",
        "Ilustra a descrição da rotina operacional do sistema com fotos, imagens satélite e fluxogramas?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.6",
        "Apresenta levantamento dos sistemas existentes no município de maneira a subsidiar o estudo futuro sobre quais soluções mais viáveis, considerando a realidade do município?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.7",
        "Identifica quais os tipos existentes, se é adotado apenas um deles (ou seja, se apenas sistema unitário, se apenas sistema separador absoluto), ou se existe predominância de algum em determinadas áreas do município?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.7.1",
        "Identifica a ocorrência de ligações clandestinas de esgotos ao sistema de drenagem pluvial, inclusive despejo de caminhão limpa fossa?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.7.2",
        "Levanta os pontos de lançamento clandestino, pois, se por um lado o lançamento de águas pluviais na rede coletora de esgotos é inadequado porque aumenta a vazão a ser tratada em uma ETE, por outro, o lançamento de esgotos na rede de águas pluviais aumenta a carga poluidora das águas de chuva que serão lançadas em algum ponto da bacia (córrego, rio, etc.)?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.7.3",
        "Apresenta levantamento sobre os principais problemas quanto: ocorrência de rompimento de tubulações; existência de pontos obstruídos pela disposição inadequada de resíduos sólidos; áreas onde tem drenagem natural e que se encontram com o solo compactado; falta de manutenção periódica na área rural, particularmente nas estradas vicinais, com vistas a indicar os problemas acarretados para a comunidade e quais são os responsáveis pela correção dos mesmos?   "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.8",
        "Apresenta levantamento dos principais pontos críticos onde ocorrem alagamentos ou inundações e desmoronamentos causados pela falta e/ou inadequação da infraestrutura instalada ou por ocupação inadequada, por exemplo em áreas de amortecimento?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.8.1",
        "Lista os bairros, as ruas, as frequências dos registros, em qual ano ocorreu o pior evento, os principais estragos observados e como o município tratou do ocorrido?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.8.2",
        "Com base na caracterização do território municipal, apresenta uma breve análise entre evolução populacional, processo de urbanização da bacia e a quantidade de ocorrência de desastres, particularmente de inundações, correlacionando as condições da infraestrutura diagnosticada e a situação da ocupação irregular do solo? "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.9",
        "Identifica o quadro de funcionários que presta o serviço e faz a manutenção do sistema, incluindo o perfil do gestor/técnico diretamente responsável?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.10",
        "Apresenta levantamento dos custos com a implantação, operação e manutenção do serviço, tal como existe hoje no município, incluindo as despesas com pessoal, materiais, equipamentos e deslocamentos?  "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.11",
        "Informa se o serviço é cobrado e, se houver esta cobrança, se é direta ou indireta, e quais são os meios usados (se taxa própria, se dentro do IPTU, entre outros)?   "
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.12",
        "Apresenta indicadores para analisar o desempenho do serviço de manejo de águas pluviais?"
      ],
      [
        "geJhIOvmv9BOrPSaOml9",
        "11.13",
        "A Estratégia Participativa foi aplicada nesta etapa do Diagnóstico, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.1",
        "Apresenta a descrição geral do serviço de manejo de resíduos sólidos existente no município (incluindo as áreas urbana, rural, dispersas e aquelas ocupadas por população de baixa renda), considerando sua adequação à realidade local?            "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.2",
        "Com relação ao estudo de composição gravimétrica, o município adotou alguma das 3 alternativas estabelecidas no TR?  a) usar estudo realizado nos últimos 4 anos; b) utilizar fontes secundárias de municípios com características semelhantes (porte populacional, região geográfica e nível de desenvolvimento econômico; c) realizar estudo de composição gravimétrica, no âmbito do processo de elaboração do PMSB?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.3",
        "Descreve como o serviço de manejo de resíduos sólidos é atualmente prestado no município abrangendo todas as etapas, desde o acondicionamento, coleta, transbordo, transporte, tratamento até a destinação e disposição final?    "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.4",
        "Identifica como são exercidas estas atividades, quais os equipamentos, veículos e instalações usadas e os resultados alcançados?  "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.4.1",
        "Informa sobre a ocorrência de pesagem dos resíduos e onde fica a balança? Faz o registro das quantidades em base mensal?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.4.2",
        "Informa o índice de cobertura que a coleta atinge?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.4.3",
        "Visando construir uma visão integrada de cada etapa do serviço de manejo de resíduos sólidos, o diagnóstico foi feito levando-se em conta como cada tipo de resíduo é manejado em cada etapa, principalmente para aqueles que são de responsabilidade direta da Administração Municipal? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.5",
        "Responde a todas as questões elencadas no TR, por tipo de resíduo, por meio de uma abordagem sistêmica do assunto, e que não se resuma a um Sim ou Não a cada pergunta feita?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.5.1",
        "Para as etapas de tratamento, destinação e disposição final, o diagnóstico apresenta o quadro (p. 129 do TR) sobre tipos de unidades de processamento (de tratamento e de disposição final) existentes no município, identificando para cada unidade: o tipo de resíduo, informação sobre a existência ou não da instalação, o número de unidades, quem opera, o volume ou a massa de resíduo tratado/disposto?   "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.5.2",
        "Apresenta mapa com a localização dessas unidades de tratamento, destinação e disposição final, de maneira a ilustrar como se dá sua distribuição espacial no município?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.5.3",
        "Informa sobre o lixão ou aterro (controlado ou sanitário) e galpões de triagem existentes no município, quanto a: distância do núcleo central de coleta; características do entorno; impactos ambientais negativos em função da atividade no local; condições de funcionamento, principais procedimentos operacionais e de manutenção; equipamentos e maquinário utilizados (estado de conservação e uso regular na atividade); pessoal envolvido na operação (funcionamento da unidade, a segurança e outras atividades realizadas no local (visitas, palestras, etc.)? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.5.4",
        "Informa sobre presença de catadores (no lixão e/ou nas ruas), se existe cadastro e alguma medida de proteção social, entre outros aspectos?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.6",
        "Informa se existe o Plano de Gestão Integrada de Resíduos Sólidos (PGIRS)?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.6.1",
        "Existe o Plano de Gestão Integrada de Resíduos Sólidos (PGIRS)?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.6.2",
        "Em caso de existir o PGIRS,  este plano atende ao disposto nas duas leis (a Lei 11.445/2007, art.19 e a Lei 12.305/2010, art. 19)? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.6.3",
        " Em caso da existência do PGIRS que não atenda às duas leis, o PMSB o diagnóstico do PMSB está sendo desenvolvido de modo a corrigir eventuais conflitos e/ou lacunas e distorções?   "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7",
        "Com base na descrição do serviço do manejo de resíduos sólidos (incluída a limpeza pública) e, sobretudo, considerando as informações e percepções apuradas junto às comunidades e à população sobre o serviço prestado pelo município, o diagnóstico sistematiza os problemas encontrados? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7.1",
        "Informa se existe problema decorrente da geração excessiva de resíduos sólidos, da baixa adesão a iniciativas/ações de reaproveitamento, reutilização e de reciclagem e de falta de medidas para o combate ao desperdício?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7.2",
        "Informa se existe problema relacionado ao acondicionamento inadequado dos resíduos postos para a coleta (disposto fora dos dias e horários da coleta, em recipientes inadequados, lixo espalhado nas ruas por animais, oferecendo riscos sanitários e de segurança para os transeuntes e trabalhadores do serviço de coleta)?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7.3",
        "Informa se existe problema quanto a áreas não atendidas pelo serviço, indicando o perfil socioeconômico da população dessas áreas e eventuais dificuldades de acesso?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7.4",
        "Informa se existe problema relacionado à qualidade do serviço prestado como não atendimento à programação de coleta divulgada para a população, resíduos deixados pelos garis nas calçadas, vias e logradouros públicos, estado de conservação da frota utilizada, ausência de balança e de procedimentos de fiscalização e controle, etc.?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.7.5",
        "Informa se existe problema relacionado com as condições de segurança das pessoas que trabalham nas guarnições e a pontos de apoio para quem trabalha no serviço de limpeza pública?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.8",
        "Informa quais são os gargalos institucionais e operacionais da coleta seletiva ligados a: falta de apoio aos catadores, ausência de estudos de viabilidade do negócio social das cooperativas/associações de catadores, etc.?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.9",
        "Informa sobre a situação da disposição final, como aterros mal construídos e mal operados, existência de lixões, áreas de risco decorrentes da contaminação causada pela disposição inadequada dos resíduos sólidos (poluição do lençol freático e cursos d´água, poluição do ar, desmatamento/assoreamento, erosões, explosões de gás, incômodos para a comunidade de entorno, se houver)?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.10",
        "Informa sobre eventuais falhas quanto ao tipo de relação instituído pelo poder público com a população, sobretudo quanto à informação sobre a prestação dos serviços, capacidade de resolver as demandas e reclamações dos moradores, entre outros aspectos?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.11",
        "Informa se existe problema quanto ao atendimento à legislação vigente e às Resoluções Conama que regulamentam sobre o gerenciamento de RCC (entulhos dispostos pela cidade, assoreando inclusive cursos d´água), oneração do serviço prestado pela Prefeitura quando deveria ser pelo gerador?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.12",
        "Informa se existe problema quanto ao atendimento à legislação vigente e às Resoluções Conama que regulamentam sobre o gerenciamento de RSS (acondicionamento, transporte e destinação final inadequados), entre outros resíduos especificamente gerados em volume significativo no município?   "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.13",
        "Identifica, entre os problemas levantados, aqueles que tem como causa a carência do poder público para o atendimento adequado da população?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.13.1",
        "Aborda problemas de natureza institucional, tais como: ações de educação ambiental e sanitária; oportunidades para treinamento e capacitação; planejamento do serviço; meios de participação popular e de controle social; regulação e fiscalização sobre o serviço; qualidade na prestação do serviço; sobrecarga do trabalho e/ou de oneração do serviço para o poder público por assumir responsabilidades que por lei não são suas; protagonismo do poder público local na construção de parcerias; lacunas no Plano Diretor do Município ou nas diretrizes do zoneamento ambiental e territorial; estrutura de remuneração do serviço, de acordo com o que a Lei preconiza em termos de sustentabilidade econômico-financeira; entre outros aspectos? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.14",
        "Identifica áreas ambientalmente adequadas para disposição e destinação final de resíduos sólidos e de rejeitos, observadas as restrições determinadas na Lei no 12.305/2010?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.15",
        "Identifica os resíduos sólidos e os geradores sujeitos a plano de gerenciamento específico nos termos do art. 20 ou a sistema de logística reversa na forma do art. 33, observadas as disposições da Lei no 12.305/10 e de seu regulamento, bem como as normas estabelecidas pelos órgãos do Sisnama e do SNVS?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.16",
        "Identifica a estrutura organizacional do serviço de de manejo de resíduos sólidos e de limpeza pública: organograma funcional do(s) órgão(s) municipais incumbido(s) da realização das atividades direta ou indiretamente relacionadas ao serviço, respectivas funções e atribuições; perfil profissional do corpo gestor e técnico; número de funcionários públicos (administrativos, técnicos e operacionais/nível de escolaridade); número de funcionários contratados (administrativos, técnicos e operacionais, nível de escolaridade correlata); iniciativas de capacitação, qualificação técnica e treinamento operacional, além de atividades de promoção social como eventos artísticos, culturais e de empoderamento dos trabalhadores, inclusive se existe enfoque de gênero, bem como medidas de segurança e saúde do trabalhador?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.17",
        "Identifica programas especiais por exemplo de reciclagem de resíduos da construção civil, coleta seletiva, compostagem, cooperativas de catadores, resíduos submetidos à logística reversa, outros negócios sociais, como nas áreas de compostagem, de arborização urbana, de manejo de RCC; de aproveitamento energético? Para cada programa, apresenta um relato informando os aspectos elencados no TR? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.18",
        "Identifica os passivos ambientais relacionados aos resíduos sólidos, incluindo áreas contaminadas e respectivas medidas saneadoras, em geral decorrentes de: existência de lixões (inclusive com agravos sociais), de aterros controlados ou sanitários mal operados?   "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.19",
        "Apresenta identificação das possibilidades de implantação de soluções consorciadas ou compartilhadas com outros municípios por meio de consórcios públicos, considerando, nos critérios de economia de escala, a proximidade dos locais estabelecidos e as formas de prevenção dos riscos ambientais? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.20",
        "Identifica e analisa as receitas operacionais, despesas de custeio e investimentos que o município pratica atualmente para prestar o serviço de manejo de resíduos sólidos? "
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.21",
        "Apresenta indicadores para analisar o desempenho do serviço de manejo de resíduos sólidos?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.22",
        "O diagnóstico utiliza a terminologia em conformidade com a legislação, ou seja, estão sob a responsabilidade do Poder Público Municipal o manejo de resíduos domiciliares e a limpeza pública; sendo os demais resíduos sujeitos a logística reversa ou a plano de gerenciamento, sendo nos dois casos de responsabilidade dos próprios geradores?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.23",
        "A Estratégia Participativa foi aplicada nesta etapa do Diagnóstico, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.24",
        "O Relatório de Acompanhamento das Atividades do Produto C traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "tJElrX1DY1u0emYxz1iy",
        "12.25",
        "Foi emitido Parecer de Aprovação do Produto C pelo Comitê de Coordenação?"
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13 – Controle do Produto D – Relatório do PROGNÓSTICO DO PMSB: Cenário de Referência para a gestão dos serviços e definição de Objetivos e Metas (D1)",
        "WeuoKFemSAdTeMJfn8pt"
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.1",
        "Apresenta o Estudo de Cenários, como estabelecido no TR (Quadro 2; pág. 148) e faz a escolha do seu Cenário de Referência - Bom ou Regular ou Deficiente (pág. 149)?"
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.1.1",
        "A partir do Cenário de Referência escolhido, foram respondidas as perguntas elencadas no TR (págs. 150 e 151) sobre a situação futura do saneamento básico no município? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.2",
        "O horizonte do PMSB foi construído com base em projeções populacionais e em prospecção de demandas para atender toda a população do município (urbana e rural)?"
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.3",
        "A projeção populacional considerou a população atual do município e o comportamento da taxa de crescimento populacional?"
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.3.1",
        "Foi adotado o Método das Componentes Demográficas do IBGE, determinado no TR, para calcular a taxa de crescimento populacional? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.4",
        "Informa se existe população flutuante no município (comum em municípios com vocação turística, ou que sejam polo de agronegócio, ou acadêmico/uma instituição de ensino de alcance regional)? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.4.1",
        "Existe população flutuante no município? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.4.2",
        "No caso de existir, esta população flutuante (que implique em uma sazonalidade regular) foi considerada na projeção populacional do município? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.5",
        "Foram consolidados os objetivos e metas por projeção temporal para os horizontes de imediato, curto, médio e longo prazo para os 4 componentes do saneamento? "
      ],
      [
        "WeuoKFemSAdTeMJfn8pt",
        "13.6",
        "As metas consideraram os interesses da população identificados nos eventos setoriais e registrados no quadro resumo analítico do diagnóstico técnico-participativo?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.1",
        "As prospectivas técnicas para cada um dos 4 componentes do saneamento básico foram determinadas segundo as variáveis determinadas no TR: (i) a projeção populacional do município no horizonte do PMSB; (ii) as projeções de demandas pelo serviço; (iii) a escolha de tecnologias apropriadas?  "
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.2",
        "Abastecimento de Água: apresenta projeção da demanda anual de água para toda a área de planejamento ao longo dos 20 anos?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.2.1",
        "Abastecimento de Água: apresenta descrição dos principais mananciais (superficiais e/ou subterrâneos) passíveis de utilização para o abastecimento de água na área de planejamento?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.2.2",
        "Abastecimento de Água: apresenta a definição das alternativas de manancial para atender a área de planejamento, justificando a escolha com base na vazão outorgável e na qualidade da água?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.2.3",
        "Abastecimento de Água: apresenta a definição de alternativas técnicas de engenharia para atendimento da demanda calculada"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.2.4",
        "Abastecimento de Água: apresenta previsão de eventos de emergência e contingência?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.3",
        "Esgotamento Sanitário: apresenta projeção da vazão anual de esgotos ao longo dos 20 anos para toda a área de planejamento?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.3.1",
        "Esgotamento Sanitário: apresenta previsão de estimativas de carga e concentração de DBO e coliformes fecais, para as alternativas (a) sem tratamento e (b) com tratamento dos esgotos (ref.: eficiência típica de remoção)? "
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.3.2",
        "Esgotamento Sanitário: apresenta definição de alternativas técnicas de engenharia para atendimento da demanda calculada?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.3.3",
        "Esgotamento Sanitário: apresenta comparação das alternativas de tratamento dos esgotos sanitários: se centralizado (uma única ETE que recebe os efluentes de todas as bacias de contribuição do sistema); ou se descentralizado (várias ETEs que recebem a contribuição de subsistemas distribuídos espacialmente no município); justificando a abordagem selecionada."
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.3.4",
        "Esgotamento Sanitário: apresenta previsão de eventos de emergência e contingência?  "
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4",
        "Manejo de Águas Pluviais: apresenta Identificação de diretrizes/medidas de controle para reduzir o assoreamento de cursos d’água e de bacias de detenção?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.1",
        "Manejo de Águas Pluviais: apresenta identificação de diretrizes/medidas de controle para reduzir o lançamento de resíduos sólidos nos corpos d’água?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.2",
        "Manejo de Águas Pluviais: apresenta identificação de diretrizes/medidas para o controle de escoamentos na fonte (armazenamento, infiltração e a percolação, ou a jusante com bacias de detenção)?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.3",
        "Manejo de Águas Pluviais: apresenta identificação de diretrizes/medidas para o tratamento de fundos de vale?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.4",
        "Manejo de Águas Pluviais: Análise da necessidade de complementação do sistema com estruturas de micro e macrodrenagem, incluindo a concepção de manejo de águas pluviais?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.5",
        "Manejo de Águas Pluiviais: apresenta previsão de eventos de emergência e contingência?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.6",
        "Manejo de Resíduos Sólidos: apresenta estimativas anuais dos volumes de produção de resíduos sólidos classificados em (i) total, (ii) reciclado, (iii) compostado e (iv) aterrado, e % de atendimento pelo sistema de limpeza urbana?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.7",
        "Manejo de Resíduos Sólidos: apresenta metodologia para o cálculo dos custos e a cobrança dos serviços prestados, com base nos requisitos legais sobre sustentabilidade econômico-financeira dos serviços?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.8",
        "Manejo de Resíduos Sólidos: apresenta definição de regras para o manejo dos resíduos sólidos, conforme a Lei no 12.305/2010, com definição das responsabilidades?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.9",
        "Manejo de Resíduos Sólidos: apresenta definição de critérios para pontos de apoio ao sistema na área de planejamento (apoio à guarnição que trabalha no serviço, centros de coleta voluntária, mensagens educativas)?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.10",
        "Manejo de Resíduos Sólidos: apresenta descrição das formas de participação da Prefeitura na coleta seletiva e na logística reversa (art. 33/Lei no 12.305/2010) e outras ações de responsabilidade compartilhada pelo ciclo de vida dos produtos?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.11",
        "Manejo de Resíduos Sólidos: apresenta critérios de escolha da área para destinação e disposição final adequada de resíduos inertes gerados no município (seja por meio de reciclagem ou em aterro sanitário), observando-se, neste caso, o nível de responsabilidade dos agentes privados?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.12",
        "Manejo de Resíduos Sólidos: apresenta identificação de áreas favoráveis para disposição final ambientalmente adequada de rejeitos, identificando as áreas com risco de poluição e/ou contaminação?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.13",
        "Manejo de Resíduos Sólidos: apresenta procedimentos operacionais e especificações mínimas a serem adotados nos serviços, incluída a disposição final ambientalmente adequada dos rejeitos?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.14",
        "Manejo de Resíduos Sólidos: apresenta previsão de eventos de emergência e contingência?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.15",
        "Manejo de Resíduos Sólidos: apresenta definição de metas de redução, reutilização, coleta seletiva e reciclagem, entre outras, com vistas a minimizar o volume de rejeitos encaminhados para disposição final ambientalmente adequada; conforme determina a Lei no 12.305/2010?           "
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.4.16",
        "Manejo de Resíduos Sólidos: apresenta identificação das possibilidades de implantação de soluções consorciadas ou compartilhadas com outros municípios, considerando, nos critérios possíveis ganhos de escala e de escopo, a proximidade dos locais estabelecidos e as formas de prevenção dos riscos ambientais; conforme determina a Lei no 12.305/2010?           "
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.5",
        "A Estratégia Participativa foi aplicada nesta etapa do Prognóstico, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.6",
        "O Relatório de Acompanhamento das Atividades do Produto D traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "7YPw4enyF0fs3BKP02dA",
        "14.7",
        "Foi emitido Parecer de Aprovação do Produto D pelo Comitê de Coordenação?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.1",
        "As propostas do PMSB derivaram do diagnóstico técnico-participativo feito sobre a situação dos serviços de saneamento básico e dos impactos nas condições de vida da população e do meio ambiente?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.2",
        "As propostas do PMSB viabilizam o alcance dos objetivos e das metas definidas no Prognóstico? "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.3",
        "As propostas do PMSB abrangem medidas tanto do campo mais amplo da política e da gestão dos serviços (estruturantes), quanto no campo da infraestrutura (estruturais como obras, melhorias operacionais, etc.), devendo haver clara correspondência entre os dois campos, pois a implantação e operação da infraestrutura não se sustenta sem a gestão do serviço?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.4",
        "Com base nas informações do diagnóstico, o PMSB apresenta programas, projetos a ações para a área rural do município?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.5",
        "Com base nas informações do diagnóstico, o PMSB apresenta programas/projetos/ações para as comunidades que moram nas áreas dispersas do município (comunidades quilombolas, tradicionais e indígenas)?:"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.6",
        "Com base nas informaççoes do diagnóstico, o PMSB apresenta programas/projetos/ações para as áreas onde mora população de baixa renda?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.7",
        "Foram apresentados programas, projetos e ações para todos os 4 (quatro) componentes do saneamento? "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.8",
        "Apresenta a indicação das possíveis fontes de financiamento voltadas para viabilizar cada programa, projeto ou ação propostos no PMSB?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.9",
        "O PMSB, particularmente na programação para sua revisão, prevê convergência com o Plano Plurianual Municipal (PPA), sobretudo no sentido de orientar a legislação orçamentária subsequente? "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.10",
        "Apresenta o Quadro 3 determinado no TR (p.162) com a sistematização das Propostas do PMSB?  "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.11",
        "Na análise geral das propostas do PMSB, pode-se afirmar que são ações factíveis de serem atendidas nos prazos estipulados e que representam as aspirações sociais com alternativas de intervenção, inclusive de emergências e contingências, visando o atendimento das demandas e prioridades da sociedade, como apurado nos eventos participativos do PMSB?  "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.12",
        "Foi aplicada a Metodologia para Hierarquização das Propostas do PMSB, de acordo com o estabelecido no TR?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.12.1",
        "Apresenta o Quadro 4 com o resultado da aplicação da Metodologia para Hierarquização das Propostas do PMSB, como estabelecido no TR (p. 166)?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.12.2",
        "Houve participação ativa dos Comitês do PMSB (o de Coordenação e o Executivo) na aplicação da Metodologia? "
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.13",
        "A Estratégia Participativa foi aplicada nesta etapa das Propostas do PMSB, mediante realização dos eventos setoriais e, se for o caso, das reuniões temáticas, para discutir o panorama do serviço?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.14",
        "O Relatório de Acompanhamento das Atividades do Produto E traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "KwX4NrrzoYpa151EJ1HD",
        "15.15",
        "Foi emitido Parecer de Aprovação E do Produto pelo Comitê de Coordenação?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.1",
        "Apresenta o Quadro 5 (p. 171) com a Programação da Execução do PMSB, como determina o TR, indicando para cada proposta: a) a prioridade alcançada no ranking da Metodologia de hierarquização; b) o prazo para sua execução; c) o custo estimado para cada proposta; d) as fontes de financiamento que poderão ser captadas pelo governo municipal ou reservadas com recursos próprios ; e) o agente responsável pela implementação da proposta; f) as parcerias construídas em torno da proposta?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.2",
        "Apresenta os parâmetros de referência adotados na estimativa de custos?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.3",
        "A programação da implantação dos programas, projetos e ações foi desenvolvida considerando as metas estabelecidas no prognóstico (imediatos ou emergenciais; curto prazo; médio prazo; longo prazo)?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.4",
        "Foram considerados todos os componenentes do saneamento na programação de execução do PMSB? "
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.5",
        "A Programação de Execução do plano de execução contempla toda a área de planejamento do PMSB?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.6",
        "O Relatório de Acompanhamento das Atividades do Produto E traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "NdcRYloGzx20hdWKbV7n",
        "16.7",
        "Foi emitido Parecer de Aprovação do Produto E pelo Comitê de Coordenação?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.1",
        "Apresenta proposta de indicadores que possibilitem sistematizar dados e informações para fazer o acompanhamento e a avaliação da execução do PMSB e que traduzam, de maneira resumida, a evolução e a melhoria das condições de vida da população?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.2",
        "Apresenta a descrição dos indicadores propostos, segundo: i) a qual objetivo atender; ii) as variáveis que permitem o seu cálculo; iii) identificação da fonte de origem dos dados; iv) a fórmula de cálculo; v) a periodicidade de cálculo; vi) o intervalo de validade; vii) a indicação do responsável pela geração, atualização e divulgação?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.3",
        "Apresenta uma estrutura de avaliação do PMSB capaz de contemplar os aspectos estabelecidos no TR: a) como será feito o acompanhamento durante sua execução? b) quem participa desse processo? c) o que será avaliado? d) com base em que? e) como os resultados serão divulgados? Esta avaliação foi apresentada?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.4",
        "Na elaboração de indicadores que figurem como suporte estratégico na gestão municipal são considerados, além da prestação dos serviços, aspectos intrinsecamente ligados ao planejamento, à regulação/fiscalização e ao controle social?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.5",
        "Propõe indicadores para monitorar e avaliar os resultados do PMSB, para cada serviço e para as ações que abrangem os 4 serviços, quanto: a) ao nível de execução do PMSB, considerando as metas definidas e os prazos estabelecidos na Programação da Execução do PMSB (eficácia); b) ao uso de recursos financeiros, se foi compatível com o que foi programado, considerando o conjunto das ações do PMSB implementadas (eficiência); c) à capacidade do programa ou do projeto concluído mudar a realidade local, em atendimento aos objetivos programados no PMSB (efetividade)?  "
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.6",
        "Os indicadores propostos servem para monitorar e avaliar o funcionamento da sistemática planejada para o acompanhamento e a avaliação do PMSB, com relação a: i) as instâncias de participação e de controle social atuaram no processo de monitoramento? ii) foram produzidas e disponibilizadas informações para subsidiar o processo de monitoramento? "
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.7",
        "Os indicadores propostos servem para monitorar e avaliar a integração do saneamento básico com as outras políticas públicas correlatas, com relação a: i) as estratégias de articulação mobilizadas durante a elaboração do PMSB (grupos de trabalho, ações conjuntas, compartilhamento de recursos, etc.) foram incorporadas ao dia a dia da Administração Municipal? ii) as ações integradas surtiram benefícios que contribuíram para a melhoria das políticas públicas de todas as áreas temáticas envolvidas?  "
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.8",
        "São definidos indicadores de desempenho operacional e ambiental dos serviços públicos de limpeza urbana e de manejo de resíduos sólidos, como determina a Lei no 12.305/2010?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.9",
        "O Relatório de Acompanhamento das Atividades do Produto F traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "lOmFK1wUWCs15C5SQlYB",
        "17.10",
        "Foi emitido Parecer de Aprovação do Produto F pelo Comitê de Coordenação?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.1",
        "Apresenta o Relatório de Acompanhamento das Atividades com o registro completo da audiência pública realizada para aprovação do PMSB?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.2",
        "Apresenta o Documento Consolidado do PMSB, com a incorporação das contribuições pactuadas na audiência pública e por deliberação do Comitê de Coordenação?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.3",
        "Apresenta a Minuta do Projeto de Lei para aprovação do PMSB, tendo o Documento Consolidado como anexo?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.4",
        "Apresenta o Resumo Executivo do PMSB, de acordo com o escopo mínimo estabelecido no TR?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.5",
        "O Relatório de Acompanhamento das Atividades do Produto G traz o relato do que foi desenvolvido no período, indicando principalmente os resultados obtidos, as dificuldades encontradas, bem como a programação dos próximos passos? Além desta descrição mais analítica, apresenta as listas de presença de todos os eventos realizados e respectivos registros fotográficos, inclusive, se for o caso, dos levantamentos de campo e visitas de prospecção técnica?"
      ],
      [
        "EOt9cMdzxJp3rJfXPKLW",
        "18.6",
        "Foi emitido Parecer de Aprovação do Produto G pelo Comitê de Coordenação?"
      ],
    ];
    int numero = 45;
    print('iaItens $numero');

    final corRef = _firestore.collection(IAItensModel.collection);
    itens.forEach((linha) async {
      await corRef.document().setData(IAItensModel(
              numero: numero++,
              iaprodutoId: linha[0],
              indice: linha[1],
              descricao: linha[2])
          .toMap());
    });
    print('iaItens $numero');
  }

  Future testarFirebaseCmds() async {
    final docRef = await _firestore
        .collection(UsuarioModel.collection)
        .where('routes', arrayContains: '/comunicacao/home')
        .getDocuments();
    for (var item in docRef.documents) {
      print('Doc encontrados: ${item.documentID}');
    }
  }

  Future atualizarRoutesTodos() async {
    var collRef =
        await _firestore.collection(UsuarioModel.collection).getDocuments();

    for (var documentSnapshot in collRef.documents) {
      if (documentSnapshot.data.containsKey('routes')) {
        List<dynamic> routes = List<dynamic>();

        routes.addAll(documentSnapshot.data['routes']);
        print(routes.runtimeType);
        routes.addAll([
          // Drawer
          // '/',
          // '/upload',
          // '/questionario/home',
          // '/aplicacao/home',
          // '/resposta/home',
          // '/sintese/home',
          // '/produto/home',
          // '/comunicacao/home',
          // '/administracao/home',
          // '/controle/home',
          // "/perfil/configuracao",
          // endDrawer
          '/perfil/configuracao',
          '/perfil',
          // '/painel/home',
          '/modooffline',
          "/versao",
        ]);

        await documentSnapshot.reference
            .setData({"routes": routes}, merge: true);
      } else {
        print('Sem routes ${documentSnapshot.documentID}');
      }
    }
  }

  Future atualizarRoutes(String userId) async {
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    var snap = await docRef.get();
    List<dynamic> routes = List<dynamic>();
    routes.addAll(snap.data['routes']);
    print(routes.runtimeType);
    routes.addAll([
      //Drawer
      // '/',
      // '/upload',
      // '/questionario/home',
      // '/aplicacao/home',
      // '/resposta/home',
      // '/sintese/home',
      // '/produto/home',
      // '/comunicacao/home',
      // '/administracao/home',
      // '/controle/home',
      // "/perfil/configuracao",
      // endDrawer
      '/perfil/configuracao',
      '/perfil',
      // '/painel/home',
      '/modooffline',
      "/versao",
    ]);

    await docRef.setData({"routes": routes}, merge: true);
  }

  Future atualizarEixoAcesso(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'saude', nome: 'Saúde'),
        EixoID(id: 'administracao', nome: 'Administração'),
      ],
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
  }

  Future usuarioCatalunhaUFT(String userId) async {
    UsuarioModel usuarioModel = UsuarioModel(
      id: userId,
      ativo: true,
      nome: 'Catalunha UFT',
      celular: '0',
      email: 'catalunha@uft.edu.br',
      routes: [
        '/',
        '/desenvolvimento',
        '/upload',
        '/questionario/home',
        '/aplicacao/home',
        '/resposta/home',
        '/sintese/home',
        '/produto/home',
        '/comunicacao/home',
        '/administracao/home',
        '/controle/home'
      ],
      cargoID: CargoID(id: 'coordenador', nome: 'Coord'),
      eixoID: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAtual: EixoID(id: 'estatisticadsti', nome: ''),
      eixoIDAcesso: [
        EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
        EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
        EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
        EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
        EixoID(id: 'comunicacao', nome: 'Comunicação'),
        EixoID(id: 'direcao', nome: 'Direção'),
        EixoID(id: 'administracao', nome: 'Administração'),
        EixoID(id: 'saude', nome: 'Saúde'),
      ],
      setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'pal'),
    );
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    await docRef.setData(usuarioModel.toMap(), merge: true);
    // print('>>> ok <<< ');
  }
}
