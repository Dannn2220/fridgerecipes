
import 'package:flutter/material.dart';

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
      home: Scaffold
      (
        body: Center
        (
          child: Column
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>
            [
              Text
              (
                'Un texto1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16), // para espaciado
              Image.asset
              (
                'assets/images/52002570692211988.jpg', // Ruta de la imagen en la carpetassets
                width: 200,
                height: 300,
              ),
              SizedBox(height: 16),
              TextField
              (
                decoration: InputDecoration
                (
                  border: OutlineInputBorder(),
                  labelText: 'Inserta un texto',
                ),
              ),
              ElevatedButton
              (
                onPressed: () {
    // Código que se ejecuta al presionar el botón
                },
                child: Text('OK'),
              ),

              Text
              (
               '',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ]
          )
        )
      )
    );
  }
}
