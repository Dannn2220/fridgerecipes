import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CronometroCompartido extends ChangeNotifier 
{
  static final CronometroCompartido instance = CronometroCompartido._();

  final Stopwatch _cronometro = Stopwatch();

  CronometroCompartido._() 
  {
    _cronometro.start();

    // Actualiza la animación continuamente, incluso cuando la pantalla no está visible.
    Timer.periodic
    (
      const Duration(milliseconds: 50),
      (timer) 
      {
        notifyListeners();
      },
    );
  }

  // Contador que comienza en 1.
  int get segundos => _cronometro.elapsed.inSeconds + 1;

  // Ángulo de rotación en sentido horario.
  double get angulo 
  {
    return (_cronometro.elapsedMilliseconds / 40000) * 2 * pi;
  }
}
