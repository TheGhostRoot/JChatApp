//import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:email_sender/email_sender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:jchatapp/account/accountManager.dart';
import 'package:jchatapp/account/accountRegisterWidget.dart';
import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/navigationWidget.dart';
import 'package:jchatapp/profile/profileManager.dart';
import 'package:jchatapp/requestHandler.dart';
import 'package:jchatapp/security/cryptionHandler.dart';
import 'package:jchatapp/security/jwtHandler.dart';
import 'package:jchatapp/verification/verificationWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:jchatapp/captcha/captchaWidget.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:yaml/yaml.dart';

// android:usesCleartextTraffic="true"  -> AndroidMainfest.xml
// <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

/*
  <manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
    <application android:usesCleartextTraffic="true"></aplication>
</manifest>

buildTypes {
        release {
            ndk {
                abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86_64'
            }
        }
    }

https://pub.dev/packages/video_player
https://pub.dev/packages/video_viewer
   */

class ClientAPI {
  static String globalEncryptionKey = "P918nfQtYhbUzJVbmSQfZw==";
  static String globalSignKey =
      "sE1MHHQ/R3LsxNeb3+Lr/xHHQAI83VvXk+YEsTqiNhsfNV7ihj+FcFvQW3pvieZtPKaMQw60vADIPEP0bM16WtycxtWTH0bevIXwWk/Kw+rCnI/mrOGKjSy9wFymceHCMwk03GNSWqBwzOLMrVCXIbFTZ8wNj1nQHHvrEU5Ihx3M=";

  static String host = "192.168.0.215:25500";
  static String server = "http://$host/api/v1";

  static late Cryption cryption;
  static late JwtHandle jwt;

  static late String user_banner_base64;
  static late String user_pfp_base64;

  static String bannerUrl = "${ClientAPI.server}/profile/banner?redirected=false&type=";
  static String pfpUrl = "${ClientAPI.server}/profile/avatar?redirected=false&type=";

  static String USER_SIGN_KEY = "";
  static String USER_ENCRYP_KEY = "";
  static String HEADER_AUTH = "Authorization";
  static String HEADER_SESS = "SessionID";
  static String HEADER_CAPTCHA = "CaptchaID";

  static int captcha_id = 0;
  static int captcha_time = 20;
  static int verification_time_seconds = 600;
  static String resetPasswordKey = "6RDt7fFTD7TFuvyg86RFY";
  static int user_id = 0;
  static String user_name = "";
  static String user_email = "";
  static Map<String, Object> user_badges = {};
  static String user_about_me = "";
  static String user_stats = "0";
  static int sess_id = 0;

  static List friends = <Friend>[];

  static Future<void> SetUp() async {
      cryption = Cryption();
      jwt = JwtHandle();

      user_pfp_base64 = await getDefaultPfp();
      user_banner_base64 = await getDefaultBanner();
  }

  static Future<String> getDefaultPfp() async {
    ByteData pfpData = await rootBundle.load(ClientConfig.default_avatar);
    return base64Encode(Uint8List.fromList(img.encodePng(img.decodeImage(Uint8List.fromList(pfpData.buffer.asUint8List()))!)));
  }

  static Future<String> getDefaultBanner() async {
    ByteData bannerData = await rootBundle.load(ClientConfig.black_box);
    return base64Encode(Uint8List.fromList(img.encodePng(img.decodeImage(Uint8List.fromList(bannerData.buffer.asUint8List()))!)));
  }

  static String? getSessionHeader() {
    return cryption.globalEncrypt(sess_id.toString());
  }

  static Map<String, String>? getProfileHeaders() {
    String? authHeader = ClientAPI.jwt.generateGlobalJwt({"id": ClientAPI.user_id}, true);
    //String? sessHeader = ClientAPI.getSessionHeader();
    if (authHeader == null) {
      return null;
    }

    return {ClientAPI.HEADER_AUTH: authHeader,
        "Host": ClientAPI.host, "Accept": "*/*"};
  }

