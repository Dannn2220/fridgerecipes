import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fridgerecipes/main.dart';
import 'package:fridgerecipes/sec.dart';
//import 'package:fridgerecipes/sec.dart';

class Favoritos extends StatelessWidget 
{
  const Favoritos({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp
    (
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget 
{
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> 
{
  final TextEditingController _ctrlTexto = TextEditingController();

  bool _isCupertinoStyle = false; // Variable para controlar el estilo del switch

  @override
  void dispose() 
  {
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



/*import 'package:flutter/material.dart';
//en esta pantalla se mostrara el apartado de favoritos de recetas, que se guardaran en la base de datos local del dispositivo
class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column
          (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
          Text('Aquí se mostrarán tus recetas favoritas.'),
          ]
          )
      ),
    )
    );
  }
}
*/