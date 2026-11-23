import 'package:flutter/material.dart';
import 'services/cron.dart';

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
                    child: Center
                    (
                      child: Transform.rotate
                      (
                        angle: cronometro.angulo,
                        child: Container
                        (
                          width: 190,
                          height: 105,
                          decoration: BoxDecoration
                          (
                            color: const Color.fromARGB(255, 72, 157, 57),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
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
