class FilterItemModel{
  final String? image;
  final String? stockGroup;
  final String? masterFilter;
  FilterItemModel({this.image, this.stockGroup, this.masterFilter});

  factory FilterItemModel.fromJson(Map<String, dynamic> json) {
    return FilterItemModel(
      //image: json['Image']!=null&&json['Image']!=""?Image.memory(base64Decode(json['Image'])):Image.asset('assets/img/AllFilterIcon.png'),
      image: json['Image'],
      stockGroup: json['StockGroup'],
      masterFilter: json['MasterFilter'],
    );
  }
}