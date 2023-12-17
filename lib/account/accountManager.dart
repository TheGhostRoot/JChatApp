import 'dart:async';
import 'package:jchatapp/requestHandler.dart';
import 'package:jchatapp/main.dart';
import 'package:crypt/crypt.dart';

class AccountManager {
  static String _handlePassword(String password) {
    return Crypt.sha256(password,
            rounds: 100,
            salt: "JGVUhiq2qe13r14qfq4h794w").hash;
  }

  static Future<bool> createAccount(String? name, String? email, String? password) async {
    if (name == null || email == null || password == null) {
      return false;
    }

    if (password.length > 100) {
      return false;
    }

    if (name.length > 20) {
      return false;
    }

    if (email.length > 50) {
      return false;
    }

    // hash the password
    password = _handlePassword(password);

    /* user settings settings |  for notifications
     change_email
        change_password
        start_sub
        end_sub
        new_message
        edited_message
        new_coins
        new_badges
        deleted_group
        new_owner
        leave
        friend_requests
    */

    Map<dynamic, dynamic> settings = {};
    settings["change_password"] = true;
    settings["start_sub"] = true;
    settings["end_sub"] = true;

    settings["new_message"] = true;
    settings["edited_message"] = true;
    settings["new_coins"] = true;

    settings["new_badges"] = true;
    settings["deleted_group"] = true;
    settings["new_owner"] = true;

    settings["leave"] = true;
    settings["friend_requests"] = true;

    String? settingsJwt = ClientAPI.jwt.generateGlobalJwt(settings, false);
    if (settingsJwt == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["username"] = name;
    claims["email"] = email;
    claims["password"] = password;
    claims["settings"] = settingsJwt;

    String? authToken = ClientAPI.jwt.generateGlobalJwt(claims, true);
    if (authToken == null) {
      return false;
    }

    String? captcha_data =
    ClientAPI.cryption.globalEncrypt(ClientAPI.captcha_id.toString());
    if (captcha_data == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authToken;
    header[ClientAPI.HEADER_CAPTCHA] = captcha_data;

    String? res = await Requests.post("${ClientAPI.server}/account", headers: header);

    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res, global: true);
    if (data == null) {
      return false;
    }

    if (!data.containsKey("id") || data["id"] == 0) {
      return false;
    }

    ClientAPI.user_id = data["id"];

    return true;
  }

  static Future<bool> getAccount(String? email, String? password, int? id) async {
    Map<dynamic, dynamic> claims = {};
    if (email != null && password != null) {
      claims["email"] = email;
      claims["password"] = _handlePassword(password);
    } else if (id != null) {
      claims["id"] = id;
    } else {
      return false;
    }

    String? jwt = ClientAPI.jwt.generateGlobalJwt(claims, true);
    if (jwt == null) {
      return false;
    }

    String? captchaData = ClientAPI.cryption.globalEncrypt(ClientAPI.captcha_id.toString());
    if (captchaData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = jwt;
    header[ClientAPI.HEADER_CAPTCHA] = captchaData;

    String? res = await Requests.get("${ClientAPI.server}/account", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res, global: true);
    if (data == null) {
      return false;
    }

    if (!data.containsKey("encry_key") || !data.containsKey("sig_key") ||
        !data.containsKey("sess_id") || !data.containsKey("id")) {
      return false;
    }

    ClientAPI.USER_ENCRYP_KEY = data["encry_key"];
    ClientAPI.USER_SIGN_KEY = data["sig_key"];
    ClientAPI.sess_id = data["sess_id"];
    ClientAPI.user_id = data["id"];

    return true;
  }

  static Future<bool> updateAccount(Map<dynamic, dynamic> changes) async {
    String? auth = ClientAPI.jwt.generateUserJwt(changes);
    if (auth == null) {
      return false;
    }

    String? captcha = ClientAPI.cryption.userEncrypt(ClientAPI.captcha_id.toString());
    if (captcha == null) {
      return false;
    }


    String? sess_data = ClientAPI.cryption.userEncrypt(ClientAPI.sess_id.toString());
    if (sess_data == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = auth;
    header[ClientAPI.HEADER_SESS] = sess_data;
    header[ClientAPI.HEADER_CAPTCHA] = captcha;

    String? res = await Requests.patch("${ClientAPI.server}/account", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }
}
