
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class GroupManager {

  static Future<Map<dynamic, dynamic>?> getGroups(int amount) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["amount"] = amount;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/group", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("groups")) {
      return null;
    }

    return data["groups"];
  }


  static Future<int?> createGroups(Map<dynamic, dynamic> data) async {
    if (ClientAPI.user_id == 0) {
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

    String? res = await Requests.post("${ClientAPI.server}/group", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("group_id")) {
      return null;
    }

    return server_data["group_id"];
  }


  static Future<int?> updateGroups(Map<dynamic, dynamic> changes) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changes);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.patch("${ClientAPI.server}/group", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("group_id")) {
      return null;
    }

    return server_data["group_id"];
  }

  static Future<bool> deleteGroups(int? group_id) async {
    if (ClientAPI.user_id == 0 || group_id == null || group_id == 0) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["group_id"] = group_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.delete("${ClientAPI.server}/group", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }
}