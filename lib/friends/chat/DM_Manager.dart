import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class DMManager {

  static Future<Map<dynamic, dynamic>?> getMessages(int? channel_id, int amount) async {
    if (ClientAPI.user_id == 0 || channel_id == null || channel_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["channel_id"] = channel_id;
    claims["amount"] = amount;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

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

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.post("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? ser_data = ClientAPI.jwt.getData(res);
    if (ser_data == null || !ser_data.containsKey("message_id")) {
      return null;
    }

    return ser_data["message_id"];
  }


  static Future<bool> editMessage(Map<dynamic, dynamic>? data) async {
    if (ClientAPI.user_id == 0 || data == null) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.patch("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? ser_data = ClientAPI.jwt.getData(res);
    if (ser_data == null || !ser_data.containsKey("stats")) {
      return false;
    }

    return ser_data["stats"];
  }


  static Future<bool> deleteMessage(Map<dynamic, dynamic>? data) async {
    if (ClientAPI.user_id == 0 || data == null) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(data);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.delete("${ClientAPI.server}/friend/chat", headers: header);
    Map<dynamic, dynamic>? ser_data = ClientAPI.jwt.getData(res);
    if (ser_data == null || !ser_data.containsKey("stats")) {
      return false;
    }

    return ser_data["stats"];
  }

}