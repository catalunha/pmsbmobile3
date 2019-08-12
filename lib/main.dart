//
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_crud_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_list_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_preview_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_escolha_marcar_page.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

//   Future _showNotificationWithSound() async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         sound: 'slow_spring_board',
//         importance: Importance.Max,
//         priority: Priority.High);
//     var iOSPlatformChannelSpecifics =
//         new IOSNotificationDetails(sound: "slow_spring_board.aiff");
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Post',
//       'How to Show Notification in Flutter',
//       platformChannelSpecifics,
//       payload: 'Custom_Sound',
//     );
//   }

// // Method 2
//   Future _showNotificationWithDefaultSound() async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         importance: Importance.Max, priority: Priority.High);
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Post',
//       'How to Show Notification in Flutter',
//       platformChannelSpecifics,
//       payload: 'Default_Sound',
//     );
//   }

// // Method 3
//   Future _showNotificationWithoutSound() async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         playSound: false, importance: Importance.Max, priority: Priority.High);
//     var iOSPlatformChannelSpecifics =
//         new IOSNotificationDetails(presentSound: false);
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Post',
//       'How to Show Notification in Flutter',
//       platformChannelSpecifics,
//       payload: 'No_Sound',
//     );
//   }

  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void configLocalNotification() {
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings(null);
    // var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(' ----------------- \n onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('----------------- \n onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('----------------- \n onLaunch: $message');
      return;
    });

    // firebaseMessaging.getToken().then((token) {
    //   print('token: $token');
    //   Firestore.instance
    //       .collection('Usuario')
    //       .document('nsD07Jb8cqRy9liyX82JwDSq8d22')
    //       .updateData({'pushToken': token});
    // }).catchError((err) {
    //   print(err.message.toString());
    // });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['title'].toString(),
        message['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(Bootstrap.instance.auth, Bootstrap.instance.firestore);
    
    return MaterialApp(
      title: 'PMSB-TO-22',
      //theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        //homePage
        "/": (context) => HomePage(authBloc),

        //Desenvolvimento
        "/desenvolvimento": (context) => Desenvolvimento(),

        //upload
        "/upload": (context) => UploadPage(authBloc),

        //perfil
        "/perfil": (context) => PerfilPage(),
        "/perfil/configuracao": (context) => ConfiguracaoPage(authBloc),
        "/perfil/crudtext": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerfilCRUDPage(settings.arguments);
        },
        "/perfil/crudarq": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerfilCRUDArqPage(settings.arguments);
        },

        //questionario
        "/questionario/home": (context) => QuestionarioHomePage(authBloc),
        "/questionario/form": (context) => QuestionarioFormPage(
              authBloc,
              ModalRoute.of(context).settings.arguments,
            ),

        //pergunta
        "/pergunta/home": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerguntaHomePage(settings.arguments);
        },
        "/pergunta/criar_pergunta": (context) => CriarPerguntaTipoPage(),
        "/pergunta/criar_editar": (context) {
          final settings = ModalRoute.of(context).settings;
          final EditarApagarPerguntaPageArguments args = settings.arguments;
          return EditarApagarPerguntaPage(
            questionarioID: args.questionarioID,
            perguntaID: args.perguntaID,
          );
        },
        "/pergunta/escolha_list": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerguntaEscolhaListPage(settings.arguments);
        },
        "/pergunta/escolha_crud": (context) {
          final settings = ModalRoute.of(context).settings;
          final PerguntaIDEscolhaIDPageArguments args = settings.arguments;
          return PerguntaEscolhaCRUDPage(args.perguntaID, args.escolhaUID);
        },
        "/pergunta/pergunta_preview": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerguntaPreviewPage(perguntaID: settings.arguments);
        },
        "/pergunta/pergunta_requisito_marcar": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerguntaRequisitoEscolhaMarcarPage(
              perguntaID: settings.arguments);
        },
        "/pergunta/pergunta_requisito": (context) {
          final settings = ModalRoute.of(context).settings;
          return PerguntaRequisitoPage(perguntaID: settings.arguments);
        },

        //aplicacao
        "/aplicacao/home": (context) => AplicacaoHomePage(authBloc),
        "/aplicacao/momento_aplicacao": (context) {
          final settings = ModalRoute.of(context).settings;
          return MomentoAplicacaoPage(
            authBloc,
            questionarioAplicadoID: settings.arguments,
          );
        },
        "/aplicacao/selecionar_questionario": (context) {
          final args = ModalRoute.of(context).settings.arguments;
          return AplicacaoSelecionarQuestionarioPage(args);
        },
        "/aplicacao/aplicando_pergunta": (context) {
          final AplicandoPerguntaPageArguments args =
              ModalRoute.of(context).settings.arguments;
          return AplicacaoPerguntaPage(
              authBloc, args.questionarioID, args.perguntaID);
        },
        "/aplicacao/pendencias": (context) {
          final args = ModalRoute.of(context).settings.arguments;
          return PendenciasPage(args);
        },
        "/aplicacao/visualizar_respostas": (context) =>
            VisualizarRespostasPage(),
        "/aplicacao/definir_requisitos": (context) {
          final DefinirRequisitosPageArguments args =
              ModalRoute.of(context).settings.arguments;
          return DefinirRequisistosPage(args.bloc, args.referencia);
        },

        //resposta
        "/resposta/home": (context) => RespostaHomePage(),
        "/resposta/resposta_questionario": (context) =>
            RespostaQuestionarioPage(),
        "/resposta/questionario_resposta": (context) =>
            QuestionarioRespostaPage(),

        //sintese
        "/sintese/home": (context) => SinteseHomePage(),

        //produto
        "/produto/home": (context) => ProdutoHomePage(authBloc),
        "/produto/crud": (context) {
          final settings = ModalRoute.of(context).settings;
          return ProdutoCRUDPage(settings.arguments, authBloc);
        },
        "/produto/texto": (context) {
          final settings = ModalRoute.of(context).settings;
          return ProdutoTextoPage(
            settings.arguments,
          );
        },
        "/produto/arquivo_list": (context) {
          final settings = ModalRoute.of(context).settings;
          ProdutoArguments args = settings.arguments;
          return ProdutoArquivoListPage(
              produtoID: args.produtoID, tipo: args.tipo);
        },
        "/produto/arquivo_crud": (context) {
          final settings = ModalRoute.of(context).settings;
          ProdutoArguments args = settings.arguments;
          return ProdutoArquivoCRUDPage(
              produtoID: args.produtoID,
              arquivoID: args.arquivoID,
              tipo: args.tipo);
        },
        //chat
        "/chat/home": (context) {
          final settings = ModalRoute.of(context).settings;
          ProdutoArguments args = settings.arguments;
          return ChatPage();
        },
        "/chat/lista_chat_visualizada": (context) {
          final settings = ModalRoute.of(context).settings;
          ProdutoArguments args = settings.arguments;
          return ChatLidoPage();
        },

        //comunicacao
        "/comunicacao/home": (context) => ComunicacaoHomePage(),
        "/noticias/noticias_visualizadas": (context) => NoticiaLidaPage(),
        "/comunicacao/crud_page": (context) => ComunicacaoCRUDPage(),

        //administração
        "/administracao/home": (context) => AdministracaoHomePage(),
        "/administracao/perfil": (context) => AdministracaoPerfilPage(),

        //controle
        "/controle/home": (context) => ControleHomePage(),
      },
      //   ),
      // ),
    );
  }
}