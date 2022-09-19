class FavouritesJsonModel {
  final String? itemId;

  FavouritesJsonModel({this.itemId});

  factory FavouritesJsonModel.fromJson(Map<String, dynamic> json) {
    return FavouritesJsonModel(
      itemId: json['ItemID'],
    );
  }
}
