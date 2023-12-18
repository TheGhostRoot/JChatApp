//import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jchatapp/account/accountManager.dart';
import 'package:jchatapp/account/accountRegisterWidget.dart';
import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/navigationWidget.dart';
import 'package:jchatapp/security/cryptionHandler.dart';
import 'package:jchatapp/security/jwtHandler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jchatapp/captcha/captchaWidget.dart';

// import 'package:yaml/yaml.dart';

class ClientAPI {
  static String globalEncryptionKey = "P918nfQtYhbUzJVbmSQfZw==";
  static String globalSignKey =
      "sE1MHHQ/R3LsxNeb3+Lr/xHHQAI83VvXk+YEsTqiNhsfNV7ihj+FcFvQW3pvieZtPKaMQw60vADIPEP0bM16WtycxtWTH0bevIXwWk/Kw+rCnI/mrOGKjSy9wFymceHCMwk03GNSWqBwzOLMrVCXIbFTZ8wNj1nQHHvrEU5Ihx3M=";

  static String server = "http://192.168.0.215:25500/api/v1";

  static late Cryption cryption;
  static late JwtHandle jwt;

  static void SetUp() {
    cryption = Cryption();
    jwt = JwtHandle();
  }

  static String USER_SIGN_KEY = "";
  static String USER_ENCRYP_KEY = "";
  static String HEADER_AUTH = "Authorization";
  static String HEADER_SESS = "SessionID";
  static String HEADER_CAPTCHA = "CapctchaID";

  static int captcha_id = 0;
  static int captcha_time = 20;
  static int user_id = 0;
  static String user_pfp = "";
  static String user_banner = "";
  static String user_name = "";
  static String user_bio = "";
  static String user_stats = "";
  static int sess_id = 0;

  static List friends = <Friend>[];

  static String? getSessionHeader() {
    return cryption.userEncrypt(user_id.toString());
  }

  static String? getCaptchaHeader() {
    return cryption.globalEncrypt(captcha_id.toString());
  }
}

class ClientConfig {
  late Map<dynamic, dynamic> config;
  late String path;

  Map<dynamic, dynamic> getDefaultConfig() {
    Map<dynamic, dynamic> conf = {};
    conf["remember_me"] = {};
    conf["remember_me"]["pfp"] = "";
    conf["remember_me"]["id"] = 0;

    return conf;
  }

  ClientConfig(String? given_path) {
    config = getDefaultConfig();
    if (given_path == null) {
      return;
    }
    path = given_path;

    File newFile = File("$path\\config.txt");

    if (!newFile.existsSync()) {
      Directory(path).createSync();
      newFile.createSync();
      String? configData = ClientAPI.jwt.generateGlobalJwt(config, true);
      if (configData != null) {
        newFile.writeAsStringSync(configData);
      }
      return;
    }
    readConfig(path);
  }

  bool updateConfig(Map<dynamic, dynamic> updatedConfig) {
    try {
      File newFile = File("$path\\config.txt");
      if (newFile.existsSync()) {
        String? configData = ClientAPI.jwt.generateGlobalJwt(updatedConfig, true);

        if (configData != null) {
          newFile.writeAsStringSync(configData);
          return true;
        }
      }

      return false;

    } catch (e) {
      return false;
    }
  }

  void readConfig(String path) {
    try {
      final lines = File("$path\\config.txt").readAsLinesSync();
      config = lines.isNotEmpty
          ? ClientAPI.jwt.getData(lines[0], global: true) ?? getDefaultConfig()
          : getDefaultConfig();
    } catch (e) {}
  }
}


void main() {
  // "C:\\JChat"
  ClientAPI.SetUp();
  ClientConfig clientConfig = ClientConfig(null);
  /*
  * By default you would have to integrate your background service on a platform specific way.

But I found this package that handles the native integration mostly for you: flutter_background_service.

final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
Code snippet taken from the package example here.

How to add the package to your project:

Open your pubspec.yaml file
Add flutter_background_service: ^2.4.3 to your dependency section
Run flutter pub get
  *
  *
  * */

  Map<dynamic, dynamic> map = {};
  map["client_config"] = clientConfig;

  // TODO fix a bug on server side `captcha_time` is not updating.

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JChat(map),
      routes: <String, WidgetBuilder>{
        "/captcha": (BuildContext context) => CaptchaScreen(map),

        "/welcome": (BuildContext context) => JChat(map),

        "/register": (BuildContext context) => AccountRegisterScreen(map),

        "/home": (BuildContext context) => NavigationScreen(map)
      }));
}

class JChat extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  JChat(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  _WelcomePage createState() => _WelcomePage(data);
}

class _WelcomePage extends State<JChat> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isRememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  late ClientConfig clientConfig;
  late Map<dynamic, dynamic> data;
  String error = "";
  bool _passwordVisible = false;
