import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jchatapp/friends/friend.dart';
import 'package:jchatapp/friends/friendManager.dart';
import 'package:jchatapp/profile/profileWidget.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';
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

  Widget friendRequests = Container();
  Widget friends = Container();
  Widget pendingRequests = Container();

  Map<String, dynamic>? friendRequestData;
  Map<String, dynamic>? PendingData;

  late Widget addFriendButton;
  late Widget searchWidget;
  late Widget getFriendRequestButton;
  late Widget getFriendsButton;
  late Widget getPendingRequestsButton;

  late Widget acceptButton;
  late Widget denyButton;

  Map<Friend, VideoPlayerController> friendsPfp = {};

  @override
  void dispose() {
    for (var fr in friendsPfp.entries) {
      fr.value.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    addFriendButton = Column(children: [
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

            if (searchController.text == ClientAPI.user_name) {
              setState(() {
                error = "You can't add yourself";
              });
              return;
            }

            if (await FriendManager.sendFriendRequest(searchController.text)) {
              setState(() {
                success = "Send friend request to ${searchController.text}";
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
    ]);

    searchWidget = Column(children: [
      Container(
          width: Platform.isIOS || Platform.isAndroid?  100 : 300,
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
    ]);

  }

  Widget getFriendRequestWidget(String name, BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.vertical, child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
        color: Colors.black),
        child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(width: 50),
                  ElevatedButton(
                      onPressed: () async {
                        if (friendRequestData != null && friendRequestData!.isNotEmpty && friendRequestData!.containsKey(name)) {
                          if (await FriendManager.sendFriendAcceptRequest(friendRequestData![name])) {
                            setState(() {
                              error = "";
                              success = "Accepted $name friend request";
                            });
                          } else {
                            setState(() {
                              error = "Can't deny $name friend request";
                              success = "";
                            });
                          }
                          setRequests(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.only(left: 30, right: 30)
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(fontSize: 20.0),
                      )),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () async {
                        if (friendRequestData != null && friendRequestData!.isNotEmpty && friendRequestData!.containsKey(name)) {
                          if (await FriendManager.sendFriendDenyRequest(friendRequestData![name])) {
                            setState(() {
                              error = "";
                              success = "Denied $name friend request";
                            });

                          } else {
                            setState(() {
                              error = "Can't deny $name friend request";
                              success = "";
                            });
                          }
                          setRequests(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.only(left: 30, right: 30)
                      ),
                      child: const Text(
                        'Deny',
                        style: TextStyle(fontSize: 20.0),
                      )),
                ])));


  }

  Widget getPendingWidget(String name, BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.vertical, child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            color: Colors.black),
        child: Row(
            children: [
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(width: 380),
              const Text("Pending", style: TextStyle(color: Colors.grey, fontSize: 20)),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () async {
                    if (await FriendManager.sendFriendDenyRequest(PendingData![name])) {
                      setState(() {
                        error = "";
                        success = "Canceled friend request";
                      });

                    } else {
                      setState(() {
                        error = "Can't cancel friend request";
                        success = "";
                      });
                    }
                    setPending(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10)
                  ),
                  child: const Icon(Icons.cancel_sharp)
              )
            ])));
  }

  Widget setupPfpVideoFriend(VideoPlayerController v) {
    return SizedBox(height: 60, width: 60, child: ClipRRect(
      borderRadius: BorderRadius.circular(60.0),
      clipBehavior: Clip.hardEdge,
      child: VideoPlayer(v), // It's highly advisable to use this behavior to improve performance.
    ));
  }

  VideoPlayerController getPfpVideo(int friend_id) {
    VideoPlayerController videoPlayerControllerPfp = VideoPlayerController.networkUrl(
        Uri.parse(ClientAPI.pfpUrl),
        httpHeaders: ClientAPI.getProfileHeaders(friend_id) ?? {});

    videoPlayerControllerPfp.addListener(() {
      setState(() {});
    });

    videoPlayerControllerPfp.setLooping(true);
    videoPlayerControllerPfp.setVolume(0);
    videoPlayerControllerPfp.initialize().then((_) => setState(() {}));
    videoPlayerControllerPfp.play();

    return videoPlayerControllerPfp;
  }

  Widget getFriendWidget(Friend friend) {
    Widget friendPfp = Container();
    if (friend.imageBase64 == "video;") {
      VideoPlayerController v = getPfpVideo(friend.id);
      friendsPfp[friend] = v;
      friendPfp = setupPfpVideoFriend(v);

    } else {
      friendPfp = ProfileHome.getAvatarImage(friend.imageBase64, 30);
    }

    return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            color: Colors.black),
        child: Row(children: [
          friendPfp,
          const SizedBox(width: 30,),

          Text(friend.name, style: const TextStyle(color: Colors.white, fontSize: 10)),

        ]));
  }

  Future<void> setRequests(BuildContext context) async {
    Map<String, dynamic>? req = await FriendManager.getFriendRequests();
    if (req == null || req.isEmpty) {
      setState(() {
          pendingRequests = Container();
          friendRequests = Container();
          friends = Container();
      });

    } else {
      friendRequestData = req;
      List<Widget> requests = [];
      for (var f in req.entries) {
        requests.add(getFriendRequestWidget(f.key, context));
      }
      setState(() {
        friends = Container();
        pendingRequests = Container();
        friendRequests = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: requests);
      });
    }
  }

  void setFriendsWidgets() {
    List<Widget> requests = [];
    for (Friend f in ClientAPI.friends) {
      requests.add(getFriendWidget(f));
    }
    setState(() {
      friends = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: requests);
      friendRequests = Container();
      pendingRequests = Container();
    });
  }

  Future<void> setFriends(BuildContext context) async {
    if (ClientAPI.friends.isEmpty) {
      if (await FriendManager.getFriends()) {
        setFriendsWidgets();

      } else {
        setState(() {
          success = "";
          error = "Can't get friends";
        });
      }
    } else {
      setFriendsWidgets();
    }
  }

  Future<void> setPending(BuildContext context) async {
    Map<String, dynamic>? req = await FriendManager.getPendingRequests();
    if (req == null || req.isEmpty) {
      setState(() {
        pendingRequests = Container();
        friendRequests = Container();
        friends = Container();
      });

    } else {
      PendingData = req;
      List<Widget> requests = [];
      for (var f in req.entries) {
        requests.add(getPendingWidget(f.key, context));
      }
      setState(() {
        friends = Container();
        friendRequests = Container();
        pendingRequests = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: requests);
      });
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
          const SizedBox(height: 10,),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Center(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            addFriendButton,

            const SizedBox(width: 30),

            Column(children: [
              searchWidget,
              Text(error, style: const TextStyle(color: Colors.red),),
              Text(success, style: const TextStyle(color: Colors.green),),
              const SizedBox(height: 20),
            ]),

            /*
            const SizedBox(width: 90),

            Container(height: MediaQuery.of(context).size.height * 0.5 + 160, child: VerticalDivider(color: Colors.black)),
             */
          ]))),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Center(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(width: 30),
              Column(children: [
                ElevatedButton(
                    onPressed: () async {
                      await setFriends(context);
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
                      await setRequests(context);
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
              ]),

            const SizedBox(width: 30),
              Column(children: [
                ElevatedButton(
                    onPressed: () async {
                      await setPending(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: const EdgeInsets.all(10)
                    ),
                    child:  const Icon(Icons.person_search_outlined)
                ),
                const Text("Pending", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ]),


            /*
            const SizedBox(width: 90),

            Container(height: MediaQuery.of(context).size.height * 0.5 + 160, child: VerticalDivider(color: Colors.black)),
             */
          ]))),

          const SizedBox(height: 20,),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: friends),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child:friendRequests),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: pendingRequests),

        ])));
  }
}