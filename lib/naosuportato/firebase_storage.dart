import 'package:pmsbmibile3/naosuportato/empty.dart';

class StorageUploadTask extends Empty {
  dynamic cancel(){}
  dynamic events;

}

class FirebaseStorage extends Empty {
  static dynamic instance;
  dynamic ref(){}
  dynamic getReferenceFromUrl(String u){}
}

class StorageTaskEvent extends Empty {
  dynamic type;
  dynamic snapshot;
}
class StorageReference extends Empty{
  dynamic putFile(dynamic a, dynamic b){}
  dynamic delete(){}
}
class StorageTaskEventType extends Empty{
  static dynamic resume;
  static dynamic progress;
  static dynamic pause;
  static dynamic success;
  static dynamic failure;
}
class StorageMetadata extends Empty{
  StorageMetadata({dynamic contentType});
}