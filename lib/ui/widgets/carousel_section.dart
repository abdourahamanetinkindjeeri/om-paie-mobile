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
      description:
          'Envoyez rapidement et en toute\nsécurité de l\'argent à un proche qui\npossède un compte Orange Money.',
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCTvwkUvPcJYgtKLz4gqTS0TFoavuUM_B2Aw0Q55M7yZxwgIz67K3wC5j4VH93GHaj3yA&usqp=CAU',
    ),
    CarouselItem(
      icon: '📱',
      title: 'Recevoir',
      description:
          'Recevez de l\'argent en toute sécurité\nsur votre compte Orange Money\npartout et à tout moment.',
      image:
          'https://cmsphoto.ww-cdn.com/superstatic/36975/art/grande/9709856-15650784.jpg?v=1466415034',
    ),
    CarouselItem(
      icon: '💰',
      title: 'Payer',
      description:
          'Effectuez vos paiements rapidement\net en toute sécurité avec\nOrange Money.',
      image:
          'https://media.licdn.com/dms/image/v2/D4E22AQF6LRqNVLoXtg/feedshare-shrink_800/B4EZlOWftgHIAg-/0/1757956146186?e=2147483647&v=beta&t=TP-Qv_h_7KMqn681UI3vcm4T8cXKe44tv_hd4q8Qw_g',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _carouselItems
            .map((item) => CarouselPage(
                  title: item.title,
                  description: item.description,
                  imageUrl: item.image,
                ))
            .toList(),
      ),
    );
  }
}
