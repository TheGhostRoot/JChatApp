
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class PostsCommentsManager {


  static Future<Map<dynamic, dynamic>?> getComments(int amount, int post_id) async {
    if (ConfigStuff.user_id == 0) {
      return null;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims['amount'] = amount;
    claims['post_id'] = post_id;

    String? authData = ConfigStuff.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.get(ConfigStuff.server + "/posts/comment", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("comments")) {
      return null;
    }

    return data["comments"];
  }

  static Future<int?> createComments(Map<dynamic, dynamic> data) async {
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

    String? res = await Requests.post(ConfigStuff.server + "/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("message_id")) {
      return null;
    }

    return server_data["message_id"];
  }

  static Future<bool> updateComments(Map<dynamic, dynamic> data) async {
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

    String? res = await Requests.patch(ConfigStuff.server + "/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> deleteComments(int post_id, int message_id) async {
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["message_id"] = message_id;
    claims["post_id"] = post_id;

    String? authData = ConfigStuff.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.patch(ConfigStuff.server + "/posts/comment", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }

}