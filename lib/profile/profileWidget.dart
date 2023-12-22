
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
  late String userStatsDropdown;

  late Color stats;
  bool isHovered = false;

  var nameController = TextEditingController();
  var statsController = TextEditingController();
  var aboutMeController = TextEditingController();

  ProfileHome(Map<dynamic, dynamic> given_data) {
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
                        width: double.infinity,
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            print("Change Banner");
                          },
                          child: Container(decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20.0),
                                top: Radius.circular(20.0),
                              ),
                              image: DecorationImage(
                                  image: ClientAPI.user_banner.image,
                                  fit: BoxFit.fill)))
                        ))),
              ),
              SizedBox(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Column(children: [
                  const SizedBox(height: 150),
                  GestureDetector(
                    onTap: () {
                      print("Change pfp");
                    },
                    child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: ClientAPI.user_pfp.image,
                        ),
                      )],
                )
              ))),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 + 25,
              top: 230,
              child: HoverText(
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
          )),]),

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
                controller: aboutMeController,
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
              ))),

          const SizedBox(height: 50),

          ElevatedButton(
            onPressed: () {
              // save the changes if any
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
