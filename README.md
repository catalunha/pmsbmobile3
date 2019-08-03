# pmsbmibile3/pmsbdartflutter

PMSB Versão Dart/Flutter

## Configurações

### Firebase

Entre no console do firebase e faça download do arquivo e coloqueo `android/app/google-services.json`

### Assinatura
[Referencia](https://flutter.dev/docs/deployment/android)

Se ainda não tiver uma chave para assinatura do app crie uma com o seguinte comando:

```keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key```

Tenha certeza que o arquivo key.properties existe em `<app dir>/android/key.properties` com o seguinte conteúdo:

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
```
