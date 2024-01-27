


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';
import '../../navigationWidget.dart';
import '../../profile/profileWidget.dart';
import '../friend.dart';

class FriendChatScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  FriendChatScreen(Map<dynamic, dynamic> given_data, {super.key}) {
    data = given_data;
  }

  @override
  FriendChatHome createState() => FriendChatHome(data);
}

class FriendChatHome extends State<FriendChatScreen> {

  late Map<dynamic, dynamic> data;

  VideoPlayerController? friendPfp;

  @override
  void dispose() {
    if (friendPfp != null) {
      friendPfp?.dispose();
    }

    super.dispose();
  }

  FriendChatHome(Map<dynamic, dynamic> gdata) {
    data = gdata;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget setupPfpVideo(Friend friend) {
    VideoPlayerController videoPlayerControllerPfp = VideoPlayerController.networkUrl(
        Uri.parse(ClientAPI.getPfpUrl(friend.id)),
        httpHeaders: ClientAPI.getProfileHeaders() ?? {});

    videoPlayerControllerPfp.addListener(() {
    });

    videoPlayerControllerPfp.setLooping(true);
    videoPlayerControllerPfp.setVolume(0);
    videoPlayerControllerPfp.initialize().then((_) => _);
    videoPlayerControllerPfp.play();

    friendPfp = videoPlayerControllerPfp;

    return SizedBox(height: 60, width: 60, child: ClipRRect(
      borderRadius: BorderRadius.circular(60.0),
      clipBehavior: Clip.hardEdge,
      child: VideoPlayer(videoPlayerControllerPfp), // It's highly advisable to use this behavior to improve performance.
    ));

  }

  Widget getFriendWidget(Friend friend, BuildContext context) {
    Widget friendPfp;
    if (friend.imageBase64.startsWith("video;")) {
      //setupPfpVideo(friend);
      //friendPfp = setupPfpVideoFriend(friend);
      friendPfp = setupPfpVideo(friend);

    } else {
      friendPfp = ProfileHome.getAvatarImage(friend.imageBase64, 30);
    }


    var colorStats = friend.stats[0] == "0"
        ? Colors.grey
        : (friend.stats[0] == "1" ? Colors.green : Colors.red);

    //double w = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            color: Colors.black),
        child: SingleChildScrollView(child: Center(child: Row(children: [
          friendPfp,

          Column(children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 10.0,
              backgroundColor: colorStats,
            ),
          ]),

          const SizedBox(width: 15),
          Text(friend.name, style: const TextStyle(color: Colors.white, fontSize: 30)),
          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: () async {
              // TODO start call
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10)
            ),
            child: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.call)),
          ),

          const SizedBox(width: 10),

         ElevatedButton(
            onPressed: () {
              data.remove('friendsChat');
              data['goFriends'] = true;
              Navigator.of(context, rootNavigator: true).pushNamed("/home", arguments: data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Back"),
          ),

          const SizedBox(width: 10),

         Text(friend.stats.substring(1), style: const TextStyle(fontSize: 15.0, color: Colors.white)),
        ])))));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
        body: SingleChildScrollView(
        child:  Column(
        children: [
          NavigationHome.getTitle(),
          const SizedBox(height: 10),
          getFriendWidget(data["friendsChat"] as Friend, context),
        ])));
  }
}