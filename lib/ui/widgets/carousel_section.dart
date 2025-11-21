import 'package:flutter/material.dart';
import 'package:om_paie_flutter/model/carousel.item.dart';
import 'package:om_paie_flutter/ui/widgets/carousel_page.dart';

class CarouselSection extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;

  const CarouselSection({
    Key? key,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  static const List<CarouselItem> _carouselItems = [
    CarouselItem(
      icon: '↗️',
      title: 'Transférer',
      description: 'Envoyez rapidement et en toute\nsécurité de l\'argent à un proche qui\npossède un compte Orange Money.',
    ),
    CarouselItem(
      icon: '📱',
      title: 'Recevoir',
      description: 'Recevez de l\'argent en toute sécurité\nsur votre compte Orange Money\npartout et à tout moment.',
    ),
    CarouselItem(
      icon: '💰',
      title: 'Payer',
      description: 'Effectuez vos paiements rapidement\net en toute sécurité avec\nOrange Money.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _carouselItems.map((item) => CarouselPage(
          title: item.title,
          description: item.description,
        )).toList(),
      ),
    );
  }
}