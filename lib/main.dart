import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgerecipes/login.dart';
import 'package:fridgerecipes/services/spoonacular_services.dart';
import 'dart:convert';

/*
opciones de api:
-spoonacular API (mas completa), cuenta con endpoints especificos donde se puede filtrar por tipo de cocina
o buscar directamente por ingredientesque el usuario selecciono
04/11/26
hacer  btone s con las operacines de get post put patch delete hacia la api, y mostrar los resultados en la pantalla principal, o en otra pantalla, segun el caso
*/

void main() 
{
  runApp(const MainApp());
}
class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      themeMode: ThemeMode.dark,
      home: PantallaPrincipal(),
      theme: ThemeData
      (
        brightness: Brightness.light, 
        primaryColor: Colors.red,
      ),
      darkTheme: ThemeData
      (
        brightness: Brightness.dark,
      ),
    );
  }
}

// Convertimos esta parte en StatefulWidget para que la pantalla pueda redibujarse
class PantallaPrincipal extends StatefulWidget 
{
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> 
{
  // Controlador para leer lo que se escribe en la caja de texto
  final TextEditingController _ctrlTexto = TextEditingController();

// Servicio de Spoonacular
  final SpoonacularService _api = SpoonacularService();

// Controladores para conectar al usuario
  final TextEditingController _ctrlUsuario = TextEditingController();
  final TextEditingController _ctrlNombre = TextEditingController();
  final TextEditingController _ctrlApellido = TextEditingController();
  final TextEditingController _ctrlCorreo = TextEditingController();
  final TextEditingController _ctrlIngredientes =TextEditingController();

  bool _cargandoGet = false;
  Map<String, dynamic>? _resultadoGet;

  bool _cargandoPost = false;
  Map<String, dynamic>? _resultadoPost;

  bool _cargandoPut = false;
  Map<String, dynamic>? _resultadoPut;

  bool _cargandoPatch = false;
  Map<String, dynamic>? _resultadoPatch;

  bool _cargandoDelete = false;
  Map<String, dynamic>? _resultadoDelete;

  // Variables para mostrar resultados
  bool _cargando = false;
  Map<String, dynamic>? _resultadoApi;

  Future<void> _conectarUsuario() async 
  {
    setState(() 
    {
      _cargando = true;
      _resultadoApi = null;
    });

    try 
    {
      final resultado = await _api.connectUser
      (
        nombreUsuario: _ctrlUsuario.text.trim(),
        nombre: _ctrlNombre.text.trim(),
        apellido: _ctrlApellido.text.trim(),
        correo: _ctrlCorreo.text.trim(),
      );

      if (!mounted) return;

      setState(() 
      {
        _resultadoApi = resultado;
      });

    } 
    catch (e) 
    {
      if (!mounted) return;

      setState(() 
      {
        _resultadoApi = 
        {
          'error': e.toString(),
        };
      });
    } 
    finally 
    {
      if (mounted) 
      {
        setState(() 
        {
          _cargando = false;
        });
      }
    }
  }

  Future<void> _consultarRecetas() async 
  {
  setState(() {
    _cargandoGet = true;
    _resultadoGet = null;
  });

  try {
    final resultado = await _api.getRecipes(
      _ctrlIngredientes.text.trim(),
    );

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

  Future<void> _enviarReceta() async 
  {
  setState(() {
    _cargandoPost = true;
    _resultadoPost = null;
  });

  try {
    final resultado = await _api.postRecipe();

    if (!mounted) return;

    setState(() {
      _resultadoPost = resultado;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _resultadoPost = {'error': e.toString()};
    });
  } finally {
    if (mounted) {
      setState(() {
        _cargandoPost = false;
      });
    }
  }
}

  Future<void> _actualizarReceta() async 
  {
  setState(() {
    _cargandoPut = true;
    _resultadoPut = null;
  });

  try {
    final resultado = await _api.putRecipe();

    if (!mounted) return;

    setState(() {
      _resultadoPut = resultado;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _resultadoPut = {'error': e.toString()};
    });
  } finally {
    if (mounted) {
      setState(() {
        _cargandoPut = false;
      });
    }
  }
}

  Future<void> _modificarReceta() async 
  {
  setState(() {
    _cargandoPatch = true;
    _resultadoPatch = null;
  });

  try {
    final resultado = await _api.patchRecipe();

    if (!mounted) return;

    setState(() {
      _resultadoPatch = resultado;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _resultadoPatch = {'error': e.toString()};
    });
  } finally {
    if (mounted) {
      setState(() {
        _cargandoPatch = false;
      });
    }
  }
}

  Future<void> _crearElemento() async 
  {
  setState(() {
    _cargandoDelete = true;
    _resultadoDelete = null;
  });

  try {
    final resultado = await _api.addMealPlanItem();

    if (!mounted) return;

    setState(() {
      _resultadoDelete = resultado;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _resultadoDelete = {'error': e.toString()};
    });
  } finally {
    if (mounted) {
      setState(() {
        _cargandoDelete = false;
      });
    }
  }
}

  Future<void> _eliminarElemento() async 
  {
  if (_api.mealPlanItemId == null) {
    setState(() {
      _resultadoDelete = {
        'error': 'Primero debes crear un elemento.'
      };
    });
    return;
  }

  setState(() {
    _cargandoDelete = true;
    _resultadoDelete = null;
  });

  try {
    final resultado = await _api.deleteMealPlanItem(
      _api.mealPlanItemId!,
    );

    if (!mounted) return;

    setState(() {
      _resultadoDelete = resultado;
    });

    if (resultado['statusCode'] == 200) {
      _api.mealPlanItemId = null;
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _resultadoDelete = {'error': e.toString()};
    });
  } finally {
    if (mounted) {
      setState(() {
        _cargandoDelete = false;
      });
    }
  }
}

  // Variable donde se guardará el texto que se mostrara abajo
  //  String _textoMostrado = '';
  bool _isCupertinoStyle = false; // Variable para controlar el estilo del switch

  @override
  void dispose() 
  {
    _ctrlUsuario.dispose();
    _ctrlNombre.dispose();
    _ctrlApellido.dispose();
    _ctrlCorreo.dispose();
    _ctrlIngredientes.dispose();
    // Limpiar el controlador al destruir el widget
    _ctrlTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: Center
      (
        child: SingleChildScrollView( // Evita errores de espacio si el teclado se abre
          child: Padding
          (
            padding: const EdgeInsets.all(16.0), // Margen a los lados para la caja de texto
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [
                 Switch
                (
                  value: _isCupertinoStyle, // Valor inicial del switch
                  onChanged: (bool value) 
                  {
                    // si el value cambia a true, cambia el estilo a cupertino
                    setState(() {
                      _isCupertinoStyle = value;
                    });

                  },
                ),
                const SizedBox(height: 20),
                //dentro de un stack, para que muestre el texto sobre otro texto, y la imagen al frente de ambos textos
                Stack
                (
                  alignment: Alignment.center,
                  children: <Widget>
                  [
                    const Text
                    (
                      'Es un texto en un stack',
                      style: TextStyle
                      (
                        fontSize: 27.5,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 207, 101, 177),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text
                    (
                      'Es un texto en un stack',
                      style: TextStyle
                      (
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 84, 133, 215),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Image.asset
                    (
                      'assets/images/e3da939bd48f9abb31fea4557fa9a5f1.gif',
                      width: 200,
                      height: 100,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Asigna el controlador al TextField
                TextField
                (
                  controller: _ctrlTexto,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Inserta un texto',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton
                (
                  onPressed: () 
                  {
                    // Al presionar el botón, muestre una alerta del estilo segun el switch
                    if (_isCupertinoStyle) 
                    {
                      // Muestra un diálogo de estilo Cupertino
                      showCupertinoDialog
                      (
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog
                        (
                          title: const Text('Alerta en Cupertino'),
                          content: const Text('Esto es una alerta de estilo Cupertino.'),
                          actions: <Widget>
                          [
                            CupertinoDialogAction
                            (
                              onPressed: () 
                              {
                                Navigator.of(context).pop(); //cerrar alerta
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    } 
                    else 
                    {
                      // Muestra un diálogo de estilo Material
                      showDialog
                      (
                        context: context,
                        builder: (BuildContext context)
                        {
                          return AlertDialog
                          (
                            title: const Text('Alerta en Material'),
                            content: const Text('Esto es una alerta de estilo Material.'),
                            actions: <Widget>
                            [
                              TextButton
                              (
                                onPressed: () 
                                {
                                  Navigator.of(context).pop(); // Cierra la alerta
                                },
                                child: const Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
/*                    setState(() 
                    {
                      if (_ctrlTexto.text.isNotEmpty) 
                      {
                        _textoMostrado = _ctrlTexto.text;
                      }
                    });*/
                  },
                  child: const Text('OK'),
                ),
                const SizedBox(height: 16),
                //boton para ir a otra pantalla Ultima actividad 15/10/26
                ElevatedButton
                (
                  onPressed: () 
                  {
                    Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Siguiente'),
                ),
                //mostrar boton con la operacion de mostrar algo traido de la api, usando los metodos de get post put patch y delete. FUNCION con future<map<string, dynamic>> y asi.
                const Divider(height: 40),
                const Text
                (
                  'CONEXIÓN CON SPOONACULAR',
                  style: TextStyle
                  (
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField
                (
                  controller: _ctrlUsuario,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de usuario',
                  ),
                ),
                const SizedBox(height: 10),
                TextField
                (
                  controller: _ctrlNombre,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 10),
                TextField
                (
                  controller: _ctrlApellido,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Apellido',
                  ),
                ),
                const SizedBox(height: 10),
                TextField
                (
                  controller: _ctrlCorreo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Correo electrónico',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton
                (
                  onPressed: _cargando ? null : _conectarUsuario,
                  child: Text
                  (
                    _cargando ? 'Conectando...' : 'Conectar usuario',
                  ),
                ),
                const SizedBox(height: 20),
                if (_resultadoApi != null)
                Container
                (
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration
                  (
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SelectableText
                  (
                    const JsonEncoder.withIndent('  ')
                    .convert(_resultadoApi),
                  ),
                ),
                const Divider(height: 40),

const Text(
  'MÉTODO GET - CONSULTAR RECETAS',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

TextField(
  controller: _ctrlIngredientes,
  decoration: const InputDecoration(
    labelText: 'Ingredientes',
    hintText: 'Ejemplo: egg,tomato,cheese',
  ),
),

ElevatedButton(
  onPressed: _cargandoGet ? null : _consultarRecetas,
  child: Text(
    _cargandoGet ? 'Consultando...' : 'Consultar recetas',
  ),
),

if (_resultadoGet != null)
  SelectableText(
    const JsonEncoder.withIndent('  ')
        .convert(_resultadoGet),
  ),

  const Divider(height: 40),

const Text(
  'MÉTODO POST - ANALIZAR RECETA',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

ElevatedButton(
  onPressed: _cargandoPost ? null : _enviarReceta,
  child: Text(
    _cargandoPost ? 'Enviando...' : 'Enviar receta',
  ),
),

if (_resultadoPost != null)
  SelectableText(
    const JsonEncoder.withIndent('  ')
        .convert(_resultadoPost),
  ),

  const Divider(height: 40),

const Text(
  'MÉTODO PUT - ACTUALIZAR RECETA',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

ElevatedButton(
  onPressed: _cargandoPut ? null : _actualizarReceta,
  child: Text(
    _cargandoPut ? 'Enviando...' : 'Probar PUT',
  ),
),

if (_resultadoPut != null)
  SelectableText(
    const JsonEncoder.withIndent('  ')
        .convert(_resultadoPut),
  ),

const Divider(height: 40),

const Text(
  'MÉTODO PATCH - MODIFICAR RECETA',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

ElevatedButton(
  onPressed: _cargandoPatch ? null : _modificarReceta,
  child: Text(
    _cargandoPatch ? 'Enviando...' : 'Probar PATCH',
  ),
),

if (_resultadoPatch != null)
  SelectableText(
    const JsonEncoder.withIndent('  ')
        .convert(_resultadoPatch),
  ),
const Divider(height: 40),

const Text(
  'MÉTODO DELETE - ELIMINAR ELEMENTO',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

ElevatedButton(
  onPressed: _cargandoDelete ? null : _crearElemento,
  child: const Text('Crear elemento de prueba'),
),

ElevatedButton(
  onPressed: _cargandoDelete ? null : _eliminarElemento,
  child: const Text('Eliminar elemento'),
),

if (_resultadoDelete != null)
  SelectableText(
    const JsonEncoder.withIndent('  ')
        .convert(_resultadoDelete),
  ),
                /*
                future<map<string, dynamic>> replacePost()
                  nose que mas

                 */
/*              //timer que actualice cada 500 milisegundos el color del texto mostrado
                const SizedBox(height: 16),
                StreamBuilder<Color>
                (
                  stream: Stream.periodic(const Duration(milliseconds: 500), (count) 
                  {
                    // Cambia el color cada 500 ms
                    return count % 2 == 0 ? Colors.red : Colors.blue;
                  }),
                  builder: (context, snapshot)
                  {
                    return Text
                    (
                      _textoMostrado,
                      style: TextStyle
                      (
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: snapshot.data ?? Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}