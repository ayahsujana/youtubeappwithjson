class CategoryModels {
  final String cid;
  final String categoryName;
  final String categoryImage;

  CategoryModels(this.cid, this.categoryName, this.categoryImage);
}

class VideosModels {
  final String id;
  final String catId;
  final String videoTitle;
  final String videoUrl;
  final String videoId;
  final String videoThumbnail;
  final String videoDuration;
  final String videoDescription;
  final String videoType;
  final String categoryName;
  final String categoryImage;

  VideosModels(
      this.id,
      this.catId,
      this.videoTitle,
      this.videoUrl,
      this.videoId,
      this.videoThumbnail,
      this.videoDuration,
      this.videoDescription,
      this.videoType,
      this.categoryName,
      this.categoryImage);
}
