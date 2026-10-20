//pantalla secundaria
import 'package:flutter/material.dart';
  class PantallaSecundaria extends StatelessWidget {
  const PantallaSecundaria({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Pantalla Sec'),
      ),
      body: Center
      (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a otra pantalla'),
            //añadir mas cosas
            // por ejemplo, un botón que muestre un mensaje al pulsarlo
            ElevatedButton(
              onPressed: () 
          {
            // Mostrar un mensaje al pulsar el botón
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Botón pulsado!')),
            );
          },
          child: Text('Pulsame'),
        ),
      ),
    );
  }
}