
import 'package:jchatapp/main.dart';
import 'package:jchatapp/requestHandler.dart';

class ShopManager {

  static Future<int?> getItems(int amount) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    Map<dynamic, dynamic> claims = {};
    claims["amount"] = amount;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.get("${ClientAPI.server}/shop", headers: header);

    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("items")) {
      return null;
    }

    return data["items"];
  }


  static Future<int?> addItem(Map<dynamic, dynamic> item) async {
    if (ClientAPI.user_id == 0) {
      return null;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return null;
    }

    String? authData = ClientAPI.jwt.generateUserJwt(item);
    if (authData == null) {
      return null;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.post("${ClientAPI.server}/shop", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("item_id")) {
      return null;
    }

    return data["item_id"];
  }


  static Future<bool> updateItem(Map<dynamic, dynamic> changes) async {
    // changes MUST include `id` for the item
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

    String? res = await Requests.patch("${ClientAPI.server}/shop", headers: header);
    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }

  static Future<bool> deleteItem(int item_id) async {
    if (ClientAPI.user_id == 0) {
      return false;
    }

    String? sess_header = ClientAPI.getSessionHeader();
    if (sess_header == null) {
      return false;
    }

    Map<dynamic, dynamic> claims = {};
    claims["id"] = item_id;

    String? authData = ClientAPI.jwt.generateUserJwt(claims);
    if (authData == null) {
      return false;
    }

    Map<String, String> header = {};
    header[ClientAPI.HEADER_AUTH] = authData;
    header[ClientAPI.HEADER_SESS] = sess_header;

    String? res = await Requests.delete("${ClientAPI.server}/shop", headers: header);

    Map<dynamic, dynamic>? data = ClientAPI.jwt.getData(res);
    if (data == null || !data.containsKey("stats")) {
      return false;
    }

    return data["stats"];
  }

}
