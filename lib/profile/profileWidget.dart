import 'dart:convert';
import 'dart:typed_data';

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
    return Scaffold(
      body: Column(
        children: [
          NavigationHome.getTitle(),
          Stack(
            children: [
              SizedBox(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20.0),
                              top: Radius.circular(20.0),
                            ),
                            image: DecorationImage(
                                image: ClientAPI.user_banner.image,
                                fit: BoxFit.fill)))),
              ),
              SizedBox(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Column(children: [
                  const SizedBox(height: 150),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: ClientAPI.user_pfp.image,
                  )
                ]))
              )),
            ],
          ),
        ],
      ),
    );
  }
}
