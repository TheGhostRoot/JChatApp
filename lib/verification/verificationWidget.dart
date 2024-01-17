import 'dart:io';
import 'dart:math';

import 'package:email_sender/email_sender.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class VerificationPage extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  VerificationPage(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  VerificaionHome createState() => VerificaionHome(data);
}

class VerificaionHome extends State<VerificationPage> {
  var num1Controller = TextEditingController();
  var num2Controller = TextEditingController();
  var num3Controller = TextEditingController();
  var num4Controller = TextEditingController();
  var num5Controller = TextEditingController();

  @override
  void dispose() {
    num1Controller.dispose();
    num2Controller.dispose();
    num3Controller.dispose();
    num4Controller.dispose();
    num5Controller.dispose();
    super.dispose();
  }

  late ClientConfig clientConfig;
  late Map<dynamic, dynamic> data;
  EmailSender emailsender = EmailSender();

  String error = "";
  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String code = "";

  String generateCode(int size) {
    return String.fromCharCodes(Iterable.generate(
        size, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<bool> sendEmail()  async {
    code = generateCode(5);
    var response = await emailsender.sendMessage(data["email"], "JChat Verify Code", "verify code", code);
    return response["message"] == "emailSendSuccess";
  }

  VerificaionHome(Map<dynamic, dynamic> given_data) {
    data = given_data;
    Future.delayed(const Duration(microseconds: 1), () async {
      if (!await sendEmail()) {
        setState(() {
          error = "Can't send email";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //double h = Platform.isAndroid || Platform.isIOS ? 80 : 60;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(54, 54, 54, 100),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
                  const SizedBox(height: 50.0),
                  const Text("Verification",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50)),
                  const SizedBox(height: 30.0),
                  const Text(
                      "Expect an email from us!",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 20)),
                  const SizedBox(height: 20.0),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 25.0),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(
                          height: 80,
                          width: 40,
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: num1Controller,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  hintText: "0",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(54, 54, 54, 100))),
                              onChanged: (text) {
                                if (text.length > 0) {
                                  setState(() {
                                    num1Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                        const SizedBox(width: 30.0),
                        SizedBox(
                          height: 80,
                          width: 40,
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: num2Controller,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  hintText: "0",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(54, 54, 54, 100))),
                              onChanged: (text) {
                                if (text.length > 0) {
                                  setState(() {
                                    num2Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                        const SizedBox(width: 30.0),
                        SizedBox(
                          height: 80,
                          width: 40,
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: num3Controller,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  hintText: "0",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(54, 54, 54, 100))),
                              onChanged: (text) {
                                if (text.length > 0) {
                                  setState(() {
                                    num3Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                        const SizedBox(width: 30.0),
                        SizedBox(
                          height: 80,
                          width: 40,
                          child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: num4Controller,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  hintText: "0",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(54, 54, 54, 100))),
                              onChanged: (text) {
                                if (text.length > 0) {
                                  setState(() {
                                    num4Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                        const SizedBox(width: 30.0),
                        SizedBox(
                          height: 80,
                          width: 40,
                          child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: num5Controller,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  hintText: "0",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(54, 54, 54, 100))),
                              onChanged: (text) {
                                if (text.length > 0) {
                                  setState(() {
                                    num5Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                      ])),

                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () async {
                      String entered_code = num1Controller.text;
                      entered_code += num2Controller.text;
                      entered_code += num3Controller.text;
                      entered_code += num4Controller.text;
                      entered_code += num5Controller.text;

                      if (entered_code == code) {
                        data["forgetPassword"] = true;
                        Navigator.pushNamed(context, data["on_success_path"], arguments: data);

                      } else {
                        data["forgetPassword"] = false;
                        Navigator.pushNamed(context, data["on_fail_path"], arguments: data);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Verify!', style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/welcome", arguments: data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Go Back', style: TextStyle(fontSize: 15.0)),
                  )

        ]))));
  }
}
