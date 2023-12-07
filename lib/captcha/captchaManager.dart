import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class CaptchaManager {


  static Future<String?> getCaptcha() async {
    Map<dynamic, dynamic> map = {};
    map["z"] = "a";

    String? jwtToken = ConfigStuff.jwt.generateGlobalJwt(map, true);
    if (jwtToken == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = jwtToken;
    
    String? res = await Requests.get(ConfigStuff.server + "/captcha", headers: header);
    if (res == null) {
      return null;
    }
    
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res, global: true);
    if (data == null || !data.containsKey("captcha_id") || !data.containsKey("captcha_image")) {
      return null;
    }

    ConfigStuff.captcha_id = data["captcha_id"];

    // base 64
    return data["captcha_image"];

  }


  static Future<bool> solveCaptcha(String? answer) async {
    if (answer == null) {
      return false;
    }

    Map<dynamic, dynamic> map = {};
    map["answer"] = answer;

    String? jwtToken = ConfigStuff.jwt.generateGlobalJwt(map, true);
    if (jwtToken == null) {
      return false;
    }

    String? captcha_data = ConfigStuff.getCaptchaHeader();
    if (captcha_data == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = jwtToken;
    header[ConfigStuff.HEADER_CAPTCHA] = captcha_data;

    String? res = await Requests.post(ConfigStuff.server + "/captcha", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res, global: true);
    if (data == null || data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }

}