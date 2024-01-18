import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class GroupCategoryManager {

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

    String? res = await Requests.get("${ClientAPI.server}/group/category", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("categories")) {
      return null;
    }

    return serverData["categories"];
  }


  static Future<bool> createChannels(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.post("${ClientAPI.server}/group/category", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> editChannels(Map<dynamic, dynamic>? changes) async {
    if (ClientAPI.user_id == 0 || changes == null) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changes);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/group/category", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> deleteChannels(Map<dynamic, dynamic>? data) async {
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

    String? res = await Requests.delete("${ClientAPI.server}/group/category", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

}