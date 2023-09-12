import 'package:flutter/material.dart';
import 'unsplash_service.dart';
import 'image_model.dart';
import 'image_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UnsplashService unsplashService = UnsplashService();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _page = 1; // Página actual
  List<UnsplashImage> _images = [];

  Future<void> _loadMoreImages() async {
    final newImages = await unsplashService.getImages(page: _page + 1);
    setState(() {
      _images.addAll(newImages);
      _page++;
    });
  }

  Future<void> _searchImages(String query) async {
    _page = 1;
    final newImages = await unsplashService.searchImage(query, _page);
    setState(() {
      _images.clear();
      _images.addAll(newImages);
      _page++;
    });
  }

  @override
  void initState() {
    _loadMoreImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar imágenes',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                      _searchImages(_searchQuery);
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _loadMoreImages(); // Cargar más imágenes cuando el usuario llega al final
                }
                return true;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(image: image),
                      ));
                    },
                    child: Image.network(
                      image.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
