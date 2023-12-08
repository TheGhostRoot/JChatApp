import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class GroupChannelManager {

  static Future<Map<dynamic, dynamic>?> getChannels(int? group_id) async {
    if (ClientAPI.user_id == 0 || group_id == null || group_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["group_id"] = group_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("channels")) {
      return null;
    }

    return server_data["channels"];
  }


  static Future<int?> createChannel(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.post("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("channel_id")) {
      return null;
    }

    return server_data["channel_id"];
  }


  static Future<bool> editChannel(Map<dynamic, dynamic>? changed) async {
    if (ClientAPI.user_id == 0 || changed == null) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changed);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.patch("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> deleteChannel(Map<dynamic, dynamic>? changed) async {
    if (ClientAPI.user_id == 0 || changed == null) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changed);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.delete("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


}