  static Map<String, String>? getProfileHeadersWithRememberMe(int rememberMe) {
    String? authHeader = ClientAPI.jwt.generateGlobalJwt({"id": rememberMe}, true);
    //String? sessHeader = ClientAPI.getSessionHeader();
    if (authHeader == null) {
      return null;
    }

    return {ClientAPI.HEADER_AUTH: authHeader,
      "Host": ClientAPI.host, "Accept": "*/*"};
  }

  static Map<String, String>? updateHeadersForBody(Map<String, String>? headers) {
    if (headers == null) {
      return null;
    }
    //headers["Content-Length"] = getContentLen(body);
    //headers["Accept-Encoding"] = "gzip, deflate, br";
    headers["Content-Type"] = "application/json";
    headers["Host"] = host;
    //headers["Accept"] = "*/*";
    return headers;
  }

  static String getContentLen(dynamic body) {
    return utf8.encode(body.toString()).length.toString();
  }

  static String? getCaptchaHeader() {
    return cryption.globalEncrypt(captcha_id.toString());
  }
}

class ClientConfig {
  late Map<dynamic, dynamic> config;
  late String path;

  static String logo = "images/logo.jpg";
  static String welcome_background = "images/welcome_background2.jpg";
  static String black_box = "images/black.jpg";
  static String default_avatar = "images/pfp.jpg";


  static late String configPath;

  Map<dynamic, dynamic> getDefaultConfig() {
    Map<dynamic, dynamic> conf = {};
    conf["remember_me"] = {};
    conf["remember_me"]["pfp"] = null;
    conf["remember_me"]["id"] = 0;

    //conf["pfp-is-video"] = false;
    //conf["banner-is-video"] = false;

    return conf;
  }

  ClientConfig() {
    config = getDefaultConfig();
    Future.delayed(const Duration(microseconds: 1), () async {
      var tempAppDocDir = await getApplicationDocumentsDirectory();
      path = "${tempAppDocDir.path}\\JChat";
      configPath = "$path\\config.txt";

      File newFile = File(configPath);

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
    });
  }

  bool updateConfig(Map<dynamic, dynamic> updatedConfig) {
    try {
      File newFile = File(configPath);
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
      final lines = File(configPath).readAsLinesSync();
      config = lines.isNotEmpty
          ? ClientAPI.jwt.getData(lines[0], global: true) ?? getDefaultConfig()
          : getDefaultConfig();
    } catch (e) {}
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ClientAPI.SetUp();

  if (await Permission.manageExternalStorage.request().isDenied) {
    return;
  }

  // Platform.isWindows ? "C:\\JChat" : (Platform.isLinux || Platform.isMacOS || Platform.isFuchsia ? "\\home\\etc\\JChat" : (Platform.isAndroid ? "Android\\data\\JChat" : "Documents\\JChat"))

  ClientConfig clientConfig = ClientConfig();

  Map<dynamic, dynamic> map = {};
  map["client_config"] = clientConfig;


  VideoPlayerMediaKit.ensureInitialized(
    macOS: true,
    windows: true,
    linux: true,
    android: true,
    iOS: true
  );

  String? bad = ClientAPI.jwt.generateGlobalJwt({"badges": [{"name": "Chipi Chapa", "icon": "images/chipichapa_badge.jpg"},
    {"name": "Bug Hunter", "icon": "images/bughunter_badge.jpg"},
    {"name": "Staff", "icon": "images/staff_badge.jpg"},
    {"name": "Supporter", "icon": "images/supporter_badge.jpg"}]}, false);

  print(bad);


  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JChat(map),
      routes: <String, WidgetBuilder>{
        "/captcha": (BuildContext context) => CaptchaScreen(map),

        "/welcome": (BuildContext context) => JChat(map),

        "/register": (BuildContext context) => AccountRegisterScreen(map),

        "/home": (BuildContext context) => NavigationScreen(map),

        "/verify": (BuildContext context) => VerificationPage(map),
      }));
}

class JChat extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  JChat(Map<dynamic, dynamic> given_data, {super.key}) {
    data = given_data;
  }

  @override
  _WelcomePage createState() => _WelcomePage(data);
}

