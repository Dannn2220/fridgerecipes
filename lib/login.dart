//login
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:fridgerecipes/favoritos.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/* crear un json, guardar arreglos con usuario, contra, guardar al menos
-texto de crear cuenta, para que guarde un usuario en un json
-al ingresar el usuario y password guardados, se inicie sesion
-no es necesario crear otra pantalla, pero es opcional. (se hace mucho rollo)
*/
class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
/*
AGREGAR ESTO:
string _paswhash = r'elhashdelapsw'; paara guardar el hash de la contra y despues mostrarla
void main(){
debugprint(bcrypt.hashpw(_password, bcrypt.gensalt())) para que imprima la contra hasheada; 
mainApp ....?
}*/

//usar bcrypt o semillas aleatoriass
class _LoginScreenState extends State<LoginScreen>
{
/*  //user y hash
  final String uservalido = "admin";
  final String pswHash = r'$2a$10$BJ7gzZ3dlE8haHacBnmdPOV5C9fp7Wl8kiJL7rMty.mrto4e9P7HW';//hash de la contra
*/
  // Obtener la ubicación del archivo JSON
  Future<File> _obtenerArchivo() async
  {
    final directorio = await getApplicationDocumentsDirectory();

    return File('${directorio.path}/usuarios.json');
  }

  // Leer los usuarios guardados
  Future<List<Map<String, dynamic>>> _leerUsuarios() async
  {
    final archivo = await _obtenerArchivo();

    if (!await archivo.exists())
    {
      return [];
    }

    String contenido = await archivo.readAsString();

    List<dynamic> datos = jsonDecode(contenido);

    return datos.map((usuario) =>
      Map<String, dynamic>.from(usuario)).toList();
  }

  // Guardar los usuarios en el JSON
  Future<void> _guardarUsuarios(
    List<Map<String, dynamic>> usuarios
  ) async
  {
    final archivo = await _obtenerArchivo();

    String contenido = jsonEncode(usuarios);

    await archivo.writeAsString(contenido);
  }
  Future<void> _registrar() async
{
  String usuario = userController.text.trim();
  String password = pswController.text;

  if (usuario.isEmpty || password.isEmpty)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Completa todos los campos")
      ),
    );
    return;
  }

  List<Map<String, dynamic>> usuarios = await _leerUsuarios();

  // Comprobar si el usuario ya existe
  bool existe = usuarios.any(
    (u) => u['usuario'].toString().toLowerCase() ==
           usuario.toLowerCase()
  );

  if (existe)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Este usuario ya existe")
      ),
    );
    return;
  }

  // Generar hash de la contraseña
  String hash = BCrypt.hashpw(
    password,
    BCrypt.gensalt()
  );

  // Agregar el nuevo usuario
  usuarios.add(
    {
      "usuario": usuario,
      "passwordHash": hash
    }
  );

  // Guardar los cambios
  await _guardarUsuarios(usuarios);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Usuario registrado correctamente")
    ),
  );

  userController.clear();
  pswController.clear();
}

  final userController = TextEditingController();
  final pswController = TextEditingController();

Future<void> _login() async
{
  String usuario = userController.text.trim();
  String password = pswController.text;

  List<Map<String, dynamic>> usuarios = await _leerUsuarios();

  // Buscar el usuario
  for (var u in usuarios)
  {
    if (u['usuario'].toString().toLowerCase() ==
        usuario.toLowerCase())
    {
      // Verificar contraseña
      bool correcto = BCrypt.checkpw(
        password,
        u['passwordHash']
      );

      if (correcto)
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Favoritos()
          ),
        );

        return;
      }
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Usuario o contraseña incorrectos")
    ),
  );
}
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('LoginApp')
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
            Image.asset
            (
              'assets/images/14_10_2026 10_36_20 p. m..png',
              width: 200,
              height: 100,
            ),
            Text('FridgeRecipes'),
            const SizedBox(height: 16),
            TextField
            (
              controller: userController,
              decoration: const InputDecoration
              (
                labelText: "User",
                border: OutlineInputBorder()
              )
            ),
            const SizedBox(height: 15),
            TextField
            (
              controller: pswController,
              obscureText: true,
              decoration: const InputDecoration
              (
                labelText: "Password",
                border: OutlineInputBorder()
              )
            ),
            const SizedBox(height: 25),
            SizedBox(width: double.infinity,child: 
            ElevatedButton(onPressed: _login, child: const Text("Entrar")),
            )
/*            TextFormField
            (
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electronico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty)
                {
                  return 'Porfas ingresa un correo';
                }
                if(!value.contains('@'))
                {
                  return 'Ingresa un correo valido';
                }
                return null;
              },
            ),
            const SizedBox( height: 16),
            //campo de password
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value)
              {
                if (value == null || value.isEmpty)
                {
                  return 'Porfas ingresa tu password';
                }
                if(value.length < 6)
                {
                  return 'Tu password debe contener al menos caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton
            (
              onPressed: _submitLogin,
              child: const Text('Iniciar sesion'),
            ),
*/          ],
        ),
      ),
      ),
    );
  }
}
