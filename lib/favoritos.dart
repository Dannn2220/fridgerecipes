import 'package:flutter/material.dart';
//en esta pantalla se mostrara el apartado de favoritos de recetas, que se guardaran en la base de datos local del dispositivo
class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán tus recetas favoritas.'),
      ),
    );
  }
}
