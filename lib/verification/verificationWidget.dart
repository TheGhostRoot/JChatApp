import 'dart:async';
import 'dart:math';

import 'package:email_sender/email_sender.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class VerificationPage extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  VerificationPage(Map<dynamic, dynamic> given_data, {super.key}) {
    data = given_data;
  }

  @override
  VerificaionHome createState() => VerificaionHome(data);
}

class VerificaionHome extends State<VerificationPage> {
  late Map<dynamic, dynamic> data;

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
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  late ClientConfig clientConfig;
  EmailSender emailsender = EmailSender();

  String error = "";
  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String code = "";

  Timer? _timer;
  int _start = ClientAPI.verification_time_seconds;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        try {
          if (_start == 0) {
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              _start--;
            });
          }
        } catch(e) {
          return;
        }
      },
    );
  }

  String generateCode(int size) {
    return String.fromCharCodes(Iterable.generate(
        size, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<bool> sendEmail()  async {
    code = generateCode(5);
    var response = await emailsender.sendMessage(data["email"], "JChat Verify Code", "verify code", "Your Verification Code is $code");
    return response["message"] == "emailSendSuccess";
  }

  VerificaionHome(Map<dynamic, dynamic> gdata) {
    data = gdata;
    startTimer();
    Future.delayed(const Duration(microseconds: 1), () async {
      if (!await sendEmail()) {
        try {
          setState(() {
            error = "Can't send email";
          });
        } catch(e) {
          return;
        }
      }
    });
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
                                if (text.isNotEmpty) {
                                  setState(() {
                                    num1Controller.text = text[0];
                                    if (text.length == 5) {
                                      num2Controller.text = text[1];
                                      num3Controller.text = text[2];
                                      num4Controller.text = text[3];
                                      num5Controller.text = text[4];
                                    }
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
                                if (text.isNotEmpty) {
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
                                if (text.isNotEmpty) {
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
                                if (text.isNotEmpty) {
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
                                if (text.isNotEmpty) {
                                  setState(() {
                                    num5Controller.text = text[0];
                                  });
                                }
                              }),
                        ),
                      ])),

                  const SizedBox(height: 10.0),
                  Text(_start == 0 ? "Expired!" : "${_printDuration(Duration(seconds: _start))} Time Left",
                      style: _start == 0 ? const TextStyle(color: Colors.red, fontSize: 20) :
                      const TextStyle(color: Colors.green, fontSize: 20)),
                  const SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: () async {

                      if (_start <= 0) {
                        data["captcha_stats"] = false;
                        Navigator.pushNamed(context, data["verify_on_fail_path"], arguments: data);
                        return;
                      }

                      String enteredCode = num1Controller.text;
                      enteredCode += num2Controller.text;
                      enteredCode += num3Controller.text;
                      enteredCode += num4Controller.text;
                      enteredCode += num5Controller.text;

                      if (enteredCode == code) {
                        data["captcha_stats"] = true;
                        Navigator.pushNamed(context, data["verify_on_success_path"], arguments: data);

                      } else {
                        data["captcha_stats"] = false;
                        Navigator.pushNamed(context, data["verify_on_fail_path"], arguments: data);
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
                      Navigator.pushNamed(context, data["on_fail_path"], arguments: data);
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
