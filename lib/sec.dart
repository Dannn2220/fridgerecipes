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
      body: const Center
      (
        child: Text('Bienvenido a otra pantalla'),
        
      ),
    );
  }
}