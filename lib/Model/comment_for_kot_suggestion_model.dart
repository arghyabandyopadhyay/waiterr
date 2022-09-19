class CommentForKotSuggestionsModel{
  final String? commentForKOT;
  final String? itemID;
  CommentForKotSuggestionsModel({this.commentForKOT, this.itemID});

  factory CommentForKotSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return CommentForKotSuggestionsModel(
      commentForKOT: json['CommentForKOT'],
      itemID: json['ItemID'],
    );
  }
}