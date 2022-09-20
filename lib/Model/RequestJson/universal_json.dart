import 'dart:convert';

import 'parameter.dart';

class UniversalJson {
  String? gUID;
  String? companyGUID;
  RequestJson? requestJSON;
  UniversalJson({this.gUID, this.companyGUID, this.requestJSON});

  Map toJson() => {
        "GUID": gUID,
        "CompanyGUID": companyGUID,
        "RequestDateTime": DateTime.now().toIso8601String(),
        "RequestJSON": json.encode(requestJSON)
      };
}

class RequestJson {
  String? requestType;
  List<Parameter>? parameterList;
  RequestJson({this.requestType, this.parameterList});

  Map toJson() => {
        "RequestType": requestType,
        "ParameterList": parameterList,
      };
}
