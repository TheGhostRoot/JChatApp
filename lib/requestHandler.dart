import 'package:http_requests/http_requests.dart';

class Requests {

  static Future<String?> get(String url, {Map<String, String>? headers}) async {
    try {
      return await HttpRequests
          .get(url, headers: headers)
          .content;

    } catch (e) {
      return null;
    }
  }

  static Future<String?> post(String url, {Map<String, String>? headers}) async {
    try {

      return await HttpRequests
          .post(url, headers: headers)
          .content;

    } catch (e) {
      return null;
    }
  }

  static Future<String?> patch(String url, {Map<String, String>? headers}) async {
    try {
      return await HttpRequests
          .patch(url, headers: headers)
          .content;

    } catch (e) {
      return null;
    }
  }

  static Future<String?> delete(String url, {Map<String, String>? headers}) async {
    try {
      return await HttpRequests
          .delete(url, headers: headers)
          .content;

    } catch (e) {
      return null;
    }
  }

}