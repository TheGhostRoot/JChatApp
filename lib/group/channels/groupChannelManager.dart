import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class GroupChannelManager {

  static Future<Map<dynamic, dynamic>?> getChannels(int? groupId) async {
    if (ClientAPI.user_id == 0 || groupId == null || groupId == 0) {
      return null;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["group_id"] = groupId;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.get("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("channels")) {
      return null;
    }

    return serverData["channels"];
  }


  static Future<int?> createChannel(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.post("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("channel_id")) {
      return null;
    }

    return serverData["channel_id"];
  }


  static Future<bool> editChannel(Map<dynamic, dynamic>? changed) async {
    if (ClientAPI.user_id == 0 || changed == null) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changed);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> deleteChannel(Map<dynamic, dynamic>? changed) async {
    if (ClientAPI.user_id == 0 || changed == null) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changed);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.delete("${ClientAPI.server}/group/channel", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


}