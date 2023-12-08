//import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';



import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/security/cryptionHandler.dart';
import 'package:jchatapp/security/jwtHandler.dart';


// import 'package:yaml/yaml.dart';

class ClientAPI {

  static String globalEncryptionKey = "P918nfQtYhbUzJVbmSQfZw==";
  static String globalSignKey = "hGqlbRo8IbgSh24eblzVZWnOk9Iue9cXKegLhnHAGyKV9HkKhmYQPE2QBpxfJmfri9UO7iAj9mZhJhm6E4Fx4Wxv5m/cHaxKASn0duiwBMHYt0ZEa6ViOFr2b62hVBfSQS3xvC0XDqRx+5rAG+vDwvoAUTSsT9Owhd9KJnrWEmJv0rrpY0+4qQbcRKbPhWJrB3ULWjnQuRvJS2Hwr7P/AvIrnFngC9QtNDOvLj/lzG9gHA5MSHws+/a2ZAe2mAI0AAvfYEPwemZy0r9JhHhqi+zcpFTarRqTEP51fXtjwRSoLgcbXxIbh5awM6h05+83NQV8L3cMfpANOyNATO/bBqzg+nU+y69AtVmpjXZpMaqXFAhUqVoVsuHP2Nc6UhPfjkps5Pt6Ho2kjEJotf1cDBXX6RTTxhJ95aL/lHKpNVw/sEBuzwyOqFwp1BMNuzED";

  static String server = "http://11111:1111/api/v1";

  static Cryption cryption = Cryption();
  static JwtHandle jwt = JwtHandle();

  static String USER_SIGN_KEY = "";
  static String USER_ENCRYP_KEY = "";
  static String HEADER_AUTH = "Authorization";
  static String HEADER_SESS = "SessionID";
  static String HEADER_CAPTCHA = "CapctchaID";

  static int captcha_id = 0;
  static int user_id = 0;
  static int sess_id = 0;


  static List friends = <Friend>[];

  static String? getSessionHeader() {
    return cryption.userEncrypt(user_id as String);
  }

  static String? getCaptchaHeader() {
    return cryption.globalEncrypt(captcha_id as String);
  }

}

void main() {


  // runApp(const MyApp());
}






