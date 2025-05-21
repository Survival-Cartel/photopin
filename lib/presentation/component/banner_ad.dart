import 'package:flutter/material.dart';

class BannerAd extends StatelessWidget {
  final String path;

  const BannerAd({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Image.asset(path, fit: BoxFit.cover),
    );
  }
}
