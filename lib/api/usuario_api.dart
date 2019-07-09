import 'dart:async';
import 'package:pmsbmibile3/models/usuario_model.dart';

abstract class UsuarioApi{
  Stream<UsuarioModel> getSnapshotsById(String id);
  Future<UsuarioModel> getById(String id);

  Stream<List<UsuarioModel>> whereSnapshots(List<Map<dynamic, dynamic>> where);
  Future<List<UsuarioModel>> where(List<Map<dynamic, dynamic>> where);

  void setData(String id, Map<dynamic, dynamic> map);
}