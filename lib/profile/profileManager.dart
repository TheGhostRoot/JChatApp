
import 'package:flutter/src/widgets/image.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ProfileManager {

  static Future<Map<dynamic, dynamic>?> getProfile(int? user_id) async {
    if (user_id == null || ClientAPI.user_id == 0) {
      return null;
    }


    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = user_id;

    String? jwtToken = ClientAPI.jwt.generateUserJwt(claims);
    if (jwtToken == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = jwtToken;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/profile", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null) {
      return null;
    }

    var aboutMe = data["about_me"] as String;

    ClientAPI.user_about_me = aboutMe.isEmpty ? "I am new here. Say hello :)" : aboutMe;
    ClientAPI.user_stats = data["stats"] as String;

    if ((data["pfp"] as String).isNotEmpty) {
      // pfp will be empty if there is no profile pic
      // pfp won't be empty if user sets a picture
      ClientAPI.user_pfp = data["pfp"] as Image;
    }

    if ((data["banner"] as String).isNotEmpty) {
      // banner will be empty if there is no profile pic
      // banner won't be empty if user sets a picture
      ClientAPI.user_banner = data["banner"] as Image;
    }

    return ClientAPI.jwt.getData(res);
  }


  static Future<bool> updateProfile(Map<dynamic, dynamic> changes) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(changes);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.patch("${ClientAPI.server}/profile", headers: header);
    if (res == null) {
      return false;
    }

    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }


}