class ImageModel {
  final String directory;
  final String thumbnailUrl;
  final int thumbnailSize;
  String? id;

  ImageModel(
      {required this.directory,
      required this.thumbnailUrl,
      required this.thumbnailSize,
      this.id});

  factory ImageModel.fromJson(Map<String, dynamic> json1, String path) {
    return ImageModel(
      directory: json1['Directory'],
      thumbnailSize: json1['ThumbnailSize'] ?? 0,
      thumbnailUrl: json1['ThumbnailUrl'],
    );
  }

  void setId(String id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() => {
        "Directory": directory,
        "ThumbnailSize": thumbnailSize,
        "ThumbnailUrl": thumbnailUrl,
      };
}
