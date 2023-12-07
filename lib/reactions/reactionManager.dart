import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ReactionManager {


  static Future<Map<dynamic, dynamic>?> getReactions(Map<dynamic, dynamic> data) async {
    if (ConfigStuff.user_id == 0) {
      return null;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return null;
    }


    String? authData = ConfigStuff.jwt.generateUserJwt(data);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.get(ConfigStuff.server + "/reaction", headers: header);
    return ConfigStuff.jwt.getData(res);
  }


  static Future<bool> removeReactions(Map<dynamic, dynamic> data) async {
    // data MUST include `reaction`
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ConfigStuff.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.delete(ConfigStuff.server + "/reaction", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats"))  {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> addReaction(Map<dynamic, dynamic> data) async {
    // data MUST include `reaction`
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ConfigStuff.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.post(ConfigStuff.server + "/reaction", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats"))  {
      return false;
    }

    return server_data["stats"];
  }


}