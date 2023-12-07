
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class PostManager {

  static Future<Map<dynamic, dynamic>?> getPosts(int amount) async {
    if (ConfigStuff.user_id == 0) {
      return null;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["amount"] = amount;

    String? authData = ConfigStuff.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.get(ConfigStuff.server + "/posts", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("posts")) {
      return null;
    }

    return data["posts"];
  }


  static Future<int?> createPosts(Map<dynamic, dynamic> data) async {
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

    String? res = await Requests.post(ConfigStuff.server + "/posts", headers: header);
    Map<dynamic, dynamic>? server_data = ConfigStuff.jwt.getData(res);
    if (server_data == null) {
      return null;
    }

    return server_data["id"];
  }

  static Future<bool> updatePosts(Map<dynamic, dynamic> changes) async {
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ConfigStuff.jwt.generateUserJwt(changes);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.patch(ConfigStuff.server + "/posts", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }


    return data["stats"];
  }

  static Future<bool> deletePosts(int post_id) async {
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = post_id;

    String? authData = ConfigStuff.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.delete(ConfigStuff.server + "/posts", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }


    return data["stats"];
  }
}