
class Friend {

  String? name;
  String? imageBase64;
  int? id;
  int? channel_id;
  String? animations;

  Friend(this.name, this.id, this.imageBase64, this.channel_id, this.animations);

  String? getName() {
    return name;
  }

  int? getID() {
    return id;
  }

  String? getImageBase64() {
    return imageBase64;
  }


  String? getAnimations() {
    return animations;
  }

  int? getDMChannelID() {
    return channel_id;
  }

}