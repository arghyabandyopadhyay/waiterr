class MotherJSONModel {
  String? masterfield;
  String? particulars;
  String? subParticulars;
  dynamic info;
  String? subInfo;
  String? messageType;
  String? remarks;
  MotherJSONModel(this.masterfield, this.particulars, this.subParticulars,
      this.info, this.subInfo, this.messageType, this.remarks);

  factory MotherJSONModel.fromJson(dynamic json) {
    return MotherJSONModel(
        json['MasterField'] as String?,
        json['Particulars'] as String?,
        json['SubParticulars'] as String?,
        json['Info'] as dynamic,
        json['SubInfo'] as String?,
        json['MessageType'] as String?,
        json['Remarks'] as String?);
  }
}
