import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notas_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String token = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('https://demo9568909.mockable.io/login'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        token = json.decode(response.body)['token'];
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotasScreen(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ClipOval(
              child: const Image(
                image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2owgtagk4Mo5wda4EOalu3DOhscqDf8onng&s',
                ),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            if (token.isNotEmpty)
              Text(
                  'Token: $token'), // Mostra o token antes de ir para a próxima tela
          ],
        ),
      ),
    );
  }
}
