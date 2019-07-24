# Registrar app localmente 
https://flutter.dev/docs/deployment/android#reference-the-keystore-from-the-app
- Gerar key com 
    - keytool -genkey -v -keystore c:/Users/USER_NAME/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
- criar arq <app dir>/android/key.properties com
~~~
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
~~~
