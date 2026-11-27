import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:fridgerecipes/favoritos.dart';
import 'package:fridgerecipes/services/spoonacular_services.dart';
import 'package:fridgerecipes/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SQLite para escritorio.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FridgeRecipes',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5FAF4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const PantallaPrincipal(),
        '/favoritos': (context) => const Favoritos(),
      },
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final SpoonacularService _api = SpoonacularService();

  // El nombre visible está en español y el valor enviado a Spoonacular en inglés.
  final List<Map<String, String>> _catalogoIngredientes = [
    {'nombre': 'Huevo', 'api': 'egg'},
    {'nombre': 'Tomate', 'api': 'tomato'},
    {'nombre': 'Cebolla', 'api': 'onion'},
    {'nombre': 'Papa', 'api': 'potato'},
    {'nombre': 'Queso', 'api': 'cheese'},
    {'nombre': 'Pollo', 'api': 'chicken'},
    {'nombre': 'Arroz', 'api': 'rice'},
    {'nombre': 'Leche', 'api': 'milk'},
    {'nombre': 'Zanahoria', 'api': 'carrot'},
    {'nombre': 'Ajo', 'api': 'garlic'},
    {'nombre': 'Pimiento', 'api': 'bell pepper'},
    {'nombre': 'Pasta', 'api': 'pasta'},
    {'nombre': 'Limón', 'api': 'lemon'},
    {'nombre': 'Atún', 'api': 'tuna'},
    {'nombre': 'Frijoles', 'api': 'beans'},
    {'nombre': 'Aguacate', 'api': 'avocado'},
  ];

  final Set<String> _ingredientesSeleccionados = {};
  bool _cargandoGet = false;
  Map<String, dynamic>? _resultadoGet;

  final Color verde = const Color(0xFF2E7D32);
  final Color verdeClaro = const Color(0xFFA5D6A7);
  final Color fondo = const Color(0xFFF5FAF4);
  final Color texto = const Color(0xFF20352A);

  Future<void> _consultarRecetas() async {
    if (_ingredientesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un ingrediente.'),
        ),
      );
      return;
    }

    setState(() {
      _cargandoGet = true;
      _resultadoGet = null;
    });

    try {
      final ingredientes = _ingredientesSeleccionados.join(',');
      final resultado = await _api.getRecipes(ingredientes);

      if (!mounted) return;
      setState(() {
        _resultadoGet = resultado;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resultadoGet = {'error': e.toString()};
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargandoGet = false;
        });
      }
    }
  }

  Future<void> _guardarFavorito(Map<String, dynamic> receta) async {
    try {
      final resultado =
          await DatabaseHelper.instance.insertarFavorito(receta);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado == -1
                ? 'Esta receta ya está en tus favoritos.'
                : 'Receta guardada en favoritos.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  Widget _crearTarjetaReceta(Map<String, dynamic> receta) {
    final ingredientesUsados =
        receta['usedIngredients'] as List? ?? [];
    final ingredientesFaltantes =
        receta['missedIngredients'] as List? ?? [];
    final imagen = receta['image']?.toString() ?? '';

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagen.isNotEmpty)
            Image.network(
              imagen,
              height: 165,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 130,
                  color: const Color(0xFFE8F2E6),
                  alignment: Alignment.center,
                  child: Icon(Icons.restaurant, size: 48, color: verde),
                );
              },
            )
          else
            Container(
              height: 130,
              color: const Color(0xFFE8F2E6),
              alignment: Alignment.center,
              child: Icon(Icons.restaurant, size: 48, color: verde),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        receta['title']?.toString() ?? 'Receta sin título',
                        style: TextStyle(
                          color: texto,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _guardarFavorito(receta),
                      icon: Icon(Icons.favorite_border, color: verde),
                      tooltip: 'Guardar en favoritos',
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${receta['usedIngredientCount'] ?? 0} ingredientes disponibles'
                  '  •  ${receta['missedIngredientCount'] ?? 0} faltantes',
                  style: TextStyle(color: texto.withOpacity(0.75)),
                ),
                if (ingredientesUsados.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Ya tienes:',
                    style: TextStyle(
                      color: verde,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ingredientesUsados
                        .map((item) => item['name'] ?? '')
                        .where((name) => name.toString().isNotEmpty)
                        .join(', '),
                    style: TextStyle(color: texto),
                  ),
                ],
                if (ingredientesFaltantes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Te falta:',
                    style: TextStyle(
                      color: texto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ingredientesFaltantes
                        .map((item) => item['name'] ?? '')
                        .where((name) => name.toString().isNotEmpty)
                        .join(', '),
                    style: TextStyle(color: texto),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recetas = _resultadoGet?['data'];

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.kitchen_outlined, color: verde, size: 25),
            const SizedBox(width: 8),
            Text(
              'FRIDGE RECIPES',
              style: TextStyle(
                color: verde,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué hay en tu refri?',
                style: TextStyle(
                  color: texto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Selecciona los ingredientes que tienes y encuentra algo delicioso para preparar.',
                style: TextStyle(
                  color: texto.withOpacity(0.75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecciona tus ingredientes',
                      style: TextStyle(
                        color: texto,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Puedes elegir más de uno.',
                      style: TextStyle(
                        color: texto.withOpacity(0.65),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _catalogoIngredientes.map((ingrediente) {
                        final api = ingrediente['api']!;
                        final seleccionado =
                            _ingredientesSeleccionados.contains(api);

                        return FilterChip(
                          label: Text(ingrediente['nombre']!),
                          selected: seleccionado,
                          showCheckmark: true,
                          selectedColor: verdeClaro,
                          backgroundColor: fondo,
                          checkmarkColor: verde,
                          labelStyle: TextStyle(
                            color: texto,
                            fontWeight: seleccionado
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: seleccionado ? verdeClaro : Colors.black12,
                          ),
                          onSelected: (valor) {
                            setState(() {
                              if (valor) {
                                _ingredientesSeleccionados.add(api);
                              } else {
                                _ingredientesSeleccionados.remove(api);
                              }
                              _resultadoGet = null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_ingredientesSeleccionados.length} ingrediente(s) seleccionado(s)',
                      style: TextStyle(
                        color: verde,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _cargandoGet ? null : _consultarRecetas,
                        icon: _cargandoGet
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          _cargandoGet ? 'Buscando recetas...' : 'Ver recetas',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_cargandoGet)
                Center(
                  child: CircularProgressIndicator(color: verde),
                )
              else if (_resultadoGet?['error'] != null)
                _mensajeResultado(
                  'Ocurrió un problema al consultar las recetas.\n${_resultadoGet!['error']}',
                )
              else if (_resultadoGet != null && recetas is List) ...[
                Text(
                  'Recetas para ti',
                  style: TextStyle(
                    color: texto,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (recetas.isEmpty)
                  _mensajeResultado(
                    'No encontramos recetas con esa combinación. Intenta seleccionar otros ingredientes.',
                  )
                else
                  ...recetas.map((receta) {
                    return _crearTarjetaReceta(
                      Map<String, dynamic>.from(receta as Map),
                    );
                  }),
              ] else if (_resultadoGet != null)
                _mensajeResultado(
                  'No se pudieron mostrar los resultados. Intenta nuevamente.',
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: verde,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/favoritos');
          } else {
            Navigator.pushNamed(context, '/home');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _mensajeResultado(String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        mensaje,
        style: TextStyle(color: texto),
        textAlign: TextAlign.center,
      ),
    );
  }
}
