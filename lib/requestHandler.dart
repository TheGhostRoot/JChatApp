//import 'package:http_requests/http_requests.dart';

import 'package:http/http.dart' as http;

class Requests {

  static Future<String?> get(String url, {Map<String, String>? headers}) async {
   try {
      return (await http.get(Uri.parse(url), headers: headers)).body;

    } catch (e) {
      return null;
    }
 /*
    try {
      return (await HttpRequests.get(url, headers: headers, timeout: 30) as HttpResponse).content;

    } catch (e) {
      return null;
    }*/
  }

  static Future<String?> post(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      return (await http.post(Uri.parse(url), headers: headers, body: body)).body;

    } catch (e) {
      return null;
    }
/*
    try {

      return (await HttpRequests.post(url, headers: headers, data: body, timeout: 30) as HttpResponse).content;

    } catch (e) {
      print(e);
      return null;
    }*/
  }

  static Future<String?> patch(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      return (await http.patch(Uri.parse(url), headers: headers, body: body)).body;

    } catch (e) {
      return null;
    }
/*
    try {
      return (await HttpRequests.patch(url, headers: headers, data: body, timeout: 30) as HttpResponse).content;

    } catch (e) {
      return null;
    }*/
  }

  static Future<String?> delete(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
   try {
      return (await http.delete(Uri.parse(url), headers: headers, body: body)).body;

    } catch (e) {
      return null;
    }
 /*
    try {
      return (await HttpRequests.delete(url, headers: headers, data: body, timeout: 30) as HttpResponse).content;

    } catch (e) {
      return null;
    }*/
  }

}