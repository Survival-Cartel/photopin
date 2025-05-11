import 'package:flutter/material.dart';
import 'package:photopin/presentation/component/map_filter.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journals')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MapFilter(icons: [Icons.watch_later_rounded, Icons.local_fire_department, Icons.photo_library_sharp], labels: ['Time', 'Heat Map', 'Photos'], initialIndex: 0, onSelected:)
            ],
          ),

      )),
    );
  }
}
