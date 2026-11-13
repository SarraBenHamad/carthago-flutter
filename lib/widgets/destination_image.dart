import 'package:flutter/material.dart';

class DestinationImage extends StatelessWidget {
  final String id;
  final double? height;
  final double? width;

  const DestinationImage({
    super.key,
    required this.id,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    return Image.asset(
      'assets/images/$id.jpg',
      height: height,
      width: width,
      fit: BoxFit.cover,
      cacheWidth: 900,
      errorBuilder: (context, erreur, pile) {
        return Container(
          height: height,
          width: width,
          color: couleurs.primaryContainer,
          child: Icon(
            Icons.landscape_rounded,
            size: 40,
            color: couleurs.onPrimaryContainer,
          ),
        );
      },
    );
  }
}