import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class Favoritos extends StatefulWidget 
{
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> 
{

  List<Map<String, dynamic>> _favoritos = [];

  bool _cargando = true;

  @override
  void initState() 
  {
    super.initState();
    _cargarFavoritos();
  }

  // Consultar las recetas guardadas
  Future<void> _cargarFavoritos() async {
    final resultado =
        await DatabaseHelper.instance.obtenerFavoritos();

    if (!mounted) return;

    setState(() 
    {
      _favoritos = resultado;
      _cargando = false;
    });
  }

  // Eliminar una receta
  Future<void> _eliminarFavorito(int recetaId) async {
    await DatabaseHelper.instance.eliminarFavorito(recetaId);

    await _cargarFavoritos();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receta eliminada de favoritos'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),

      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _favoritos.isEmpty
              ? const Center(
                  child: Text(
                    'Todavía no tienes recetas favoritas.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _favoritos.length,
                  itemBuilder: (context, index) {

                    final receta = _favoritos[index];

                    final imagen = receta['imagen'] as String?;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: imagen != null &&
                                imagen.isNotEmpty
                            ? Image.network(
                                imagen,
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.restaurant,
                                    size: 40,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.restaurant,
                                size: 40,
                              ),

                        title: Text(
                          receta['titulo'] ?? 'Sin título',
                        ),

                        subtitle: Text(
                          'ID: ${receta['recetaId']}',
                        ),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _eliminarFavorito(
                              receta['recetaId'] as int,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
