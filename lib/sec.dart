//login
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin()
  {
    if (_formKey.currentState!.validate())
    {
      //si es valida, procesa datos
      final email = _emailController.text;
      final password = _passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('iniciando sesion con $email')),);
      //aqui conecta con el backend?
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Login')
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
            TextFormField
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
          ],
        ),
      ),
      ),
    );
  }
}
