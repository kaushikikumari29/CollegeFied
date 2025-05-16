class PopularPackagesEntity {
  final String title;
  final String subTitle;
  final String imagePath;
  final double rating;
  final String price;
  final String discount;

  PopularPackagesEntity(
      {required this.title,
      required this.subTitle,
      required this.imagePath,
      required this.discount,
      required this.price,
      required this.rating});
}
