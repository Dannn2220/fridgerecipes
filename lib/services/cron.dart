
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CronometroCompartido extends ChangeNotifier {
  static final CronometroCompartido instance =
      CronometroCompartido._();

  final Stopwatch _cronometro = Stopwatch();

  // Control de la rotación.
  double _angulo = 0;
  DateTime _ultimaActualizacion = DateTime.now();

  // Datos del sensor.
  double inclinacion = 0;
  bool inclinada = false;
  bool alerta = false;

  Timer? _temporizadorAlerta;

  CronometroCompartido._() {
    _cronometro.start();

    // Actualiza el contador y la animación.
    Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        final ahora = DateTime.now();
        final diferencia =
            ahora.difference(_ultimaActualizacion).inMilliseconds;

        _ultimaActualizacion = ahora;

        // Solo gira si el celular está estable.
        if (!inclinada && !alerta) {
          _angulo += (diferencia / 40000) * 2 * pi;
        }

        notifyListeners();
      },
    );

    // Escucha los movimientos del celular.
    accelerometerEventStream().listen((event) {
      // Detecta la inclinación lateral.
      inclinacion = atan2(-event.x, event.y);

      inclinada = event.x.abs() > 2.5;

      // Detecta una agitación brusca.
      final magnitud = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      if (magnitud > 18) {
        alerta = true;

        // Reinicia el tiempo de la alerta.
        _temporizadorAlerta?.cancel();
        _temporizadorAlerta = Timer(
          const Duration(milliseconds: 900),
          () {
            alerta = false;
            notifyListeners();
          },
        );
      }

      notifyListeners();
    });
  }

  // Contador que comienza en 1.
  int get segundos => _cronometro.elapsed.inSeconds + 1;

  // Ángulo acumulado de rotación.
  double get angulo => _angulo;
}
