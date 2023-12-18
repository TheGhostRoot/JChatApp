import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jchatapp/main.dart';
import 'package:jchatapp/navigationWidget.dart';

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

  ProfileHome(Map<dynamic, dynamic> given_data) {
    data = given_data;
    clientConfig = data["client_config"] as ClientConfig;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      NavigationHome.getTitle(),

      Column(
          children: [
        const SizedBox(height: 140.0),
        SizedBox(
          height: 100.0,
          child: clientConfig.config["remember_me"]["pfp"].toString().isNotEmpty ? GestureDetector(
            onTap: () {

            },
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(base64Decode(clientConfig.config["remember_me"]['pfp'])),
                      fit: BoxFit.contain
                  ),
                ),
              ),
            ) : null,
        )
      ])
    ]));
  }
}