import 'dart:collection';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/security/cryptionHandler.dart';

class JwtHandle {
  late Cryption _cryptionHandle;
  late SecretKey _globalSecretKey;

  JwtHandle() {
    _globalSecretKey = SecretKey(ConfigStuff.globalSignKey);
    _cryptionHandle = new Cryption();

    //print("Global Sign Key: " + ConfigStuff.globalSignKey);
  }

  Map<dynamic, dynamic>? getData(String jwt, String? encryptionKey, String? signKey) {
    return encryptionKey == null && signKey == null
        ? getGlobalClaims(_cryptionHandle.globalDecrypt(jwt))
        : getUserClaims(
        _cryptionHandle.userDecrypt(jwt, encryptionKey!), signKey);
  }

  Map<String, Object>? getDataNoEncryption(String? jwt) {
    final all = getGlobalClaims(jwt);
    return all != null ? HashMap.from(all) : null;
  }

  Map<dynamic, dynamic>? getGlobalClaims(String? jwtToken) {  // HS256
    if (jwtToken == null) {
      return null;
    }


    Map<dynamic, dynamic>? claims;
    try {
      claims = JWT.verify(jwtToken, _globalSecretKey).payload;

    } catch (e) {
      claims = null;
    }
    return claims;
  }

  Map<dynamic, dynamic>? getUserClaims(String? jwt, String? signKey) {
    if (jwt == null || signKey == null) {
      return null;
    }

    Map<dynamic, dynamic>? claims;
    try {
      claims = JWT.verify(jwt, SecretKey(signKey)).payload;

    } catch (e) {
      claims = null;
    }
    return claims;
  }

  String? generateGlobalJwt(Map<dynamic, dynamic> claims, bool encrypted) {

     return encrypted ?
     _cryptionHandle.globalEncrypt(JWT(claims).trySign(_globalSecretKey, noIssueAt: true)) :
     JWT(claims).trySign(_globalSecretKey, noIssueAt: true);

  }

  String? generateUserJwt(Map<dynamic, dynamic> claims, String? signatureKey,
      String? encryptionKey) {
    if (signatureKey == null || signatureKey.isEmpty) {
      return null;
    }

    if (encryptionKey != null && encryptionKey.isNotEmpty) {
      return _cryptionHandle.userEncrypt(JWT(claims).trySign(SecretKey(signatureKey), noIssueAt: true), encryptionKey);
    }

    return JWT(claims).trySign(SecretKey(signatureKey), noIssueAt: true);

  }
}
