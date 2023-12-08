import 'package:encrypt/encrypt.dart';
import 'package:jchatapp/main.dart';

class Cryption {
  static late Key _globalEncryptionKey;
  late Encrypter algorithm;

  Cryption() {
    // Key length 128/192/256 can only be bits.
    _globalEncryptionKey = Key.fromBase64(ClientAPI.globalEncryptionKey);
    algorithm = Encrypter(AES(_globalEncryptionKey, mode: AESMode.ecb));
    //print("Global Encryption Key: ${base64Encode(_globalEncryptionKey)}");
  }

  String? globalEncrypt(String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }

    return algorithm.encrypt(input).base64;
  }

  String? userEncrypt(String? input) {
    if (input == null ||
        input.isEmpty || ClientAPI.USER_ENCRYP_KEY.isEmpty) {
      return null;
    }

    return Encrypter(AES(Key.fromBase64(ClientAPI.USER_ENCRYP_KEY),
        mode: AESMode.ecb)).encrypt(input).base64;
  }

  String? globalDecrypt(String? cipherText) {
    if (cipherText == null || cipherText.isEmpty) {
      return null;
    }

    return algorithm.decrypt64(cipherText);
  }

  String? userDecrypt(String? cipherText) {
    if (cipherText == null ||
        cipherText.isEmpty || ClientAPI.USER_ENCRYP_KEY.isEmpty) {
      return null;
    }

    return Encrypter(AES(Key.fromBase64(ClientAPI.USER_ENCRYP_KEY),
        mode: AESMode.ecb)).decrypt64(cipherText);
  }
}