class _WelcomePage extends State<JChat> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isRememberMe = false;


  void setupPfpVideo(double pfpRadius, int id) {
    VideoPlayerController videoPlayerControllerPfp = VideoPlayerController.networkUrl(
                Uri.parse(ClientAPI.pfpUrl),
                httpHeaders: ClientAPI.getProfileHeadersWithRememberMe(id) ?? {});
        videoPlayerControllerPfp.setLooping(true);
        videoPlayerControllerPfp.setVolume(0);
        videoPlayerControllerPfp.initialize().then((_) => setState(() => {}));
        videoPlayerControllerPfp.play();


        pfp_widget = SizedBox(height: pfpRadius * 2, width: pfpRadius * 2, child: ClipRRect(
          borderRadius: BorderRadius.circular(60.0),
          clipBehavior: Clip.hardEdge,
          child: VideoPlayer(videoPlayerControllerPfp), // It's highly advisable to use this behavior to improve performance.
        ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  late ClientConfig clientConfig;
  late Map<dynamic, dynamic> data;
  String error = "";

  String errorForgetPassword = "";
  String successForgetPassword = "";

  bool _passwordVisible = false;

  Widget? pfp_widget;
  String? pfp_base64_remember_me;

  _WelcomePage(Map<dynamic, dynamic> given_data) {
    data = given_data;
    clientConfig = data["client_config"] as ClientConfig;
    Future.delayed(const Duration(microseconds: 1), () async {
      if (data.containsKey("forgetPassword_password") && data["captcha_stats"]) {
          if (await AccountManager.getAccount(data["email"], null, null)) {
            setState(() {
              successForgetPassword = "Successfully changed password";
            });

          } else {
            setState(() {
              errorForgetPassword = "Failed to change password";
            });
          }


        data.remove("captcha_stats");
        data.remove("email");
        data.remove("on_success_path");
        data.remove("on_fail_path");
        data.remove("verify_on_success_path");
        data.remove("verify_on_fail_path");
        data.remove("forgetPassword_password");
      }
      if (clientConfig.config["remember_me"]["pfp"] != null) {
        Map<dynamic, dynamic>? map = await ProfileManager.getProfile(clientConfig.config["remember_me"]["id"]);
        if (map != null && (map["pfp"] as String).startsWith("video;")) {
          setupPfpVideo(70, clientConfig.config["remember_me"]["id"]);

        } else {
          pfp_base64_remember_me = await Requests.getProfileAvatarBase64Image(
              headers: ClientAPI.getProfileHeadersWithRememberMe(
                  clientConfig.config["remember_me"]["id"]));
          pfp_base64_remember_me ??= await ClientAPI.getDefaultPfp();
          setState(() {
            pfp_widget = Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan,
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: Image
                      .memory(base64Decode(pfp_base64_remember_me!))
                      .image,
                ),
              ),
            );
          });
        }
      }
      if (data.containsKey("captcha_stats") && data["captcha_stats"]) {
        if (data.containsKey("resetLocalData")) {
          var map = clientConfig.getDefaultConfig();
          data["client_config"] = ClientConfig();
          clientConfig.updateConfig(map);
          setState(() {
            successForgetPassword = "Successfully reset local data";
          });

        } else if (data.containsKey("email") && data.containsKey("password")) {
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
            Map<dynamic, dynamic>? map = await ProfileManager.getProfile(ClientAPI.user_id);
            if (isRememberMe) {
              if (map != null) {
                var pfp = map["pfp"] as String;
                ClientConfig clientConfig = (data["client_config"] as ClientConfig);
                if (pfp.isEmpty) {
                  clientConfig.config["remember_me"]["pfp"] =
                  await ClientAPI.getDefaultPfp();

                } else if (pfp.startsWith("video;")) {
                  clientConfig.config["remember_me"]["pfp"] = "video;";

                } else {
                  clientConfig.config["remember_me"]["pfp"] =
                      pfp_base64_remember_me ?? await ClientAPI.getDefaultPfp();
                }

                clientConfig.config["remember_me"]["id"] = ClientAPI.user_id;
                clientConfig.updateConfig(clientConfig.config);
              }

            }

            if (map != null) {
              data["pfp-is-video"] = (map["pfp"] as String).startsWith("video;");
              data["banner-is-video"] = (map["banner"] as String).startsWith("video;");

              data.remove("captcha_stats");
              data.remove("email");
              data.remove("password");
              data.remove("on_success_path");
              data.remove("on_fail_path");

              Navigator.pushNamed(context, "/home", arguments: data);
            }
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

            Map<dynamic, dynamic>? map =  await ProfileManager.getProfile(ClientAPI.user_id);
            if (map  != null) {
              data["pfp-is-video"] = (map["pfp"] as String).startsWith("video;");
              data["banner-is-video"] = (map["banner"] as String).startsWith("video;");

              Navigator.pushNamed(context, "/home", arguments: data);
            }
          }
        }
      }
    });
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

  void loginWithEmailAndPassword(BuildContext context)  {
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

  void resetPassword(BuildContext context) {
    if (emailController.text.isEmpty) {
      setState(() {
        error = "Enter the email of the account";
      });
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        error = "Enter the new password of the account";
      });
      return;
    }
    data["verify_on_success_path"] = "/captcha";
    data["verify__on_fail_path"] = "/welcome";
    data["on_success_path"] = "/welcome";
    data["on_fail_path"] = "/welcome";
    data["forgetPassword_password"] = passwordController.text;
    data["email"] = emailController.text;
    Navigator.pushNamed(context, "/verify", arguments: data);
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ClientConfig.welcome_background),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  const SizedBox(height: 30.0),
                  Container(
                    //height: Platform.isWindows || Platform.isMacOS ? 800 : 870,
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
                          child: Image.asset(ClientConfig.logo,
                            width: 150.0,
                            height: 150.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 100.0,
                          child: pfp_widget != null ? GestureDetector(
                                      onTap: () {
                                        loginWithRememberMe();
                                      },
                                      child: pfp_widget
                                )
                              : null,
                        ),
                        const SizedBox(height: 20.0),
                        Text(error, style: const TextStyle(color: Colors.red)),

                        const SizedBox(height: 10.0),
                        SizedBox(
                            width: 200.0,
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  hintText: "Email",
                                  labelText: "Email",
                                  hintStyle: const TextStyle(color: Color.fromRGBO(54, 54, 54, 100))),
                            ),
                          ),

                        const SizedBox(height: 20.0),
                        SizedBox(width: 200.0,
                            child: TextField(
                              textInputAction: TextInputAction.done,
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
                                  hintStyle: const TextStyle(color: Color.fromRGBO(54, 54, 54, 100))),
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
                        //const SizedBox(height: 20.0),
                        Text(errorForgetPassword, style: const TextStyle(color: Colors.red)),
                        Text(successForgetPassword, style: const TextStyle(color: Colors.green)),
                        Center(
                          child: InkWell(
                            child: const Text('Forgot password?',
                            style: TextStyle(color: Colors.blue)),
                            onTap: () async {
                              resetPassword(context);
                            }
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (emailController.text.isEmpty || !EmailSender().checkEmail(emailController.text)) {
                              setState(() {
                                error = "Valid email required";
                              });
                              return;
                            }

                            if (passwordController.text.isEmpty) {
                              setState(() {
                                error = "Password required";
                              });
                              return;
                            }
                            loginWithEmailAndPassword(context);
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
                        const SizedBox(height: 30.0),
                        Center(
                          child: InkWell(
                              child: const Text('Reset Local Data',
                                  style: TextStyle(color: Colors.red)),
                              onTap: ()  {
                                data["on_success_path"] = "/welcome";
                                data["on_fail_path"] = "/welcome";
                                data["resetLocalData"] = true;
                                Navigator.pushNamed(context, "/captcha", arguments: data);
                              }
                          ),
                        ),
                        const SizedBox(height: 30.0),
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
