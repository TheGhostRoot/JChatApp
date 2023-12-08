
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class PostsCommentsManager {


  static Future<Map<dynamic, dynamic>?> getComments(int amount, int post_id) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims['amount'] = amount;
    claims['post_id'] = post_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("comments")) {
      return null;
    }

    return data["comments"];
  }

  static Future<int?> createComments(Map<dynamic, dynamic> data) async {
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

    String? res = await Requests.post("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("message_id")) {
      return null;
    }

    return server_data["message_id"];
  }

  static Future<bool> updateComments(Map<dynamic, dynamic> data) async {
    if (ClientAPI.user_id == 0) {
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

    String? res = await Requests.patch("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> deleteComments(int post_id, int message_id) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["message_id"] = message_id;
    claims["post_id"] = post_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.patch("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }

}