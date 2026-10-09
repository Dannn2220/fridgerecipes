
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

// Convertimos esta parte en StatefulWidget para que la pantalla pueda redibujarse
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Controlador para leer lo que se escribe en la caja de texto
  final TextEditingController _ctrlTexto = TextEditingController();

  // Variable donde se guardará el texto que se mostrara abajo
  String _textoMostrado = '';

  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _ctrlTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Evita errores de espacio si el teclado se abre
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Margen a los lados para la caja de texto
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [
                const Text
                (
                  'Un texto1',
                  style: TextStyle
                  (
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset
                (
                  'assets/images/52002570692211988.jpg',
                  width: 200,
                  height: 300,
                ),
                const SizedBox(height: 16),
                
                // Asigna el controlador al TextField
                TextField(
                  controller: _ctrlTexto,
                  decoration: const InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Inserta un texto',
                  ),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () {
                    // Al presionar el botón, usamos setState para actualizar la pantalla
                    setState(() 
                    {
                      if (_ctrlTexto.text.isNotEmpty) 
                      {
                        _textoMostrado = _ctrlTexto.text;
                      }
                    });
                  },
                  child: const Text('OK'),
                ),
                const SizedBox(height: 16),

                // 5. Mostramos la variable dinámica en lugar de un texto fijo
                Text(
                  _textoMostrado,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
