import 'package:flutter/material.dart';
import 'services/cron.dart';
import 'dart:math';

class PantallaExtra extends StatelessWidget 
{
  const PantallaExtra({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final cronometro = CronometroCompartido.instance;

    return Scaffold
    (
      backgroundColor: Colors.white,

      body: SafeArea
      (
        child: AnimatedBuilder
        (
          //manda llamar a la instancia desde el otro archivo
          animation: cronometro,
          builder: (context, child) 
          {
            return Padding
            (
              padding: const EdgeInsets.all(25),

              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  // Contador de segundos en la esquina superior.
                  Text
                  (
                    '${cronometro.segundos}',
                    style: const TextStyle
                    (
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  // Elemento giratorio.
                  Expanded
                  (
                    child: LayoutBuilder
                    (
                      builder: (context, constraints) 
                      {
                        // Calcula el desplazamiento según la inclinación.
                        final double desplazamientoX =
                            cronometro.inclinada
                                ? sin(cronometro.inclinacion) * constraints.maxWidth * 0.45
                                : 0;
                        final double desplazamientoY =
                            cronometro.inclinada
                                ? cos(cronometro.inclinacion) * constraints.maxHeight * 0.45
                                : 0;
                        return AnimatedContainer
                        (
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment
                          (
                            cronometro.inclinada
                                ? desplazamientoX / (constraints.maxWidth / 2)
                                : 0,
                            cronometro.inclinada
                                ? desplazamientoY / (constraints.maxHeight / 2)
                                : 0,
                          ),
                          child: Transform.rotate
                          (
                            angle: cronometro.inclinada
                                ? cronometro.inclinacion
                                : cronometro.angulo,
                            child: AnimatedContainer
                            (
                              duration: const Duration(milliseconds: 200),
                              width: 190,
                              height: 105,
                              decoration: BoxDecoration
                              (
                                color: cronometro.alerta
                                    ? Colors.red
                                    : const Color.fromARGB(255, 72, 157, 57),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // Barra inferior.
      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: 2,

        onTap: (index) 
        {
          if (index == 0) 
          {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) 
          {
            Navigator.pushReplacementNamed(context, '/favoritos');
          }
        },

        items: const 
        [
          BottomNavigationBarItem
          (
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.extension),
            label: 'Extra',
          ),
        ],
      ),
    );
  }
}
