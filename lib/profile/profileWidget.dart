import 'dart:convert';

import 'dart:io';
import 'package:jchatapp/requestHandler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/hoverTextWidget.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/navigationWidget.dart';
import 'package:jchatapp/profile/profileManager.dart';
import 'package:video_player/video_player.dart';
//import 'package:video_player_media_kit/video_player_media_kit.dart';

class ProfileScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  ProfileScreen(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  ProfileHome createState() => ProfileHome(data);
}

class ProfileHome extends State<ProfileScreen> {
  late Map<dynamic, dynamic> data;
  late ClientConfig clientConfig;
  late String userStatsDropdown;
  String error = "";
  String suss = "";

  String tempPfpFilePath = "";
  ImageProvider? tempPfpImage;
  String tempPfpBase64 = ClientAPI.user_pfp_base64;

  String tempBannerFilePath = "";
  ImageProvider? tempBannerImage;
  String tempBannerBase64 = ClientAPI.user_banner_base64;

  late Widget pfp_widget;
  late Widget banner_widget;

  late Widget SaveWidget;

  int maxCharactersPerLine = 37;
  int maxLines = 7;

  double pfpRadius = 70;

  VideoPlayerController? videoPlayerControllerPfp;
  VideoPlayerController? videoPlayerControllerBanner;

  late Color stats;
  bool isHovered = false;

  var nameController = TextEditingController();
  var statsController = TextEditingController();
  var aboutMeController = TextEditingController();

  void setupPfpVideo(File? file) {
    if (videoPlayerControllerPfp == null) {
      if (file != null) {
        videoPlayerControllerPfp = VideoPlayerController.file(file);
      } else {
        videoPlayerControllerPfp = VideoPlayerController.networkUrl(
            Uri.parse(ClientAPI.pfpUrl),
            httpHeaders: ClientAPI.getProfileHeaders() ?? {});
      }

      videoPlayerControllerPfp!.setLooping(true);
      videoPlayerControllerPfp!.setVolume(0);
      videoPlayerControllerPfp!.initialize().then((_) => setState(() {}));
      videoPlayerControllerPfp!.play();
    }

    /*
    pfp_widget = AspectRatio(
      aspectRatio: videoPlayerControllerPfp!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          VideoPlayer(videoPlayerControllerPfp!),
          //VideoProgressIndicator(videoPlayerControllerPfp!, allowScrubbing: true),
        ],
      ),
    );

     */
    pfp_widget = CircleAvatar(
        radius: pfpRadius, child: VideoPlayer(videoPlayerControllerPfp!));
    //(radius: 50.0, backgroundColor: const Color.fromRGBO(70, 70, 70, 1), child: VideoPlayer(videoPlayerControllerPfp!));
  }

  void setupPfpVideoWithState(File? file) {
    setState(() {
      if (videoPlayerControllerPfp == null) {
        if (file != null) {
          videoPlayerControllerPfp = VideoPlayerController.file(file);
        } else {
          videoPlayerControllerPfp = VideoPlayerController.networkUrl(
              Uri.parse(ClientAPI.pfpUrl),
              httpHeaders: ClientAPI.getProfileHeaders() ?? {});
        }
        /*
        videoPlayerControllerPfp!.addListener(() {
          setState(() {});
        });

         */
        videoPlayerControllerPfp!.setLooping(true);
        videoPlayerControllerPfp!.setVolume(0);
        videoPlayerControllerPfp!.initialize().then((_) => setState(() {}));
        videoPlayerControllerPfp!.play();
      }

      /*
      pfp_widget = AspectRatio(
        aspectRatio: videoPlayerControllerPfp!.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            VideoPlayer(videoPlayerControllerPfp!),
            //VideoProgressIndicator(videoPlayerControllerPfp!, allowScrubbing: true),
          ],
        ),
      );
       */

      pfp_widget = CircleAvatar(
          radius: pfpRadius, child: VideoPlayer(videoPlayerControllerPfp!));
    });
  }

