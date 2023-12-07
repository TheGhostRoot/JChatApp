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

  Map<dynamic, dynamic>? getData(String? jwt, {bool global = false}) {
    return global ? getGlobalClaims(_cryptionHandle.globalDecrypt(jwt))
        : getUserClaims(_cryptionHandle.userDecrypt(jwt));
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

  Map<dynamic, dynamic>? getUserClaims(String? jwt) {
    if (jwt == null || ConfigStuff.USER_SIGN_KEY.isEmpty) {
      return null;
    }

    Map<dynamic, dynamic>? claims;
    try {
      claims = JWT.verify(jwt, SecretKey(ConfigStuff.USER_SIGN_KEY)).payload;

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

  String? generateUserJwt(Map<dynamic, dynamic> claims) {
    if (ConfigStuff.USER_SIGN_KEY.isEmpty) {
      return null;
    }

    if (ConfigStuff.USER_ENCRYP_KEY.isNotEmpty) {
      return _cryptionHandle.userEncrypt(JWT(claims).trySign(SecretKey(ConfigStuff.USER_SIGN_KEY), noIssueAt: true));
    }

    return JWT(claims).trySign(SecretKey(ConfigStuff.USER_SIGN_KEY), noIssueAt: true);

  }
}
