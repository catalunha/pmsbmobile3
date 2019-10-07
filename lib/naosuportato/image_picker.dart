class ImagePicker {
  static Future<dynamic> pickImage(
      {dynamic source,
      double maxWidth,
      double maxHeight,
      int imageQuality}) async {}

  static Future<dynamic> pickVideo({
    dynamic source,
  }) async {}

  static Future<dynamic> retrieveLostData() async {}
}

enum ImageSource {
  camera,
  gallery,
}
