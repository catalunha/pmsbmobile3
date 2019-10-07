import 'package:pmsbmibile3/naosuportato/empty.dart';

class FilePicker extends Empty {
  static dynamic getFilePath({dynamic type, dynamic fileExtension}) {}

  static dynamic getMultiFilePath({dynamic type, dynamic fileExtension}) {}
}

class FileType extends Empty {
  static dynamic ANY;
  static dynamic IMAGE;
  static dynamic CUSTOM;
}