  void setupBannerVideo(File? file) {
    if (videoPlayerControllerBanner == null) {
      if (file != null) {
        videoPlayerControllerBanner = VideoPlayerController.file(file);
      } else {
        videoPlayerControllerBanner = VideoPlayerController.networkUrl(
            Uri.parse(ClientAPI.bannerUrl),
            httpHeaders: ClientAPI.getProfileHeaders() ?? {});
      }

      videoPlayerControllerBanner!.setLooping(true);
      videoPlayerControllerBanner!.setVolume(0);
      videoPlayerControllerBanner!.initialize().then((_) => setState(() {}));
      videoPlayerControllerBanner!.play();
    }

    /*
    banner_widget = AspectRatio(
      aspectRatio: videoPlayerControllerBanner!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          VideoPlayer(videoPlayerControllerBanner!),
          //VideoProgressIndicator(videoPlayerControllerBanner!, allowScrubbing: true),
        ],
      ),
    );

     */

    banner_widget = Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(70, 70, 70, 1),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            )),
        child: VideoPlayer(videoPlayerControllerBanner!));
  }

  void setupBannerVideoWithState(File? file) {
    setState(() {
      if (videoPlayerControllerBanner == null) {
        if (file != null) {
          videoPlayerControllerBanner = VideoPlayerController.file(file);
        } else {
          videoPlayerControllerBanner = VideoPlayerController.networkUrl(
              Uri.parse(ClientAPI.bannerUrl),
              httpHeaders: ClientAPI.getProfileHeaders() ?? {});
        }
      }
      videoPlayerControllerBanner!.addListener(() {
        setState(() {});
      });

      videoPlayerControllerBanner!.setLooping(true);
      videoPlayerControllerBanner!.setVolume(0);
      videoPlayerControllerBanner!.initialize();
      videoPlayerControllerBanner!.play();

      /*
      banner_widget = AspectRatio(
        aspectRatio: videoPlayerControllerBanner!.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            VideoPlayer(videoPlayerControllerBanner!),
            //VideoProgressIndicator(videoPlayerControllerBanner!, allowScrubbing: true),
          ],
        ),
      );


*/
      banner_widget = Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(70, 70, 70, 1),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
                top: Radius.circular(20.0),
              )),
          child: VideoPlayer(videoPlayerControllerBanner!));
    });
  }

  @override
  void initState() {
    super.initState();
    // 0 = offline
    // 1 = online
    // 2 = ignore
    stats = ClientAPI.user_stats[0] == "0"
        ? Colors.grey
        : (ClientAPI.user_stats[0] == "1" ? Colors.green : Colors.red);
    userStatsDropdown = stats == Colors.grey
        ? 'Offline'
        : (stats == Colors.green ? "Online" : "Ignore");
    clientConfig = data["client_config"] as ClientConfig;
    nameController.text = ClientAPI.user_name;
    statsController.text = ClientAPI.user_stats.substring(1);
    aboutMeController.text = ClientAPI.user_about_me;

    setState(() {
      SaveWidget = getSaveButton();
    });

    if (clientConfig.config["banner-is-video"]) {
      setupBannerVideoWithState(null);

    } else {
      banner_widget = getBannerImage(tempBannerBase64);
      Future.delayed(const Duration(microseconds: 1), () async {
        Widget? widget = await getBannerImageFromServers();
        setState(() {
          banner_widget = widget;
        });
      });
    }

    if (clientConfig.config["pfp-is-video"]) {
      setupPfpVideoWithState(null);

    } else {
      pfp_widget = getAvatarImage(tempPfpBase64);
      Future.delayed(const Duration(microseconds: 1), () async {
        Widget? widget = await getAvatarImageFromServers();
        setState(() {
          pfp_widget = widget;
        });
      });
    }
  }

  ProfileHome(Map<dynamic, dynamic> given_data) {
    // 0 = offline
    // 1 = online
    // 2 = ignore
    data = given_data;
  }

  @override
  void dispose() {
    nameController.dispose();
    statsController.dispose();
    aboutMeController.dispose();
    if (videoPlayerControllerBanner != null) {
      videoPlayerControllerBanner!.dispose();
    }
    if (videoPlayerControllerPfp != null) {
      videoPlayerControllerPfp!.dispose();
    }
    super.dispose();
  }

  List<Widget> getBadges() {
    List<Widget> allBadges = [];
    var UserBadges = ClientAPI.user_badges;
    if (UserBadges.isEmpty || !UserBadges.containsKey("badges")) {
      return allBadges;
    }

    // badges: [{"name": "TEXT", "icon": "name of asset"}, {...}]

    for (Map<dynamic, dynamic> badge
        in (UserBadges["badges"] as List<dynamic>)) {
      allBadges.add(Column(children: [
        CircleAvatar(
          radius: 15.0,
          backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
          backgroundImage: AssetImage(badge["icon"]),
        ),
        Text(badge["name"], style: const TextStyle(color: Colors.white)),
      ]));
      allBadges.add(const SizedBox(width: 10));
    }
    return allBadges;
  }

  Future<Widget> getBannerImageFromServers() async {
    String? img = await Requests.getProfileBannerBase64Image(headers: ClientAPI.getProfileHeaders());
    if (img == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            image: DecorationImage(
                image: Image.memory(base64Decode(img)).image,
                fit: BoxFit.fill)));
  }

  Widget getBannerImage(String img) {
    return Container(
        padding: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            image: DecorationImage(
                image: Image.memory(base64Decode(img)).image,
                fit: BoxFit.fill)));
  }

  Widget getAvatarImage(String img) {
    return CircleAvatar(
      radius: pfpRadius,
      backgroundImage: Image.memory(base64Decode(img)).image,
    );
  }

  Future<Widget> getAvatarImageFromServers() async {
    String? img = await Requests.getProfileAvatarBase64Image(headers: ClientAPI.getProfileHeaders());
    if (img == null) {
      return Container();
    }
    return CircleAvatar(
      radius: pfpRadius,
      backgroundImage: Image.memory(base64Decode(img)).image,
    );
  }

  Widget getSaveButton() {
    return const Text(
      'Save',
      style: TextStyle(fontSize: 18.0),
    );
  }

  Future<String?> pickFile(bool isPfp) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          initialDirectory: "./",
          dialogTitle: isPfp ? "Choose your Avatar" : "Choose your Banner",
          allowedExtensions: ["mp4", "jpg"]);

      if (result != null) {
        // File picked successfully
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.length == 1) {
          File f = files[0];
          // 50MB
          if (f.lengthSync() > 50000000) {
            return null;
          }

          String fileBase64 = base64Encode(f.readAsBytesSync());

          if (f.path.endsWith(".mp4")) {
            // it's video

            if (isPfp) {
              if (fileBase64 == tempPfpBase64) {
                return null;
              }
              tempPfpBase64 = "";
              tempPfpFilePath = "video;${f.path}";
              clientConfig.config["pfp-is-video"] = true;
              setupPfpVideoWithState(f);
            } else {
              if (fileBase64 == tempBannerBase64) {
                return null;
              }
              tempBannerBase64 = "";
              tempBannerFilePath = "video;${f.path}";
              clientConfig.config["banner-is-video"] = true;
              setupBannerVideoWithState(f);
            }

            clientConfig.updateConfig(clientConfig.config);
            return "";
          } else if (f.path.endsWith(".jpg")) {
            if (fileBase64 == tempPfpBase64 || fileBase64 == tempBannerBase64) {
              return null;
            }

            if (isPfp) {
              tempPfpBase64 = fileBase64;
              tempPfpFilePath = f.path;
              clientConfig.config["pfp-is-video"] = false;

            } else {
              tempBannerBase64 = fileBase64;
              tempBannerFilePath = f.path;
              clientConfig.config["banner-is-video"] = false;
            }

            clientConfig.updateConfig(clientConfig.config);

            return base64Encode(f.readAsBytesSync());
          }
        }

        return null;
      }
      return null;

    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
      body: SingleChildScrollView(
          child: Column(
        children: [
          NavigationHome.getTitle(),
          Stack(children: [
            Center(
              child: Container(
                  color: const Color.fromRGBO(70, 70, 70, 1),
                  width: 700,
                  height: 300,
                  child: GestureDetector(
                      onTap: () async {
                        String? img = await pickFile(false);
                        if (img != null && img.isNotEmpty) {
                          setState(() {
                            banner_widget = getBannerImage(img);
                          });
                        }
                      },
                      child: banner_widget)),
            ),
            SizedBox(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Column(
                      children: [
                        const SizedBox(height: 230),
                        GestureDetector(
                          onTap: () async {
                            String? img = await pickFile(true);
                            if (img != null && img.isNotEmpty) {
                              setState(() {
                                pfp_widget = getAvatarImage(img);
                              });
                            }
                          },
                          child: pfp_widget,
                        )
                      ],
                    )))),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 + 25,
              top: 350,
              child: HoverText(
                isRow: true,
                h: 20,
                w: 50,
                text: userStatsDropdown,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: stats,
                ),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.5 + 120,
                top: 300,
                child: DropdownButton<String>(
                  value: userStatsDropdown,
                  icon: const Icon(Icons.menu),
                  dropdownColor: const Color.fromRGBO(50, 50, 50, 1),
                  style: const TextStyle(color: Color.fromRGBO(50, 50, 50, 1)),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        userStatsDropdown = newValue;
                        stats = newValue == "Offline"
                            ? Colors.grey
                            : (newValue == "Online"
                                ? Colors.green
                                : Colors.red);
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem<String>(
                        value: 'Online',
                        child: Text("🟢 Online",
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem<String>(
                        value: 'Offline',
                        child: Text("⚫ Offline",
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem<String>(
                        value: 'Ignore',
                        child: Text("🔴 Ignore",
                            style: TextStyle(color: Colors.white))),
                  ],
                )),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 350,
              top: 300,
              child: Row(children: getBadges()),
            ),
          ]),
          const SizedBox(height: 20),
          Center(
              child: Container(
                  width: 300,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.0),
                        top: Radius.circular(10.0),
                      )),
                  child: TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white)),
                  ))),
          Center(
              child: Container(
                  width: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.0),
                        top: Radius.circular(10.0),
                      )),
                  child: TextField(
                    controller: statsController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Stats',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: "Stats",
                        labelStyle: const TextStyle(color: Colors.white)),
                  ))),
          const SizedBox(height: 20),
          const Center(
              child: Text("About me",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          Center(
              child: Container(
                  width: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.0),
                        top: Radius.circular(10.0),
                      )),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: aboutMeController,
                    maxLines: 7,
                    minLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Tell us about you',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: "About Me",
                        labelStyle: const TextStyle(color: Colors.white)),
                    onChanged: (text) {
                      List<String> lines = text.split('\n');
                      if (lines.length > maxLines) {
                        setState(() {
                          lines.removeRange(maxLines, lines.length);
                          aboutMeController.text = lines.join("\n");
                        });
                      }

                      List<String> updatedLines = [];

                      for (String line in lines) {
                        if (line.length > maxCharactersPerLine) {
                          updatedLines
                              .add(line.substring(0, maxCharactersPerLine));
                        } else {
                          updatedLines.add(line);
                        }
                      }

                      setState(() {
                        aboutMeController.text = updatedLines.join('\n');
                      });
                    },
                  ))),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // TODO add 2fa
              data["on_success_path"] = "/2fa";
              data["on_fail_path"] = "/home";
              data["2fa"] = true;
              Navigator.pushNamed(context, "/2fa", arguments: data);
            },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.only(left: 30, right: 30)
              ),
              child: const Text(
                'Change Email',
                style: TextStyle(fontSize: 18.0),
              )),

          Text(error, style: const TextStyle(color: Colors.red)),
          Text(suss, style: const TextStyle(color: Colors.green)),
          ElevatedButton(
            onPressed: () async {
              // save the changes if any
              Map<dynamic, dynamic> changes = {};
              var mode = (stats == Colors.green
                  ? "1"
                  : (stats == Colors.grey ? "0" : "2"));
              if (nameController.text != ClientAPI.user_name &&
                  nameController.text.isNotEmpty) {
                changes["name"] = nameController.text;
              }

              if (mode + statsController.text != ClientAPI.user_stats) {
                // 0 = offline
                // 1 = online
                // 2 = ignore
                changes["stats"] = mode + statsController.text;
              }

              if (aboutMeController.text != ClientAPI.user_about_me &&
                  aboutMeController.text.isNotEmpty) {
                changes["about_me"] = aboutMeController.text;
              }

              if (tempPfpBase64.isEmpty ||
                  tempPfpBase64 != ClientAPI.user_pfp_base64) {
                changes["pfp"] = tempPfpFilePath;
              }

              if (tempBannerBase64.isEmpty ||
                  tempBannerBase64 != ClientAPI.user_banner_base64) {
                changes["banner"] = tempBannerFilePath;
              }

              if (changes.isNotEmpty) {
                setState(() {
                  SaveWidget = LoadingAnimationWidget.prograssiveDots(
                      color: Colors.white,
                      size: 30);
                });
                if (await ProfileManager.updateProfile(changes)) {
                  setState(() {
                    SaveWidget = getSaveButton();
                    suss = "Saved successfully";
                  });
                  if (changes.containsKey("pfp")) {
                    ClientAPI.user_pfp_base64 = tempPfpBase64;
                  }

                  if (changes.containsKey("banner")) {
                    ClientAPI.user_banner_base64 = tempBannerBase64;
                  }

                  if (changes.containsKey("about_me")) {
                    ClientAPI.user_about_me = aboutMeController.text;
                  }

                  if (changes.containsKey("stats")) {
                    ClientAPI.user_stats = mode + statsController.text;
                  }

                  if (changes.containsKey("name")) {
                    ClientAPI.user_name = nameController.text;
                  }
                } else {
                  setState(() {
                    SaveWidget = getSaveButton();
                    error = "Failed to save changes";
                    tempPfpImage =
                        Image.memory(base64Decode(ClientAPI.user_pfp_base64))
                            .image;
                    tempBannerImage =
                        Image.memory(base64Decode(ClientAPI.user_banner_base64))
                            .image;
                  });
                }
              } else {
                setState(() {
                  error = "Can't save unchanged fields";
                  tempPfpImage =
                      Image.memory(base64Decode(ClientAPI.user_pfp_base64))
                          .image;
                  tempBannerImage =
                      Image.memory(base64Decode(ClientAPI.user_banner_base64))
                          .image;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.only(left: 30, right: 30)
            ),
            child: SaveWidget
          ),
          const SizedBox(height: 30),
        ],
      )),
    );
  }
}
