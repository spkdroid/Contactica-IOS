
class ServiceObject {
  String title;
  String description;
  String image_url;
  String id;
  String type;
  String contact;

  ServiceObject(
      {this.title,
        this.description,
        this.image_url,
        this.id,
        this.type,
        this.contact});

  factory ServiceObject.fromJson(Map<String, dynamic> parsedJson) {
    return ServiceObject(
        title: parsedJson['title'].toString(),
        description: parsedJson['description'].toString(),
        image_url: parsedJson['image_url'].toString(),
        id: parsedJson['id'].toString(),
        type: parsedJson['type'].toString(),
        contact: parsedJson['contact_infor'].toString());
  }

  String getContact() {
    print(contact + "this is the contact");
    return this.contact;
  }

  String getImage() {
    return this.image_url;
  }

  String getTitle() {
    return this.title;
  }

  String getDescription() {
    return this.description;
  }

  String getId() {
    return this.id;
  }

  String getCode() {
    return this.type;
  }

  String getType() {
    String _type = this.type;

    if (_type != null) {
      var serviceType = int.parse(_type);

      if (serviceType == 1) {
        return "SELL";
      } else {
        return "BUY";
      }
    }
    return "";
  }
}
