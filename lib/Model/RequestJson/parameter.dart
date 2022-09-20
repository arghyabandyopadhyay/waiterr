class Parameter
{
  String? pKey;
  var pValue;

  Parameter({
    this.pKey,
    this.pValue,
  });

  Map toJson()
  {
    return {
      'P_Key': pKey,
      'P_Value': pValue,
    };
  }
}
