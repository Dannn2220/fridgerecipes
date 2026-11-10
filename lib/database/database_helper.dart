
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper 
{
  // Instancia única de la base de datos
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Obtener la base de datos
  Future<Database> get database async 
  {
    if (_database != null) return _database!;

    _database = await _initDB('fridgerecipes.db');

    return _database!;
  }

  // Crear o abrir la base de datos
  Future<Database> _initDB(String filePath) async 
  {
    final dbPath = await getDatabasesPath();
    final pathDB = join(dbPath, filePath);

    return await openDatabase(
      pathDB,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crear la tabla de favoritos
  Future<void> _createDB(Database db, int version) async 
  {
    await db.execute('''
      CREATE TABLE favoritos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recetaId INTEGER NOT NULL UNIQUE,
        titulo TEXT NOT NULL,
        imagen TEXT
      )
    ''');
  }

  // Guardar una receta como favorita
  Future<int> insertarFavorito(Map<String, dynamic> receta) async 
  {
    final db = await instance.database;

    return await db.insert(
      'favoritos',
      {
        'recetaId': receta['id'],
        'titulo': receta['title'],
        'imagen': receta['image'],
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Consultar todas las recetas favoritas
  Future<List<Map<String, dynamic>>> obtenerFavoritos() async 
  {
    final db = await instance.database;

    return await db.query(
      'favoritos',
      orderBy: 'id DESC',
    );
  }

  // Eliminar una receta de favoritos
  Future<int> eliminarFavorito(int recetaId) async 
  {
    final db = await instance.database;

    return await db.delete(
      'favoritos',
      where: 'recetaId = ?',
      whereArgs: [recetaId],
    );
  }

}
