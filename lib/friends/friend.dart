
import 'package:jchatapp/friends/chat/message.dart';

class Friend {

  String name;
  String imageBase64; // video;
  int id;
  String stats;
  String badges;
  late List<Message> messages;

  Friend(this.name, this.id, this.imageBase64, this.stats, this.badges);

  void addMessage(Map<dynamic, dynamic> msg) {

  }

}