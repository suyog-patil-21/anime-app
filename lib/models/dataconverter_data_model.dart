//* this model containts the datat line
// ? title, href(inside Attributes class > href instance variable )
class DataConverter {
  DataConverter({
    this.title,
    this.attributes,
  });

  String? title;
  Attributes? attributes;

  factory DataConverter.fromMap(Map<String, dynamic> json) => DataConverter(
        title: json["title"],
        attributes: Attributes.fromMap(json["attributes"]),
      );

  factory DataConverter.fromPureMap(Map<String, dynamic> json) => DataConverter(
      title: json['title'], attributes: Attributes(href: json['url']));

  Map<String, dynamic> toMap() => {
        "title": title,
        "attributes": attributes!.toMap(),
      };
}

class Attributes {
  Attributes({
    this.href,
  });

  String? href;

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "href": href,
      };
}
