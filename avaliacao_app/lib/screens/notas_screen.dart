import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotasScreen extends StatefulWidget {
  final String token;

  NotasScreen({required this.token});

  @override
  _NotasScreenState createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List<dynamic> alunos = [];

  @override
  void initState() {
    super.initState();
    fetchNotas();
  }

  Future<void> fetchNotas() async {
    final response = await http
        .get(Uri.parse('https://demo9568909.mockable.io/notasAlunos'));

    if (response.statusCode == 200) {
      setState(() {
        alunos = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar notas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas dos Alunos'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    alunos =
                        alunos.where((aluno) => aluno['nota'] < 60).toList();
                  });
                },
                child: Text('Notas < 60'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    alunos = alunos
                        .where((aluno) =>
                            aluno['nota'] >= 60 && aluno['nota'] < 100)
                        .toList();
                  });
                },
                child: Text('Notas >= 60 e < 100'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    alunos =
                        alunos.where((aluno) => aluno['nota'] == 100).toList();
                  });
                },
                child: Text('Notas = 100'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                Color bgColor;
                if (aluno['nota'] == 100) {
                  bgColor = Colors.green;
                } else if (aluno['nota'] >= 60) {
                  bgColor = Colors.blue;
                } else {
                  bgColor = Colors.yellow;
                }
                return Container(
                  color: bgColor,
                  child: ListTile(
                    title: Text(aluno['nome']),
                    subtitle: Text(
                        'Matrícula: ${aluno['matricula']} - Nota: ${aluno['nota']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
