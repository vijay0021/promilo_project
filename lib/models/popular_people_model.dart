class PopularPeopleModel {
  String title;
  int meetups;
  String image;
  List<String> images;

  PopularPeopleModel({required this.title, required this.meetups, required this.image, required this.images});

  factory PopularPeopleModel.fromJson(Map<String, dynamic> json) => PopularPeopleModel(
        title: json["title"],
        meetups: json["meetups"],
        image: json["image"],
        images: List<String>.from(json["images"].map((x) => x)),
      );
}
