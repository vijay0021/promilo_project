class TopTrendingModel {
  double rating;
  List<String> images;
  int share;
  int likes;
  String name;
  String duration;
  double fees;
  String? about;

  TopTrendingModel({
    required this.rating,
    required this.images,
    required this.share,
    required this.likes,
    required this.name,
    required this.duration,
    required this.fees,
    this.about,
  });

  factory TopTrendingModel.fromJson(Map<String, dynamic> json) => TopTrendingModel(
    rating: json["rating"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    share: json["share"],
    likes: json["likes"],
    name: json["name"],
    duration: json["duration"],
    fees: json["fees"],
    about: json["about"],
      );

  @override
  String toString() {
    return 'TopTrendingModel{rating: $rating, images: $images, share: $share, likes: $likes, name: $name, duration: $duration, fees: $fees, about: $about}';
  }
}

