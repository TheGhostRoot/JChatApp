

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