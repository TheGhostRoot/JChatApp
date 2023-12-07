import 'dart:async';
import 'package:jchatapp/requestHandler.dart';
import 'package:jchatapp/main.dart';
import 'package:crypt/crypt.dart';

class AccountManager {
  static String _handlePassword(
      String password, Map<dynamic, dynamic>? moreSecurity) {
    return Crypt.sha256(password,
            rounds: 100,
            salt: moreSecurity != null
                ? "${moreSecurity}JGVUhiq2qe13r14qfq4h794w"
                : null)
        .hash;
  }

  static Future<bool> createAccount(String? name, String? email,
      String? password, Map<dynamic, dynamic>? moreSecurity) async {
    if (name == null || email == null || password == null) {
      return false;
    }

    if (password.length > 100) {
      throw Exception(
          "Final password is too big! Try removing the extra security or remove some letters from the password.");
    }

    if (name.length > 20) {
      throw Exception("Name must be 20 or less letters.");
    }

    if (email.length > 50) {
      throw Exception("Email must be 50 or less letters.");
    }

    // hash the password
    password = _handlePassword(password, moreSecurity);

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

    String? settingsJwt = ConfigStuff.jwt.generateGlobalJwt(settings, false);
    if (settingsJwt == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["username"] = name;
    claims["email"] = email;
    claims["password"] = password;
    claims["settings"] = settingsJwt;

    String? authToken = ConfigStuff.jwt.generateGlobalJwt(claims, true);
    if (authToken == null) {
      return false;
    }

    String? captcha_data =
        ConfigStuff.cryption.globalEncrypt(ConfigStuff.captcha_id as String);
    if (captcha_data == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authToken;
    header[ConfigStuff.HEADER_CAPTCHA] = captcha_data;

    String? res = await Requests.post(ConfigStuff.server + "/account", headers: header);

    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res, global: true);
    if (data == null) {
      return false;
    }

    if (!data.containsKey("id") || data["id"] == 0) {
      return false;
    }

    ConfigStuff.user_id = data["id"];

    return true;
  }

  static Future<bool> getAccount(String? email, String? password,
      Map<dynamic, dynamic>? moreSecurity, int? id) async {
    Map<dynamic, dynamic> claims = {};
    if (email != null && password != null) {
      claims["email"] = email;
      claims["password"] = _handlePassword(password, moreSecurity);
    } else if (id != null) {
      claims["id"] = id;
    } else {
      return false;
    }

    String? jwt = ConfigStuff.jwt.generateGlobalJwt(claims, true);
    if (jwt == null) {
      return false;
    }

    String? captchaData = ConfigStuff.cryption.globalEncrypt(ConfigStuff.captcha_id as String);
    if (captchaData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = jwt;
    header[ConfigStuff.HEADER_CAPTCHA] = captchaData;

    String? res = await Requests.get(ConfigStuff.server + "/account", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res, global: true);
    if (data == null) {
      return false;
    }

    if (!data.containsKey("encry_key") || !data.containsKey("sig_key") ||
        !data.containsKey("sess_id") || !data.containsKey("id")) {
      return false;
    }

    ConfigStuff.USER_ENCRYP_KEY = data["encry_key"];
    ConfigStuff.USER_SIGN_KEY = data["sig_key"];
    ConfigStuff.sess_id = data["sess_id"];
    ConfigStuff.user_id = data["id"];

    return true;
  }

  static Future<bool> updateAccount(Map<dynamic, dynamic> changes) async {
    String? auth = ConfigStuff.jwt.generateUserJwt(changes);
    if (auth == null) {
      return false;
    }

    String? captcha = ConfigStuff.cryption.userEncrypt(ConfigStuff.captcha_id as String);
    if (captcha == null) {
      return false;
    }


    String? sess_data = ConfigStuff.cryption.userEncrypt(ConfigStuff.sess_id as String);
    if (sess_data == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = auth;
    header[ConfigStuff.HEADER_SESS] = sess_data;
    header[ConfigStuff.HEADER_CAPTCHA] = captcha;

    String? res = await Requests.patch(ConfigStuff.server + "/account", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }
}
