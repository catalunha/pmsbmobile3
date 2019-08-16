import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/upload/upload_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class UploadPage extends StatelessWidget {
  final UploadPageBloc bloc;

  UploadPage(AuthBloc authBloc)
      : bloc = UploadPageBloc(Bootstrap.instance.firestore, authBloc) {
    bloc.eventSink(UpdateUsuarioIDEvent());
  }

  void dispose() {
    // bloc.dispose();
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
          'ESTE ARQUIVO ESTA EM OUTRO DISPOSITIVO.';
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
