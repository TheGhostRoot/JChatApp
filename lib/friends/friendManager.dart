

import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class FriendManager {

  static Future<Map<dynamic, dynamic>?> getFriends() async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sessHeader = ClientAPI.getSessionHeader();
    if (sessHeader == null) {
      return null;
    }

    String allFriends = "";
    for (Friend friend in ClientAPI.friends) {
      if (friend.id != null) {
        allFriends += ",${friend.id}";
      }
    }

    if (allFriends.isEmpty) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["friends"] = allFriends;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sessHeader;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    return ClientAPI.jwt.getData(res);

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
    header["friend_requests"] = "1";
    header[ClientAPI.HEADER_SESS] = sess_header;
    header[ClientAPI.HEADER_AUTH] = auth_header;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("friend_requests") || data["friend_requests"] == null) {
      return null;
    }

    return data["friend_requests"] as Map<String, dynamic>;
  }


  static Future<bool> sendFriendRequest(Map<dynamic, dynamic> data) async {
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