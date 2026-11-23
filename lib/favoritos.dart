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

  // Colores de FridgeRecipes.
  final Color verde = const Color(0xFF2E7D32);
  final Color verdeClaro = const Color(0xFFA5D6A7);
  final Color fondo = const Color(0xFFF5FAF4);
  final Color texto = const Color(0xFF20352A);

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


  // Mostrar confirmación antes de eliminar.
  Future<void> _confirmarEliminacion(int recetaId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: verdeClaro.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: verde,
                  size: 35,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '¿Seguro que quieres eliminar este elemento?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: texto,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: verde,
                side: BorderSide(color: verde),
              ),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _eliminarFavorito(recetaId);
    }
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
    return Scaffold
    (
      backgroundColor: fondo,

      appBar: AppBar
      (
        backgroundColor: fondo,
        elevation: 0,
        centerTitle: true,
        title: 
          Row
          (
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              Icon
              (
                Icons.kitchen,
                color: verde,
                size: 25,
              ),
              const SizedBox(width: 7),
              Text
              (
                'FRIDGE RECIPES',
                style: TextStyle
                (
                  color: verde,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
      ),
      body: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Text
                (
                  'Favoritos',
                  style: TextStyle
                  (
                    color: texto,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            Text('Tus recetas guardadas',
            style:TextStyle(
              color: texto.withOpacity(0.66),
              fontSize: 14,
            ),
          ),
        ],
      ),
          ),

           Expanded(
            child: _cargando
                ? Center(
                    child: CircularProgressIndicator(color: verde),
                  )
                : _favoritos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 65,
                              color: verdeClaro,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Todavía no tienes recetas favoritas.',
                              style: TextStyle(
                                color: texto,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        itemCount: _favoritos.length,
                        itemBuilder: (context, index) {
                          final receta = _favoritos[index];
                          final imagen = receta['imagen'] as String?;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: verdeClaro.withOpacity(0.45),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Row(
                                children: [
                                  // Imagen de la receta.
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imagen != null && imagen.isNotEmpty
                                        ? Image.network(
                                            imagen,
                                            width: 85,
                                            height: 85,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stack) {
                                              return _imagenAlternativa();
                                            },
                                          )
                                        : _imagenAlternativa(),
                                  ),

                                  const SizedBox(width: 12),

                                  // Información de la receta.
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          receta['titulo'] ?? 'Sin título',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: texto,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Receta guardada',
                                          style: TextStyle(
                                            color: texto.withOpacity(0.65),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Corazón y papelera.
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 21,
                                  ),

                                  IconButton(
                                    tooltip: 'Eliminar favorito',
                                    onPressed: () {
                                      _confirmarEliminacion(
                                        (receta['recetaId'] as num).toInt(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: texto.withOpacity(0.65),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: 1,
        backgroundColor: Colors.white,
        selectedItemColor: verde,
//        unselectedItemColor: texto.withOpacity(0.66),
        onTap: (index) 
        {
          if (index == 0) 
          {
            Navigator.pop(context);
          }
          else if (index == 2) 
          {
          Navigator.pushReplacementNamed(context, '/extra');
          }
        },
        items: const 
        [
          BottomNavigationBarItem
          (
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.favorite_border/*save, dinnig, bookmark */),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.extension),
            activeIcon: Icon(Icons.extension),
            label: 'Extra',
          ),
        ],
      ),
    );
  }


  // Imagen alternativa si no se puede cargar la fotografía.
  Widget _imagenAlternativa() 
  {
    return Container(
      width: 85,
      height: 85,
      color: verdeClaro.withOpacity(0.25),
      child: Icon(
        Icons.restaurant,
        color: verde,
        size: 35,
      ),
    );
  }
}