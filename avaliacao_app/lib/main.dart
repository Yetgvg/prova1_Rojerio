import 'dart:io'; // Importação necessária para manipulação de certificados SSL
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importação da sua tela inicial (ajuste o caminho se necessário)

// Classe para ignorar a verificação de certificados SSL
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avaliação Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Tela inicial do seu aplicativo
    );
  }
}
