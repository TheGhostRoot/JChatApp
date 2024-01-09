//import 'package:http_requests/http_requests.dart';

import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jchatapp/main.dart';

class Requests {

  static Future<String?> uploadFile(String url, String method, File file) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse(url));
      request.files.add(http.MultipartFile('file',
          http.ByteStream(DelegatingStream(file.openRead())), file.lengthSync(),
          filename: basename(file.path)));

      var response = await request.send();
      String? res;
      response.stream.transform(utf8.decoder).listen((value) {
        res = value;
      });

      return res;

    } catch (e) {
      return null;
    }
  }


  static Future<String?> get(String url, {Map<String, String>? headers}) async {
   try {
      return (await http.get(Uri.parse(url), headers: ClientAPI.updateHeadersForBody(headers))).body;

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
      return (await http.post(Uri.parse(url), headers: ClientAPI.updateHeadersForBody(headers), body: jsonEncode(body))).body;

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
      return (await http.patch(Uri.parse(url), headers: ClientAPI.updateHeadersForBody(headers), body: jsonEncode(body))).body;

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
      return (await http.delete(Uri.parse(url),
          headers: ClientAPI.updateHeadersForBody(headers), body: jsonEncode(body))).body;

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


  static Future<String?> getProfileAvatarBase64Image({Map<String, String>? headers}) async {
    try {
      return (await http.get(Uri.parse(ClientAPI.pfpUrl),
          headers: ClientAPI.updateHeadersForBody(headers))).body;

    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> getProfileBannerBase64Image({Map<String, String>? headers}) async {
    try {

      return (await http.get(Uri.parse(ClientAPI.bannerUrl),
          headers: ClientAPI.updateHeadersForBody(headers))).body;

    } catch (e) {
      print(e);
      return null;
    }
  }

}