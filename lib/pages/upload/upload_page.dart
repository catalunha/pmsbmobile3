import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/upload/upload_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class UploadPage extends StatefulWidget {
  final AuthBloc authBloc;
  UploadPage(this.authBloc);

  _UploadPageState createState() => _UploadPageState(this.authBloc);
}

class _UploadPageState extends State<UploadPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class UploadPage extends StatelessWidget {
  final UploadPageBloc bloc;

  _UploadPageState(AuthBloc authBloc)
      : bloc = UploadPageBloc(Bootstrap.instance.firestore, authBloc);


  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateUsuarioIDEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text("Uploads pendentes"),
        body: Container(
          child: _uploadBody(),
        ));
  }

  _uploadBody() {
    return StreamBuilder<PageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<PageState> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text("Erro. Informe ao administrador do aplicativo"),
            );
          // if (!snapshot.hasData) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Nenhum upload pendente."),
            );
          }
          // if (snapshot.data?.uploadingList == null) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // +++ Com lista de uploading
          var lista = snapshot.data?.uploadingList;
          if (lista == null) {
            return Text("Nenhum upload pendente.");
          } else {
            return ListView(
              children: lista
                  .map((uploading) => _listUpload(context, uploading))
                  .toList(),
            );
          }
          // --- Com lista de uploading
        });
  }

  Widget _listUpload(BuildContext context, Uploading uploading) {
    String dispositivo;
    if (!io.File(uploading.upload.localPath).existsSync()) {
      dispositivo =
          'ESTE ARQUIVO ESTÁ EM OUTRO DISPOSITIVO.';
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text('Menu: ${uploading.upload.updateCollection.collection}'),
            subtitle: dispositivo != null
                ? Text(dispositivo+'\nuploadID:${uploading.upload.id}\n${uploading.upload.updateCollection.collection}ID:${uploading.upload.updateCollection.document}')
                : Text('${uploading.upload.localPath}\nuploadID:${uploading.upload.id}\n${uploading.upload.updateCollection.collection}ID:${uploading.upload.updateCollection.document}'),
            trailing: dispositivo != null
                ? Icon(Icons.cloud_off)
                : IconButton(
                    icon: uploading.uploading
                        ? Icon(Icons.cloud_upload)
                        : Icon(Icons.send),
                    onPressed: () {
                      bloc.eventSink(StartUploadEvent(uploading.id));
                    },
                  ),
          ),
        ),
        dispositivo != null
            ? Container()
            : uploading.uploading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.cloud_queue),
                    onPressed: () {},
                  ),
      ],
    );
  }
}
