import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class DMManager {

  static Future<Map<dynamic, dynamic>?> getMessages(int? channelId, int amount) async {
    if (ClientAPI.user_id == 0 || channelId == null || channelId == 0) {
      return null;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["channel_id"] = channelId;
    claims["amount"] = amount;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.get("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("messages")) {
      return null;
    }

    return data["messages"];
  }


  static Future<int?> sendMessage(Map<dynamic, dynamic>? data) async {
    if (ClientAPI.user_id == 0 || data == null) {
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

    String? res = await Requests.post("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? serData = ClientAPI.jwt.getData(res);
    if (serData == null || !serData.containsKey("message_id")) {
      return null;
    }

    return serData["message_id"];
  }


  static Future<bool> editMessage(Map<dynamic, dynamic>? data) async {
    if (ClientAPI.user_id == 0 || data == null) {
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

    String? res = await Requests.patch("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? serData = ClientAPI.jwt.getData(res);
    if (serData == null || !serData.containsKey("stats")) {
      return false;
    }

    return serData["stats"];
  }


  static Future<bool> deleteMessage(Map<dynamic, dynamic>? data) async {
    if (ClientAPI.user_id == 0 || data == null) {
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

    String? res = await Requests.delete("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? serData = ClientAPI.jwt.getData(res);
    if (serData == null || !serData.containsKey("stats")) {
      return false;
    }

    return serData["stats"];
  }

}