class Attraction {
  Attraction({
    this.name = '',
    this.icon = '',
    this.openNow = false,
    this.placeId = '',
    this.rating = 0.0,
    this.photoReference = '',
  });

  String name;
  bool openNow;
  String placeId;
  double rating;
  String icon;
  String photoReference;
}
