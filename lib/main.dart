//login
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:fridgerecipes/sec.dart';

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

class _LoginScreenState extends State<LoginScreen>
{
  //user y hash
  final String uservalido = "admin";
  final String pswHash = r'$2a$10$BJ7gzZ3dlE8haHacBnmdPOV5C9fp7Wl8kiJL7rMty.mrto4e9P7HW';//hash de la contra

  final userController = TextEditingController();
  final pswController = TextEditingController();

  void _login()
  {
    String user = userController.text.trim();
    String pswIn = pswController.text.trim();

    bool pswbien = BCrypt.checkpw(pswIn, pswHash);

    if(user == uservalido && pswbien)
    {
      Navigator.push
      (
        context,
        MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid user or password")),
      );
    }
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
            Text('FridgeRecipes'),
            Image.asset
            (
              'assets/images/14_10_2026 10_36_20 p. m..png',
              width: 200,
              height: 100,
            ),
            TextField
            (
              controller: userController,
              decoration: const InputDecoration
              (
                labelText: "User:",
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
                labelText: "password",
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
