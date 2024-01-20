import 'dart:convert';
import 'dart:async';
//import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:jchatapp/captcha/captchaManager.dart';
import 'package:jchatapp/main.dart';

class CaptchaScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  CaptchaScreen(Map<dynamic, dynamic> given_data, {super.key}) {
    data = given_data;
  }

  @override
  CaptchaHome createState() => CaptchaHome(data);
}

class CaptchaHome extends State<CaptchaScreen> {
  String? captcha_base64;
  String error = "";

  late Map<dynamic, dynamic> data;

  Timer? _timer;
  int _start = ClientAPI.captcha_time;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Visibility vis = const Visibility(child: SizedBox.shrink());

  late double w;
  late double h;

  CaptchaHome(Map<dynamic, dynamic> given_data) {
    var size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    w = size.width;
    h = size.height;
    data = given_data;
    vis = const Visibility(
      visible: false,
      child: SizedBox.shrink(),
    );

    Future.delayed(const Duration(microseconds: 1), () async {
      String? captcha = await CaptchaManager.getCaptcha();
      if (captcha == null) {
        error = "Can't get captcha";
        return;
      }
      setState(() {
        captcha_base64 = captcha;
        vis = Visibility(
            visible: captcha_base64 != null,
            child: captcha_base64 != null
                ?  DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: MemoryImage(base64Decode(captcha_base64!)),
                ),
              ),
            )
                : const SizedBox.shrink(),
        );
        startTimer();
      });
    });



  }

  var captchaController = TextEditingController();

  @override
  void dispose() {
    captchaController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(54, 54, 54, 100),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          const SizedBox(height: 30.0),
          const Text("Captcha",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50)),
          Text(error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 50.0),
          SizedBox(
            //width: Platform.isAndroid || Platform.isIOS ? 350 : 1000,
            width: MediaQuery.of(context).orientation == Orientation.portrait ? h / 5 : w / 3,
            height: 200,
            child: vis,
          ),
          const SizedBox(height: 20.0),
          Text(_start == 0 ? "Expired!" : "$_start Seconds Left",
              style: _start == 0 ? const TextStyle(color: Colors.red, fontSize: 20) :
              const TextStyle(color: Colors.green, fontSize: 20)),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 200.0,
            child: TextField(
              controller: captchaController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Captcha Code',
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              if (_start > 0 && await CaptchaManager.solveCaptcha(captchaController.text)) {
                data["captcha_stats"] = true;
                Navigator.pushNamed(context, data["on_success_path"], arguments: data);

              } else {
                data["captcha_stats"] = false;
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
              child: Text('Solve!', style: TextStyle(fontSize: 18.0),
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
        ])),
      ),
    );
  }
}
