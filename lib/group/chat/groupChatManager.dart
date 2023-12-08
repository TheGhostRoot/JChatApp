

import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class GroupChatManager {

  static Future<Map<dynamic, dynamic>?> getMessages(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.get("${ClientAPI.server}/group/chat", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("messages")) {
      return null;
    }

    return server_data["messages"];
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

    String? res = await Requests.post("${ClientAPI.server}/group/chat", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("message_id")) {
      return null;
    }

    return server_data["message_id"];
  }



  static Future<bool> deleteMassage(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.delete("${ClientAPI.server}/group/chat", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> editMassage(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.patch("${ClientAPI.server}/group/chat", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }

}