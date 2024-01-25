

import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class FriendManager {

  static Future<bool> getFriends() async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt({"idk": true});
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("friends")) {
      return false;
    }

    List<dynamic> allFriends = data["friends"] as List<dynamic>;
    for (var f in allFriends) {
      var ff = f as Map<String, dynamic>;
      ClientAPI.friends.add(Friend(ff["name"], ff["id"], ff["pfpBase64"], ff["channel_id"], ff["stats"], ff["badges"]));
    }
    return true;
  }

  static Future<Map<String, dynamic>?> getFriendRequests() async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? auth_header = ClientAPI.jwt.generateUserJwt({"idk": true});
    if (auth_header == null) {
      return null;
    }

    Map<String, String> header = {};
    header["Friend_requests"] = "1";
    header[ClientAPI.HEADER_SESS] = sess_header;
    header[ClientAPI.HEADER_AUTH] = auth_header;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("friend_requests") || data["friend_requests"] == null) {
      return null;
    }

    return data["friend_requests"] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> getPendingRequests() async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? auth_header = ClientAPI.jwt.generateUserJwt({"idk": true});
    if (auth_header == null) {
      return null;
    }

    Map<String, String> header = {};
    header["Pending_requests"] = "1";
    header[ClientAPI.HEADER_SESS] = sess_header;
    header[ClientAPI.HEADER_AUTH] = auth_header;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("pending_requests") || data["pending_requests"] == null) {
      return null;
    }

    return data["pending_requests"] as Map<String, dynamic>;
  }

  static Future<bool> sendFriendDenyRequest(int friend_id) async {
    if (friend_id == 0 || ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt({"modif": "deny", "friend_id": friend_id});
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

  static Future<bool> sendFriendAcceptRequest(int friend_id) async {
    if (friend_id == 0 || ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    // current friends like ",12,2141,45235"
    String? authData = ClientAPI.jwt.generateUserJwt({"modif": "accept", "friend_id": friend_id});
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

  /*
  static Future<bool> cancelFriendRequest(int friend_id) async {
    if (friend_id == 0 || ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    // current friends like ",12,2141,45235"
    String? authData = ClientAPI.jwt.generateUserJwt({"modif": "cancel", "friend_id": friend_id});
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

   */

  static Future<bool> sendFriendRequest(String friend_name) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt({"modif": "new", "friend_name": friend_name});
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.patch("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }


  static Future<bool> removeFriend(int? friendId) async {
    if (ClientAPI.user_id == 0 || friendId == null || friendId == 0) {
      return false;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["friends"] = ClientAPI.friends;
    claims["friend_id"] = friendId;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.delete("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? serverData = ClientAPI.jwt.getData(res);
    if (serverData == null || !serverData.containsKey("stats")) {
      return false;
    }

    return serverData["stats"];
  }

}