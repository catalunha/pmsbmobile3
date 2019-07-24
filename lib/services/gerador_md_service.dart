import 'package:pmsbmibile3/models/models.dart';

class GeradorMdService {
  
  static generateMdFromUsuarioModel(UsuarioModel usuarioModel) {
    return """
${usuarioModel.nome}
=======================

![alt text](${usuarioModel.usuarioArquivoID.url})

### Id: ${usuarioModel.id}
### Celular: ${usuarioModel.celular}
### Email: ${usuarioModel.email}
### Eixo: ${usuarioModel.eixoID.nome}

## Perfil em construção
""";
  }


}
