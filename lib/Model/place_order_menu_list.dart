class PlaceOrderMenuList {
  String? itemID;
  double? quantity;
  double? rate;
  String? commentForKOT;
  String? commentForKOTId;
  String? taxClassID;
  double? taxRate;
  bool? discountable;
  PlaceOrderMenuList(
      {this.itemID,
      this.quantity,
      this.rate,
      this.commentForKOT,
      this.commentForKOTId,
      this.taxClassID,
      this.taxRate,
      this.discountable});

  Map toJson() => {
        "ItemID": itemID,
        "Quantity": quantity,
        "Rate": rate,
        "CommentForKOT": commentForKOT,
        "CommentForKOTId": commentForKOTId,
        "TaxClassID": taxClassID,
        "TaxRate": taxRate,
        "Discountable": discountable
      };
}
