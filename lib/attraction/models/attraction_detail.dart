class AttractionDetail {
  AttractionDetail({
    this.name = '',
    this.formattedAddress = '',
    this.formattedPhoneNumber = '',
    this.website = '',
    this.rating = 0.0,
    this.priceLevel = '',
    this.openNow = 'N/A',
    this.userRatingsTotal = 0,
  });

  String name;
  String formattedAddress;
  String formattedPhoneNumber;
  double rating;
  String website;
  String priceLevel;
  String openNow;
  int userRatingsTotal;
}
