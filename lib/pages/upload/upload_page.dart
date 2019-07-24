import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/pages/upload/upload_page_bloc.dart';

class UploadPage extends StatefulWidget {
  final bloc = UploadPageBloc(Bootstrap.instance.firestore);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.eventSink(UpdateUsuarioIDEvent());
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
        stream: widget.bloc.stateStream,
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
          // if (!snapshot.hasData) {
          //   return Center(
          //     child: Text("Nenhum upload pendente."),
          //   );
          // }
          if (snapshot.data?.uploadingList == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var lista = snapshot.data.uploadingList;
          return ListView(
            children: lista
                .map((uploading) => _listUpload(context, uploading))
                .toList(),
          );
        });
  }

  Widget _listUpload(BuildContext context, Uploading uploading) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text('${uploading.upload.localPath}'),
            subtitle: Text('${uploading.id}'),
            trailing: IconButton(
              icon: uploading.uploading ? Icon(Icons.send) : Icon(Icons.close),
              onPressed: () {
                widget.bloc.eventSink(StartUploadEvent(uploading.id));
              },
            ),
          ),
        ),
        uploading.uploading
            ? CircularProgressIndicator()
            : IconButton(
                icon:
                    Icon(Icons.cloud_off),
                onPressed: () {},
              ),
      ],
    );
  }
}
