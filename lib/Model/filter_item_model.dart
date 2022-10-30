class FilterItemModel {
  final String id;
  final String? image;
  final String? stockGroup;
  final String? masterFilter;
  FilterItemModel(
      {required this.id, this.image, this.stockGroup, this.masterFilter});

  factory FilterItemModel.fromJson(Map<String, dynamic> json) {
    return FilterItemModel(
      id: json['id'],
      //image: json['Image']!=null&&json['Image']!=""?Image.memory(base64Decode(json['Image'])):Image.asset('assets/img/all_filter_icon.png'),
      image: json['ImageUrl'],
      stockGroup: json['StockGroup'],
      masterFilter: json['MasterFilter'],
    );
  }
}
