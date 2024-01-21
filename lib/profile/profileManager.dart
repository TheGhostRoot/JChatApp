import 'dart:io';

import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ProfileManager {

  static Future<Map<dynamic, dynamic>?> getProfile(int? userId) async {
    if (userId == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = userId;

    String? jwtToken = ClientAPI.jwt.generateGlobalJwt(claims, true);
    if (jwtToken == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = jwtToken;

    String? res = await Requests.get("${ClientAPI.server}/profile", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res, global: true);
    if (data == null) {
      return null;
    }

    var aboutMe = data["about_me"] as String;

    ClientAPI.user_about_me = aboutMe.isEmpty ? "I am new here. Say hello :)" : aboutMe;
    ClientAPI.user_stats = data["stats"] as String;

    if ((data["badges"] as String).isNotEmpty) {
      // badges will be empty if there is no profile badges
      // badges won't be empty if user sets a badges
      ClientAPI.user_badges = ClientAPI.jwt.getDataNoEncryption((data["badges"] as String)) ?? {};
    }

    return data;
  }


  static Future<bool> updateProfile(Map<dynamic, dynamic> changes) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }


    String? path;
    bool isVideo = false;
    bool isPfp = false;

    bool? stats;


    if (changes.containsKey("banner")) {
      String banner = changes["banner"] as String;
      if (banner.startsWith("video;")) {
        path = banner.substring(6);
        isVideo = true;

      } else {
        path = banner;
      }

      String? res = await Requests.uploadFile("${ClientAPI.server}/profile?video=$isVideo&pfp=$isPfp&id=${ClientAPI.user_id}", "POST", File(path));
      Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res, global: true);
      if (data == null || !data.containsKey("stats")) {
        return false;
      }

      stats = data["stats"];
    }

    if (changes.containsKey("pfp")) {
      String pfp = changes["pfp"] as String;
      isPfp = true;
      if (pfp.startsWith("video;")) {
        path = pfp.substring(6);
        isVideo = true;

      } else {
        path = pfp;
      }

      String? res = await Requests.uploadFile("${ClientAPI.server}/profile?video=$isVideo&pfp=$isPfp&id=${ClientAPI.user_id}", "POST", File(path));
      Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res, global: true);
      if (data == null || !data.containsKey("stats")) {
        return false;
      }

      if (stats == null) {
        stats = data["stats"];

      } else {
        stats = stats && data["stats"];
      }
    }

    if (changes.containsKey("about_me") || changes.containsKey("stats") || changes.containsKey("name")) {
      String? authData = ClientAPI.jwt.generateUserJwt(changes);
      if (authData == null) {
        if (stats != null) {
          return stats;

        } else {
          return false;
        }
      }

      String? res2 = await Requests.patch("${ClientAPI.server}/profile",
          headers: {
            ClientAPI.HEADER_AUTH: authData,
            ClientAPI.HEADER_SESS: ClientAPI.getSessionHeader() ?? 'a'
          });

      Map<dynamic, dynamic>? d = ClientAPI.jwt.getData(res2);
      if (d == null || !d.containsKey("stats")) {
        return false;
      }

      if (stats == null) {
        return d["stats"];

      } else {
        return stats && d["stats"];
      }


    } else {
      if (stats != null) {
        return stats;

      } else {
        return false;
      }
    }
  }


}


/*
// for now I will add badges
              // badges: [{"name": "TEXT", "icon": "name of asset"}, {...}]

              Map<dynamic, dynamic> badges1 = {
                "name": "Dev",
                "icon": "images/dev_badge.png"
              };

              Map<dynamic, dynamic> badges2 = {
                "name": "Supporter",
                "icon": "images/supporter_badge.png"
              };

              List<Map<dynamic, dynamic>> allBadges = [badges1, badges2];

              Map<dynamic, dynamic> finalMap = {"badges": allBadges};

              String? jwtBadges = ClientAPI.jwt.generateGlobalJwt(finalMap, false);
              if (jwtBadges == null) {
                return;
              }

              Map<dynamic, dynamic> claims = {
                "badges": jwtBadges
              };

              String? authJWT = ClientAPI.jwt.generateUserJwt(claims);
              if (authJWT == null) {
                return;
              }

              String? sess_header = ClientAPI.getSessionHeader();
              if (sess_header == null) {
                return;
              }

              Map<String, String> header = {
                ClientAPI.HEADER_AUTH: authJWT,
                ClientAPI.HEADER_SESS: sess_header
              };

              String? res = await Requests.patch(ClientAPI.server + "/profile", headers: header);
              Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
 */