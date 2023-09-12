import 'package:flutter/material.dart';
import 'unsplash_service.dart';
import 'image_model.dart';
import 'image_detail.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeriapp',
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900], // Fondo gris oscuro
        ),
        child: const MyHomePage(),
      ),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[900], // Color rojo oscuro para el AppBar
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 40.0, // Tamaño de fuente de los títulos
            fontStyle: FontStyle.italic,
            color: Colors.white, // Color de texto blanco
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UnsplashService unsplashService = UnsplashService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _page = 1; // Página actual
  final List<UnsplashImage> _images = [];

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
        title: const Text('Galeriapp'),
      ),
      backgroundColor:
          Colors.black, // Fondo negro para el cuerpo de la aplicación
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar imágenes',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                      _searchImages(_searchQuery);
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[300], // Color de fondo gris
              ),
              style: const TextStyle(
                fontSize: 16.0, // Tamaño de fuente del texto de búsqueda
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing:
                      16.0, // Espacio horizontal entre las imágenes
                  mainAxisSpacing: 16.0, // Espacio vertical entre las imágenes
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
                    child: Hero(
                      tag:
                          'image_${image.id}', // Asigna un tag único para cada imagen
                      child: Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Espacio alrededor de la imagen
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            image.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
