
class Friend {

  String name;
  String imageBase64; // video;
  int id;
  int channel_id;
  String stats;
  String badges;

  Friend(this.name, this.id, this.imageBase64, this.channel_id, this.stats, this.badges);

  String getName() {
    return name;
  }

  int getID() {
    return id;
  }

  String getImageBase64() {
    return imageBase64;
  }


  int getDMChannelID() {
    return channel_id;
  }

}