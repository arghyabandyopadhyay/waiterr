class ApiHeaderModel {
  String authorization;
  String contentType;
  ApiHeaderModel({required this.authorization, required this.contentType});
  Map<String, String> toJson() =>
      {"Authorization": authorization, "Content-Type": contentType};
}
