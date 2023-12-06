import 'package:encrypt/encrypt.dart';
import 'package:jchatapp/main.dart';

class Cryption {
  static late Key _globalEncryptionKey;
  late Encrypter algorithm;

  Cryption() {
    // Key length 128/192/256 can only be bits.
    _globalEncryptionKey = Key.fromBase64(ConfigStuff.globalEncryptionKey);
    algorithm = Encrypter(AES(_globalEncryptionKey, mode: AESMode.ecb));
    //print("Global Encryption Key: ${base64Encode(_globalEncryptionKey)}");
  }

  String? globalEncrypt(String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }

    return algorithm.encrypt(input).base64;
  }

  String? userEncrypt(String? input, String? key) {
    if (input == null || key == null ||
        input.isEmpty || key.isEmpty) {
      return null;
    }

    return Encrypter(AES(Key.fromBase64(key), mode: AESMode.ecb)).encrypt(input).base64;
  }

  String? globalDecrypt(String? cipherText) {
    if (cipherText == null) {
      return null;
    }


    return algorithm.decrypt64(cipherText);
  }

  String? userDecrypt(String? cipherText, String? key) {
    if (cipherText == null || key == null ||
        cipherText.isEmpty || key.isEmpty) {
      return null;
    }

    return Encrypter(AES(Key.fromBase64(key), mode: AESMode.ecb)).decrypt64(cipherText);
  }
}
