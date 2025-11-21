import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/carousel.items.dart';

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: carouselItems.map((item) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(item.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.description, textAlign: TextAlign.center),
            ),
            if (item.image != null) Image.asset(item.image!, height: 120),
          ],
        );
      }).toList(),
    );
  }
}
