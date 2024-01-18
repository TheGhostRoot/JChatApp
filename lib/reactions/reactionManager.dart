import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ReactionManager {


  static Future<Map<dynamic, dynamic>?> getReactions(Map<dynamic, dynamic> data) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return null;
    }


    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.get("${ClientAPI.server}/reaction", headers: header);
    return ClientAPI.jwt.getData(res);
  }


  static Future<bool> removeReactions(Map<dynamic, dynamic> data) async {
    // data MUST include `reaction`
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.delete("${ClientAPI.server}/reaction", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats"))  {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> addReaction(Map<dynamic, dynamic> data) async {
    // data MUST include `reaction`
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.post("${ClientAPI.server}/reaction", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats"))  {
      return false;
    }

    return serverData["stats"];
  }


}