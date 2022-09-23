class Parameter {
  String? pKey;
  dynamic pValue;

  Parameter({
    this.pKey,
    this.pValue,
  });

  Map toJson() {
    return {
      'P_Key': pKey,
      'P_Value': pValue,
    };
  }
}
