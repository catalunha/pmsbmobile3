import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/pages/upload/upload_page_bloc.dart';


class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
    final bloc = UploadPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    // bloc.eventSink(UpdateUsuarioIDEvent());
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
          // if (!snapshot.hasData) {
          //   return Center(
          //     child: Text("Nenhum upload pendente."),
          //   );
          // }
          if (snapshot.data?.uploadList == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var lista = snapshot.data.uploadList;
          return ListView(
            children:
                lista.map((upload) => _listTile(context, upload)).toList(),
          );
        });
  }

  Widget _listTile(BuildContext context, UploadModel upload) {
    return ListTile(
      title: Text(upload.localPath),
      trailing: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {
    bloc.eventSink(StartUploadEvent());
        },
      ),
    );
  }
}
