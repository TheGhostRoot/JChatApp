
import 'package:flutter/material.dart';
import 'package:jchatapp/hoverTextWidget.dart';
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

  late Color stats;
  bool isHovered = false;

  ProfileHome(Map<dynamic, dynamic> given_data) {
    stats = ClientAPI.user_stats[0] == "0" ? Colors.grey : (ClientAPI.user_stats[0] == "1" ? Colors.green : Colors.red);
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
      backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
      body: Column(
        children: [
          NavigationHome.getTitle(),
          Stack(children: [
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
            SizedBox(child: Column(children: [
              const SizedBox(height: 230),
              Row(children: [
                const SizedBox(width: 650),
                HoverText(
                  h: 20,
                  w: 50,
                  text: stats == Colors.grey ? 'Offline' : (stats == Colors.green ? "Online" : "Ignore"),
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor: stats,
                  ),
                )
              ])
              ]))
            ]),
          Center(child: Text(ClientAPI.user_name, style: const TextStyle(color: Colors.black, fontSize: 30))),
          Center(child: Text(ClientAPI.user_stats.substring(1), style: const TextStyle(color: Colors.black, fontSize: 15))),
          const Center(child: Text("About me", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold))),
          Center(child: Text(ClientAPI.user_about_me, style: const TextStyle(color: Colors.black, fontSize: 15)))
        ],
      ),
    );
  }
}
