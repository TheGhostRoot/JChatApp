
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jchatapp/friends/chat/friendChatManager.dart';
import 'package:jchatapp/friends/friendManager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

  String success = "";
  String error = "";

  VideoPlayerController? friendPfp;

  ScrollController scrollController = ScrollController();

  var messageController = TextEditingController();

  late Friend friend;

  int page = 1;

  late Widget messages;

  @override
  void dispose() {
    if (friendPfp != null) {
      friendPfp?.dispose();
    }
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  FriendChatHome(Map<dynamic, dynamic> gdata) {
    data = gdata;
    friend = data["friendsChat"] as Friend;
  }

  void _handleControllerNotification() {
    print('Notified through the scroll controller.');
    // Access the position directly through the controller for details on the
    // scroll position.

    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      print("Up");
    }
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      print("Down");
    }
  }

  @override
  void initState() {
    super.initState();

    messages = LoadingAnimationWidget.fallingDot(
        color: Colors.white,
        size: 100);

    scrollController.addListener(_handleControllerNotification);

    Future.delayed(const Duration(microseconds: 1), () async {
      Map<dynamic, dynamic>? msgs = await FriendChatManager.getMessages(friend.id);
      if (msgs == null || (msgs['msgs'] as List).isEmpty) {
        try {
          setState(() {
            messages = getEmptyMessageWidget();
          });
        } catch(e) {
          return;
        }
        return;
      }

      try {
        setState(() {
          messages = getMessagesWidget(msgs);
        });
      } catch(e) {
        return;
      }
    });
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
            color: Color.fromRGBO(57, 57, 57, 100)),
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

  Widget getEmptyMessageWidget() {
    return Center(child: Text("No messages. Say hello to ${friend.name} !", style: const TextStyle(color: Colors.black),),);
  }

  Widget getMessagesWidget(Map<dynamic, dynamic> messages) {
    // {"user1": [14141414], "user2": [1313131],  "msgs": [ [{"msg": "message", "send_by": 242424(sender id), "send_at": 1412423425(timestampt), "msg_id": 2341}] ]  }
    List<dynamic> msgs = messages["msgs"][0] as List;
    List<Widget> messageWidgest = [];
    for (Map<dynamic, dynamic> msg in msgs) {
      Widget msgWidget;
      String msgMessage = msg["msg"] as String;
      int count = 0;
      int t = 3;
      String updatedMessage = "";

      for (var c in msgMessage.characters) {
        count++;
        if (count == 40) {
          count = 0;
          t++;
          updatedMessage += "\n$c";

        } else {
          updatedMessage += c;
        }
      }
      updatedMessage += "\n\n${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch((msg["send_at"] as int)))}";
      if (msg["send_by"] == ClientAPI.user_id) {
        // send by you
        msgWidget = SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
           SizedBox(width: WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width * 0.3,),
          Container(
            //height: t * 25,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(5.0),
                  top: Radius.circular(5.0),
                )),
            padding: const EdgeInsets.only(right: 200, top: 5, bottom: 5),
            child: Text(updatedMessage),
          )
        ]));
      } else {
        // if (msg["send_by"] == friend.id)
        // send by friend

        msgWidget = SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          Container(
            height: msgMessage.length * 5,
            decoration: const BoxDecoration(
                color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
                top: Radius.circular(20.0),
              )),
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
            child: Text(updatedMessage),
          )
        ]));
      }
      messageWidgest.add(msgWidget);
    }
    return Column(children: messageWidgest);
  }

  Future<bool> sendMessage(BuildContext context) async {
    if (messageController.text.isEmpty || messageController.text.length > 2000) {
      setState(() {
        success = "";
        error = "Message is not valid to send";
      });
      return false;
    }

    Map<dynamic, dynamic>? message_data = await FriendChatManager.sendMessage(friend.id, messageController.text);
    if (message_data == null || !context.mounted) return false;
    setState(() {
      messages = getMessagesWidget(message_data);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(70, 70, 70, 1),
        body: SingleChildScrollView(
        child: Center(child: Column(
        children: [
          NavigationHome.getTitle(),
          const SizedBox(height: 10),
          getFriendWidget(friend, context),
          const SizedBox(height: 10),
          Container(height: MediaQuery.of(context).size.height * 0.5 + 50, width: MediaQuery.of(context).size.width * 0.5 + 200,
              decoration: const BoxDecoration(color: Color.fromRGBO(73, 73, 73, 100)),child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(controller: scrollController, child: messages,)
          )),
          const SizedBox(height: 50,),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
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
                        maxLength: 2000,
                        maxLines: 5,
                        textInputAction: TextInputAction.next,
                        controller: messageController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: 'Your message',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                          //labelText: "Message",
                          //labelStyle: const TextStyle(color: Colors.white)),
                        )))),
            const SizedBox(width: 10,),
            ElevatedButton(
              onPressed: () async {
                bool f = await sendMessage(context);
                if (!context.mounted) return;
                if (f) {
                  setState(() {
                    success = "messaged sended!";
                    error = "";
                  });
                } else {
                  setState(() {
                    success = "";
                    error = "can't send message";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Send"),
            ),

            const SizedBox(width: 10,),
            Text(error, style: const TextStyle(color: Colors.red),),
            Text(success, style: const TextStyle(color: Colors.green),),
          ],)),

        ]))));
  }
}