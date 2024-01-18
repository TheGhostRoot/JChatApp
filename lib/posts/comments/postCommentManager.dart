
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class PostsCommentsManager {


  static Future<Map<dynamic, dynamic>?> getComments(int amount, int postId) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims['amount'] = amount;
    claims['post_id'] = postId;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

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

    String? res = await Requests.post("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("message_id")) {
      return null;
    }

    return serverData["message_id"];
  }

  static Future<bool> updateComments(Map<dynamic, dynamic> data) async {
    if (ClientAPI.user_id == 0) {
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

    String? res = await Requests.patch("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> deleteComments(int postId, int messageId) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["message_id"] = messageId;
    claims["post_id"] = postId;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/posts/comment", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

}