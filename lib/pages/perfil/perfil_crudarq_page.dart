import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crudarq_page_bloc.dart';

class PerfilCRUDArqPage extends StatefulWidget {
  final String usuarioPerfilID;
  final PerfilCRUDArqPageBloc bloc;

  PerfilCRUDArqPage(this.usuarioPerfilID)
      : bloc = PerfilCRUDArqPageBloc(Bootstrap.instance.firestore) {
    bloc.perfilCRUDArqPageEventSink(UpDateUsuarioPerfilIDEvent(usuarioPerfilID));
  }

  _PerfilCRUDArqPageState createState() => _PerfilCRUDArqPageState();
}

class _PerfilCRUDArqPageState extends State<PerfilCRUDArqPage> {
  String arquivoPath;
  File imagem;

  @override
  Widget build(BuildContext context) {
    // final String usuarioPerfilID = ModalRoute.of(context).settings.arguments;
    // final bloc = PerfilCRUDArqPageBloc(Bootstrap.instance.firestore);
    dynamic image = FlutterLogo();
    // bloc.perfilCRUDArqPageEventSink(
    //     UpDateUsuarioPerfilIDEvent(usuarioPerfilID));
    return Scaffold(
      appBar: AppBar(
        title: Text('Anexar arquivo no perfil '),
        // title: Text('Item de ${usuarioPerfilID.substring(0, 5)}'),
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UsuarioPerfilModel>(
            stream: widget.bloc.usuarioPerfilModelStream,
            builder: (BuildContext context,
                AsyncSnapshot<UsuarioPerfilModel> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot.data.arquivo?.url);
              if (snapshot.data.arquivo != null) {
                image = SquareImage(
                  image: NetworkImage(snapshot.data.arquivo?.url),
                );
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(snapshot.data.perfilID.nome),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 6,
                        child: image,
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  )
                ],
              );
              // return Text('...');
            },
          ),
          Card(
            child: ListTile(
              title: Text('Selecione o arquivo'),
              trailing: IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    await _selecionarNovosArquivos();
                    widget.bloc.perfilCRUDArqPageEventSink(
                        UpDateArquivoPathEvent(arquivoPath));
                    print('>> arquivoPath 2 >> ${arquivoPath}');
                  }),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Use a camera para fotografar'),
              trailing: IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    await _selecionarNovaImagem();
                    if (imagem != null && imagem.path != null) {
                      widget.bloc.perfilCRUDArqPageEventSink(
                          UpDateImagemEvent(imagem));
                    }
                  }),
            ),
          ),
          StreamBuilder<PerfilCRUDArqPageState>(
            stream: widget.bloc.perfilCRUDArqPageStateStream,
            builder: (BuildContext context,
                AsyncSnapshot<PerfilCRUDArqPageState> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Nenhuma imagem nova'),
                );
              }
              dynamic imageNova = FlutterLogo();
              print(
                  'snapshot.data.arquivoPath 1 ${snapshot.data.arquivo?.path}');
              if (snapshot.data.arquivo != null) {
                // imageNova = AssetImage(snapshot.data.arquivoPath);
                imageNova = SquareImage(
                  image: AssetImage(snapshot.data.arquivo?.path),
                );
                print(
                    'snapshot.data.arquivoLocal 2 ${snapshot.data.arquivo?.path}');
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Nova imagem:'),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 6,
                        child: imageNova,
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  )
                ],
              );
              // return Text('...');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.bloc.perfilCRUDArqPageEventSink(UpLoadEvent());
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Future<String> _selecionarNovosArquivos() async {
    try {
      arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        print('>> newfilepath 1 >> ${arquivoPath}');
        return arquivoPath;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Future<File> _selecionarNovaImagem() async {
    imagem = null;
    try {
      imagem = await ImagePicker.pickImage(source: ImageSource.camera);
      if (imagem != null) {
        print('>> camera 1 >> ${imagem}');
        return imagem;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }
}

class Lixo {
  // Row(
  //   children: <Widget>[
  //     Spacer(
  //       flex: 2,
  //     ),
  //     Expanded(
  //       flex: 6,
  //       child: FlutterLogo(),
  //     ),
  //     Spacer(
  //       flex: 2,
  //     ),
  //   ],
  // ),
  // Row(
  //   children: <Widget>[
  //     Spacer(
  //       flex: 2,
  //     ),
  //     Expanded(
  //       flex: 96,
  //       child: SquareImage(
  //         image: NetworkImage(
  //             // 'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/catalunha2.JPG?alt=media&token=cd0ed0da-3c59-46a8-b107-ab5a1c82f326'),
  //             'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/cpf-1-not1397.jpg?alt=media&token=a0e520ca-5f6e-48bf-96e4-1448caa01b9e'),
  //       ),
  //     ),
  //     Spacer(
  //       flex:ressed: () async {
  //   var filepath =
  //       await FilePicker.getFilePath(type: FileType.IMAGE);
  //   widget.bloc.perfilCRUDArqPageEventSink(
  //       UpDateArquivoLocalEvent(filepath));
  // } 2,
  //     ),
  //   ],
  // ),
  // Row(
  //   children: <Widget>[
  //     Spacer(
  //       flex: 2,
  //     ),
  //     Expanded(
  //       flex: 96,
  //       child: Image.network(
  //           'https://firebasestorage.googleapis.com/v0/b/pmsb-22-to.appspot.com/o/cpf-1-not1397.jpg?alt=media&token=a0e520ca-5f6e-48bf-96e4-1448caa01b9e'),
  //     ),
  //     Spacer(
  //       flex: 2,
  //     ),
  //   ],
  // )
  // Row(
  //   children: <Widget>[
  //     Spacer(
  //       flex: 2,
  //     ),
  //     Expanded(
  //       flex: 6,
  //       child: Image.asset(
  //         'assets/images/logos/Splash_PMSB.png',
  //         // '/storage/emulated/0/DCIM/Camera/20190717_102238.jpg',
  //         // '/storage/emulated/0/DCIM/Camera/20190711_194559.jpg',
  //         width: 100,
  //       ),
  //     ),
  //     Spacer(
  //       flex: 2,
  //     ),
  //   ],
  // ),
  // ListTile(
  //     leading: CircleAvatar(
  //   backgroundImage: AssetImage(
  //       '/storage/emulated/0/DCIM/Camera/20190717_073039.jpg'),
  // )),
  // Row(
  //   children: <Widget>[
  //     Spacer(
  //       flex: 2,
  //     ),
  //     Expanded(
  //       flex: 96,
  //       child: SquareImage(
  //         image: AssetImage(
  //             // '/storage/emulated/0/DCIM/Camera/20190717_073039.jpg'),
  //             '/storage/emulated/0/DCIM/Camera/20190711_194559.jpg'),
  //             // '/storage/emulated/0/DCIM/Camera/20190709_141433.jpg'),
  //       ),
  //     ),
  //     Spacer(
  //       flex: 2,
  //     ),
  //   ],
  // ),
}
