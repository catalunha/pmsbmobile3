import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model2.dart';
// import 'package:pmsbmibile3/pages/perfil/perfil_crud_page_bloc.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crudarq_page_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'package:pmsbmibile3/pages/perfil/editar_variavel_bloc.dart';

class PerfilCRUDArqPage extends StatefulWidget {
  // PerfilCRUDPage({Key key}) : super(key: key);

  _PerfilCRUDArqPageState createState() => _PerfilCRUDArqPageState();
}

class _PerfilCRUDArqPageState extends State<PerfilCRUDArqPage> {
  String newfilepath;

  @override
  Widget build(BuildContext context) {
    final String usuarioPerfilID = ModalRoute.of(context).settings.arguments;
    final bloc = PerfilCRUDArqPageBloc(Bootstrap.instance.firestore);
    dynamic image = FlutterLogo();
    bloc.perfilCRUDArqPageEventSink(
        UpDateUsuarioPerfilIDEvent(usuarioPerfilID));
    return Scaffold(
      appBar: AppBar(
        title: Text('Anexar arquivo no perfil '),
        // title: Text('Item de ${usuarioPerfilID.substring(0, 5)}'),
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UsuarioPerfilModel>(
            stream: bloc.usuarioPerfilModelStream,
            builder: (BuildContext context,
                AsyncSnapshot<UsuarioPerfilModel> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot.data.usuarioArquivoID?.url);
              if (snapshot.data.usuarioArquivoID != null) {
                image = SquareImage(
                  image: NetworkImage(snapshot.data.usuarioArquivoID?.url),
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
                    var filepath =
                        await FilePicker.getFilePath(type: FileType.IMAGE);
                    bloc.perfilCRUDArqPageEventSink(
                        UpDateArquivoLocalEvent(filepath));
                  }),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Use a camera para fotografar'),
              trailing: IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    // var filepath =
                    //     await ImagePicker.pickImage(source: ImageSource.camera);
                    // bloc.perfilCRUDArqPageEventSink(
                    //     UpDateArquivoLocalEvent(filepath));
                  }),
            ),
          ),
          StreamBuilder<PerfilCRUDArqPageState>(
            stream: bloc.perfilCRUDArqPageStateStream,
            builder: (BuildContext context,
                AsyncSnapshot<PerfilCRUDArqPageState> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Nenhuma imagem nova'),
                );
              }
              dynamic imageNova = FlutterLogo();
              print('snapshot.data.arquivoLocal ${snapshot.data.arquivoLocal}');
              if (snapshot.data.arquivoLocal != null) {
                // imageNova = AssetImage(snapshot.data.arquivoLocal);
                imageNova = SquareImage(
                  image: AssetImage(snapshot.data.arquivoLocal),
                );
                print('>> imageNova >>${imageNova}');
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Nova imagem'),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // bloc.perfilCRUDPageEventSink(SaveStateToFirebaseEvent());
          // Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _selecionarNovosArquivos() async {
    try {
      newfilepath = await FilePicker.getFilePath(type: FileType.ANY);
      if (newfilepath != null) {
        print('>> newfilepath 1 >> ${newfilepath}');
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    //if (!mounted) return;
  }
}
