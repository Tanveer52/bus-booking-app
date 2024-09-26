import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int dotsCount;

  const DotsIndicator({super.key, required this.dotsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotsCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.blue[800] : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
