//import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';



import 'package:jchatapp/security/cryptionHandler.dart';
import 'package:jchatapp/security/jwtHandler.dart';


// import 'package:yaml/yaml.dart';

class ConfigStuff {

  static String globalEncryptionKey = "P918nfQtYhbUzJVbmSQfZw==";
  static String globalSignKey = "hGqlbRo8IbgSh24eblzVZWnOk9Iue9cXKegLhnHAGyKV9HkKhmYQPE2QBpxfJmfri9UO7iAj9mZhJhm6E4Fx4Wxv5m/cHaxKASn0duiwBMHYt0ZEa6ViOFr2b62hVBfSQS3xvC0XDqRx+5rAG+vDwvoAUTSsT9Owhd9KJnrWEmJv0rrpY0+4qQbcRKbPhWJrB3ULWjnQuRvJS2Hwr7P/AvIrnFngC9QtNDOvLj/lzG9gHA5MSHws+/a2ZAe2mAI0AAvfYEPwemZy0r9JhHhqi+zcpFTarRqTEP51fXtjwRSoLgcbXxIbh5awM6h05+83NQV8L3cMfpANOyNATO/bBqzg+nU+y69AtVmpjXZpMaqXFAhUqVoVsuHP2Nc6UhPfjkps5Pt6Ho2kjEJotf1cDBXX6RTTxhJ95aL/lHKpNVw/sEBuzwyOqFwp1BMNuzED";

}

void main() {
  Cryption cryption = new Cryption();
  JwtHandle jwtHandle = new JwtHandle();

  // runApp(const MyApp());
}