// android:usesCleartextTraffic="true"  -> AndroidMainfest.xml
  // <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

  _WelcomePage(Map<dynamic, dynamic> given_data) {
    data = given_data;
    clientConfig = data["client_config"] as ClientConfig;
    if (data.containsKey("captcha_stats") && data["captcha_stats"]) {
      Future.delayed(const Duration(seconds: 1), () async {
        if (data.containsKey("email") && data.containsKey("password")) {
          if (!await AccountManager.getAccount(data["email"], data["password"], null)) {
            setState(() {
              error = "Can't login to this account";
            });
            data.remove("captcha_stats");
            data.remove("email");
            data.remove("password");
            data.remove("on_success_path");
            data.remove("on_fail_path");

          } else {
            if (!isRememberMe) {
              ClientConfig clientConfig = (data["client_config"] as ClientConfig);
              clientConfig.config["remember_me"]["id"] = ClientAPI.user_id;
              clientConfig.config["remember_me"]["pfp"] = ClientAPI.user_pfp;
              clientConfig.updateConfig(clientConfig.config);
            }

            data.remove("captcha_stats");
            data.remove("email");
            data.remove("password");
            data.remove("on_success_path");
            data.remove("on_fail_path");
            Navigator.pushNamed(context, "/home", arguments: data);
          }

        } else if (data.containsKey("remember_me_id")) {
          if (!await AccountManager.getAccount(null, null, data["remember_me_id"])) {
            setState(() {
              error = "Can't login to this account";
            });
            data.remove("captcha_stats");
            data.remove("email");
            data.remove("password");
            data.remove("on_success_path");
            data.remove("on_fail_path");

          } else {
            data.remove("captcha_stats");
            data.remove("remember_me_id");
            data.remove("on_success_path");
            data.remove("on_fail_path");
            Navigator.pushNamed(context, "/home", arguments: data);
          }
        }
      });
    }
  }


  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains) || isRememberMe) {
      return Colors.blue;
    }
    return Colors.white;
  }

  void loginWithEmailAndPassword()  {
    data["on_success_path"] = "/welcome";
    data["on_fail_path"] = "/welcome";
    data["password"] = passwordController.text;
    data["email"] = emailController.text;
    Navigator.pushNamed(context, "/captcha", arguments: data);
  }

  void loginWithRememberMe()  {
    data["on_success_path"] = "/welcome";
    data["on_fail_path"] = "/welcome";
    data["remember_me_id"] = clientConfig.config["remember_me"]["id"] as int;
    Navigator.pushNamed(context, "/captcha", arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/welcome_background2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  const SizedBox(height: 30.0),
                  Container(
                    height: 810,
                    width: 300,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20.0),
                        top: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Image.asset('images/Logo.png',
                            width: 150.0,
                            height: 150.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 100.0,
                          child: clientConfig.config["remember_me"]["pfp"].toString().isNotEmpty ? GestureDetector(
                                      onTap: () {
                                        loginWithRememberMe();
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.cyan,
                                        ),
                                        child: Center(
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: MemoryImage(base64Decode(clientConfig.config["remember_me"]['pfp']),
                                            ),
                                          ),
                                        ),
                                      ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 20.0),
                        Text(error, style: const TextStyle(color: Colors.red)),

                        const SizedBox(height: 10.0),
                        //const Text("Email                                        ", style: TextStyle(color: Colors.white)),
                        //const SizedBox(height: 10.0),
                        SizedBox(
                            width: 200.0,
                            child: TextField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  hintText: 'Email',
                                  labelText: "Email",
                                  hintStyle: const TextStyle(color: Colors.blueGrey)),

                            ),
                          ),

                        const SizedBox(height: 20.0),
                        //const Text("Password                                 ", style: TextStyle(color: Colors.white)),
                        //const SizedBox(height: 10.0),
                        SizedBox(width: 200.0,
                            child: TextField(
                              obscureText: !_passwordVisible,
                              style: const TextStyle(color: Colors.white),
                              controller: passwordController,
                              decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(color: Colors.blueGrey)),
                            ),
                          ),

                        const SizedBox(height: 10.0),

                        Wrap(
                          children: <Widget>[
                            const Text("Remember Me?", style: TextStyle(color: Colors.white, fontSize: 15)),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                              value: isRememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value != null) {
                                    isRememberMe = value;
                                  }
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: InkWell(
                            child: const Text('Forgot password?',
                                style: TextStyle(color: Colors.blue)),
                            onTap: () async => await launchUrl(
                              Uri.parse(
                                  'https://docs.flutter.io/flutter/services/UrlLauncher-class.html'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (emailController.text.isEmpty) {
                              setState(() {
                                error = "Email required";
                              });
                              return;
                            }

                            if (passwordController.text.isEmpty) {
                              setState(() {
                                error = "Password required";
                              });
                              return;
                            }
                            loginWithEmailAndPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Log In',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/register", arguments: data);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Register',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
