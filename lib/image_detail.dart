import 'package:flutter/material.dart';
import 'image_model.dart';

class ImageDetailScreen extends StatelessWidget {
  final UnsplashImage image;

  ImageDetailScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Imagen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                image.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
