import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ProfileManager {

  static Future<Map<dynamic, dynamic>?> getProfile(int? user_id) async {
    if (user_id == null || ConfigStuff.user_id == 0) {
      return null;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = user_id;

    String? jwtToken = ConfigStuff.jwt.generateUserJwt(claims);
    if (jwtToken == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = jwtToken;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.get(ConfigStuff.server + "/profile", headers: header);
    return ConfigStuff.jwt.getData(res);
  }


  static Future<bool> updateProfile(Map<dynamic, dynamic> changes) async {
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ConfigStuff.jwt.generateUserJwt(changes);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.patch(ConfigStuff.server + "/profile", headers: header);
    if (res == null) {
      return false;
    }

    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }


}