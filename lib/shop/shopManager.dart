
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ShopManager {

  static Future<int?> getItems(int amount) async {
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

    String? res = await Requests.get(ConfigStuff.server + "/shop", headers: header);

    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("items")) {
      return null;
    }

    return data["items"];
  }


  static Future<int?> addItem(Map<dynamic, dynamic> item) async {
    if (ConfigStuff.user_id == 0) {
      return null;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? authData = ConfigStuff.jwt.generateUserJwt(item);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.post(ConfigStuff.server + "/shop", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("item_id")) {
      return null;
    }

    return data["item_id"];
  }


  static Future<bool> updateItem(Map<dynamic, dynamic> changes) async {
    // changes MUST include `id` for the item
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

    String? res = await Requests.patch(ConfigStuff.server + "/shop", headers: header);
    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }

  static Future<bool> deleteItem(int item_id) async {
    if (ConfigStuff.user_id == 0) {
      return false;
    }

    String? sess_header = ConfigStuff.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = item_id;

    String? authData = ConfigStuff.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ConfigStuff.HEADER_AUTH] = authData;
    header[ConfigStuff.HEADER_SESS] = sess_header;

    String? res = await Requests.delete(ConfigStuff.server + "/shop", headers: header);

    Map<dynamic, dynamic>? data = ConfigStuff.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }

}
