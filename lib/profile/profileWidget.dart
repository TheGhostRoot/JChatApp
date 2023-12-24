
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:jchatapp/hoverTextWidget.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/navigationWidget.dart';
import 'package:jchatapp/profile/profileManager.dart';

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

  String tempPfpBase64 = ClientAPI.user_pfp_base64;
  String tempBannerBase64 = ClientAPI.user_banner_base64;

  int maxCharactersPerLine = 37;
  int maxLines = 7;


  late Color stats;
  bool isHovered = false;

  var nameController = TextEditingController();
  var statsController = TextEditingController();
  var aboutMeController = TextEditingController();

  ProfileHome(Map<dynamic, dynamic> given_data) {
    // 0 = offline
    // 1 = online
    // 2 = ignore
    stats = ClientAPI.user_stats[0] == "0" ? Colors.grey : (ClientAPI.user_stats[0] == "1" ? Colors.green : Colors.red);
    userStatsDropdown = stats == Colors.grey ? 'Offline' : (stats == Colors.green ? "Online" : "Ignore");
    data = given_data;
    clientConfig = data["client_config"] as ClientConfig;
    nameController.text = ClientAPI.user_name;
    statsController.text = ClientAPI.user_stats.substring(1);
    aboutMeController.text = ClientAPI.user_about_me;
  }

  @override
  void dispose() {
    nameController.dispose();
    statsController.dispose();
    aboutMeController.dispose();
    super.dispose();
  }

  List<Widget> getBadges() {
    List<Widget> allBadges = [];
    var UserBadges = ClientAPI.user_badges;
    if (UserBadges.isEmpty || !UserBadges.containsKey("badges")) {
      return allBadges;
    }

    // badges: [{"name": "TEXT", "icon": "name of asset"}, {...}]

    for (Map<dynamic, dynamic> badge in (UserBadges["badges"] as List<dynamic>)) {
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

  Future<String?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        // File picked successfully
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.length == 1) {
          File f = files[0];
          // 50MB for both video and image.
          if (f.lengthSync() > 50000000) {
            return null;
          }

          return base64Encode(f.readAsBytesSync());
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
      body: SingleChildScrollView(child: Column(
        children: [
          NavigationHome.getTitle(),
          Stack(children: [
              SizedBox(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                       color: const Color.fromRGBO(70, 70, 70, 1),
                        width: double.infinity,
                        height: 200,
                        child: GestureDetector(
                          onTap: () async {
                            String? img = await pickFile();
                            if (img != null) {
                              setState(() {
                                tempBannerBase64 = img;
                              });
                            }
                          },
                          child: Container(decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20.0),
                                top: Radius.circular(20.0),
                              ),
                              image: DecorationImage(
                                  image: Image.memory(base64Decode(tempBannerBase64)).image,
                                  fit: BoxFit.fill)))
                        ))),
              ),
              SizedBox(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Column(children: [
                  const SizedBox(height: 150),
                  GestureDetector(
                    onTap: () async {
                      String? img = await pickFile();
                      if (img != null) {
                        setState(() {
                          tempPfpBase64 = img;
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
                          radius: 50.0,
                          backgroundImage: Image.memory(base64Decode(tempPfpBase64)).image,
                        ),
                      )],
                )
              ))),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 + 25,
              top: 230,
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
            top: 220,
              child: DropdownButton<String>(
            value: userStatsDropdown,
            icon: const Icon(Icons.menu),
            dropdownColor: const Color.fromRGBO(50, 50, 50, 1),
            style: const TextStyle(color: Color.fromRGBO(50, 50, 50, 1)),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  userStatsDropdown = newValue;
                  stats = newValue == "Offline" ? Colors.grey : (newValue == "Online" ? Colors.green : Colors.red);
                });
              }
            },
            items: const [
              DropdownMenuItem<String>(
                  value: 'Online',
                  child: Text("🟢 Online", style: TextStyle(color: Colors.white))
              ),
              DropdownMenuItem<String>(
                  value: 'Offline',
                  child: Text("⚫ Offline", style: TextStyle(color: Colors.white))
              ),
              DropdownMenuItem<String>(
                  value: 'Ignore',
                  child: Text("🔴 Ignore", style: TextStyle(color: Colors.white))
              ),
            ],
          )),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 350,
              top: 220,
              child:  Row(children: getBadges()),
            ),

          ]),

          const SizedBox(height: 20),

          Center(child: Container(
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
                    borderRadius: BorderRadius.circular(10.0)
                ),
                hintText: 'Name',
                hintStyle: const TextStyle(color: Colors.white),
                labelText: "Name",
                labelStyle: const TextStyle(color: Colors.white)),
          ))),

          Center(child: Container(
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
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    hintText: 'Stats',
                    hintStyle: const TextStyle(color: Colors.white),
                    labelText: "Stats",
                    labelStyle: const TextStyle(color: Colors.white)),
              ))),

          const SizedBox(height: 20),

          const Center(child: Text("About me", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),

          Center(child: Container(
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
                        borderRadius: BorderRadius.circular(10.0)
                    ),
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
                      updatedLines.add(line.substring(0, maxCharactersPerLine));

                    } else {
                      updatedLines.add(line);
                    }
                  }

                  setState(() {
                    aboutMeController.text = updatedLines.join('\n');
                  });

                },
              ))),

          const SizedBox(height: 10),

          Text(error, style: const TextStyle(color: Colors.red)),
          Text(suss, style: const TextStyle(color: Colors.green)),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {
              // save the changes if any
              Map<dynamic, dynamic> changes = {};
              var mode = (stats == Colors.green ? "1" : (stats == Colors.grey ? "0" : "2"));
              if (nameController.text != ClientAPI.user_name && nameController.text.isNotEmpty) {
                changes["name"] = nameController.text;
              }

              if (mode + statsController.text != ClientAPI.user_stats && statsController.text.isNotEmpty) {
                // 0 = offline
                // 1 = online
                // 2 = ignore
                changes["stats"] = mode + statsController.text;
              }

              if (aboutMeController.text != ClientAPI.user_about_me && aboutMeController.text.isNotEmpty) {
                changes["about_me"] = aboutMeController.text;
              }

              if (tempPfpBase64 != ClientAPI.user_pfp_base64) {
                changes["pfp"] = tempPfpBase64;
              }

              if (tempBannerBase64 != ClientAPI.user_banner_base64) {
                changes["banner"] = tempBannerBase64;
              }

              if (changes.isNotEmpty) {
                if (await ProfileManager.updateProfile(changes)) {
                  setState(() {
                    suss = "Saved successfully";
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
                  });


                } else {
                  setState(() {
                    error = "Failed to save changes";
                    tempPfpBase64 = ClientAPI.user_pfp_base64;
                    tempBannerBase64 = ClientAPI.user_banner_base64;
                  });

                }

              } else {
                setState(() {
                  error = "Can't save unchanged fields";
                  tempPfpBase64 = ClientAPI.user_pfp_base64;
                  tempBannerBase64 = ClientAPI.user_banner_base64;
                });
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
              child: Text('Save',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      )),
    );
  }
}
