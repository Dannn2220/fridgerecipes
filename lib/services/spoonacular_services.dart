
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  static const String _baseUrl = 'api.spoonacular.com';

  // La API KEY se recibe desde la terminal.
  static const String _apiKey = String.fromEnvironment(
    'SPOONACULAR_API_KEY',
  );

  int? mealPlanItemId;

  // Datos que Spoonacular devuelve al conectar al usuario.
  String? username;
  String? hash;

  Map<String, String> get _headers => {
    'x-api-key': _apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Convierte la respuesta del servidor a un formato que podamos mostrar.
  Map<String, dynamic> _resultado(http.Response response) {
    dynamic contenido;

    try {
      contenido = jsonDecode(response.body);
    } catch (_) {
      contenido = response.body;
    }

    return {
      'statusCode': response.statusCode,
      'mensaje': response.reasonPhrase ?? '',
      'data': contenido,
    };
  }

  // CONECTAR USUARIO: POST /users/connect
  Future<Map<String, dynamic>> connectUser({
    required String nombreUsuario,
    required String nombre,
    required String apellido,
    required String correo,
  }) async {
    final uri = Uri.https(_baseUrl, '/users/connect');

    final body = {
      'username': nombreUsuario,
      'firstName': nombre,
      'lastName': apellido,
      'email': correo,
    };

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    final resultado = _resultado(response);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        resultado['data'] is Map) {
      username = resultado['data']['username'];
      hash = resultado['data']['hash'];
    }

    return resultado;
  }

  // GET: buscar recetas por ingredientes.
  Future<Map<String, dynamic>> getRecipes(
    String ingredientes,
  ) async {
    final uri = Uri.https(
      _baseUrl,
      '/recipes/findByIngredients',
      {
        'ingredients': ingredientes,
        'number': '5',
        'ranking': '1',
      },
    );

    final response = await http.get(uri, headers: _headers);
    return _resultado(response);
  }

  // POST: analizar una receta.
  Future<Map<String, dynamic>> postRecipe() async {
    final uri = Uri.https(
      _baseUrl,
      '/recipes/analyze',
      {
        'includeNutrition': 'true',
      },
    );

    final body = {
      'title': 'Omelette',
      'servings': 1,
      'ingredients': [
        '2 eggs',
        '1 tablespoon milk',
        '1 tablespoon butter',
      ],
      'instructions': 'Mix the ingredients and cook in a pan.',
    };

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    return _resultado(response);
  }

  // PUT: probar el método sobre la ruta de búsqueda.
  // Spoonacular no documenta PUT para este endpoint.
  Future<Map<String, dynamic>> putRecipe() async 
  {
    final uri = Uri.https
    (
      _baseUrl,
      '/recipes/findByIngredients',
      {
        'ingredients': 'egg,tomato',
        'number': '5',
      },
    );

    final response = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode({
        'ingredients': 'egg,tomato',
      }),
    );

    return _resultado(response);
  }

  // PATCH: probar el método sobre la misma ruta.
  // Spoonacular no documenta PATCH para este endpoint.
  Future<Map<String, dynamic>> patchRecipe() async 
  {
    final uri = Uri.https(
      _baseUrl,
      '/recipes/findByIngredients',
      {
        'ingredients': 'egg,tomato',
        'number': '5',
      },
    );

    final response = await http.patch
    (
      uri,
      headers: _headers,
      body: jsonEncode({
        'ingredients': 'egg,tomato',
      }),
    );

    return _resultado(response);
  }

Future<Map<String, dynamic>> addMealPlanItem() 
async {
  if (username == null || hash == null) {
    throw Exception('Primero debes conectar un usuario.');
  }

  final ahora = DateTime.now();
  final fecha = DateTime(
    ahora.year,
    ahora.month,
    ahora.day,
  ).toUtc().millisecondsSinceEpoch ~/ 1000;

  final uri = Uri.https(
    _baseUrl,
    '/mealplanner/$username/items',
    {'hash': hash!},
  );

  final body = {
    'date': fecha,
    'slot': 1,
    'position': 0,
    'type': 'INGREDIENTS',
    'value': {
      'ingredients': [
        {'name': '1 banana'},
      ],
    },
  };

  final response = await http.post(
    uri,
    headers: _headers,
    body: jsonEncode(body),
  );

  final resultado = _resultado(response);

  if (response.statusCode >= 200 &&
      response.statusCode < 300 &&
      resultado['data'] is Map &&
      resultado['data']['id'] is num) {
    mealPlanItemId = (resultado['data']['id'] as num).toInt();
  }

  return resultado;
}
  // DELETE: eliminar un elemento del plan de comidas.
  Future<Map<String, dynamic>> deleteMealPlanItem(
    int itemId,
  ) async {
    if (username == null || hash == null) {
      throw Exception(
        'Primero debes conectar un usuario con Spoonacular.',
      );
    }

    final uri = Uri.https(
      _baseUrl,
      '/mealplanner/$username/items/$itemId',
      {
        'hash': hash!,
      },
    );

    final response = await http.delete(
      uri,
      headers: _headers,
    );

    return _resultado(response);
  }
}
