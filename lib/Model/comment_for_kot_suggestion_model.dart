class CommentForKotSuggestionsModel {
  final String? id;
  final String? commentForKOT;
  final String? menuItemId;
  CommentForKotSuggestionsModel({this.id, this.commentForKOT, this.menuItemId});

  factory CommentForKotSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return CommentForKotSuggestionsModel(
      id: json['id'],
      commentForKOT: json['CommentForKOT'],
      menuItemId: json['MenuItemId'],
    );
  }
}
