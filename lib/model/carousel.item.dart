class CarouselItem {
  final String icon;
  final String title;
  final String description;
  final String? image;

  const CarouselItem({
    required this.icon,
    required this.title,
    required this.description,
    this.image,
  });
}
