

import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class FriendManager {

  static Future<Map<dynamic, dynamic>?> getFriends() async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String all_friends = "";
    for (Friend friend in ClientAPI.friends) {
      if (friend.id != null) {
        all_friends += ",${friend.id}";
      }
    }

    if (all_friends.isEmpty) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["friends"] = all_friends;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/friend", headers: header);
    return ClientAPI.jwt.getData(res);

  }


  static Future<bool> sendFriendRequest(Map<dynamic, dynamic> data) async {
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

    String? res = await Requests.patch("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }


  static Future<bool> removeFriend(int? friend_id) async {
    if (ClientAPI.user_id == 0 || friend_id == null || friend_id == 0) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["friends"] = ClientAPI.friends;
    claims["friend_id"] = friend_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.delete("${ClientAPI.server}/friend", headers: header);
    Map<dynamic, dynamic>? server_data = ClientAPI.jwt.getData(res);
    if (server_data == null || !server_data.containsKey("stats")) {
      return false;
    }

    return server_data["stats"];
  }

}