import 'package:flutter/material.dart';
import 'package:jchatapp/friends/friendManager.dart';

import '../navigationWidget.dart';

class FriendsScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  FriendsScreen(Map<dynamic, dynamic> given_data, {super.key}) {
    data = given_data;
  }

  @override
  FriendsHome createState() => FriendsHome();
}

class FriendsHome extends State<FriendsScreen> {

  var searchController = TextEditingController();

  String error = "";
  String success = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> sendFriendRequest(String name) async {
    Map<dynamic, dynamic> data = {};
    data["modif"] = "new";
    data["friend_name"] = name;

    if (await FriendManager.sendFriendRequest(data)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
        body: SingleChildScrollView(
        child: Column(
        children: [
          NavigationHome.getTitle(),
          const SizedBox(height: 10,),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(width: 150),

            //const SizedBox(width: 100),
            Column(children: [
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      error = "";
                      success = "";
                    });
                    if (searchController.text.isEmpty) {
                      setState(() {
                        error = "Enter the name of your friend";
                      });
                      return;
                    }

                    if (await sendFriendRequest(searchController.text)) {
                      setState(() {
                        success = "Added ${searchController.text} as friend";
                      });

                    } else {
                      setState(() {
                        error = "Can't add this account as friends";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.all(10)
                  ),
                  child:  const Icon(Icons.person_add_alt_1_rounded)
              ),
              const Text("Add Friend", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),

            const SizedBox(width: 30),

            Column(children: [
              Container(
                  width: 300,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.0),
                        top: Radius.circular(10.0),
                      )),
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      //icon: const Icon(Icons.search),
                      //iconColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Friend name',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: "Search",
                        labelStyle: const TextStyle(color: Colors.white)),
                  )),
              Text(error, style: const TextStyle(color: Colors.red)),
              Text(success, style: const TextStyle(color: Colors.green)),
            ]),


            const SizedBox(width: 90),

            Container(height: MediaQuery.of(context).size.height * 0.5 + 160, child: VerticalDivider(color: Colors.black)),

            // MediaQuery.of(context).size.height * 0.5 + 25


            const SizedBox(width: 30),
            Column(children: [
              ElevatedButton(
                  onPressed: () async {

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.all(10)
                  ),
                  child:  const Icon(Icons.person)
              ),
              const Text("Friends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(width: 30),
            Column(children: [
              ElevatedButton(
                  onPressed: () async {

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.all(10)
                  ),
                  child:  const Icon(Icons.person_search_rounded)
              ),
              const Text("Requests", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ])

          ])
          )
        ])));
  }
}