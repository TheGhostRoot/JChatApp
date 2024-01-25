
class Friend {

  String name;
  String imageBase64; // video;
  int id;
  int channel_id;

  Friend(this.name, this.id, this.imageBase64, this.channel_id);

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