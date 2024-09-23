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
  List<dynamic> alunosFiltrados = [];

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
        alunosFiltrados = alunos; // Inicialmente, exiba todos os alunos
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar notas!')),
      );
    }
  }

  void filtrarNotasMenorQue60() {
    setState(() {
      alunosFiltrados = alunos.where((aluno) => aluno['nota'] < 60).toList();
    });
  }

  void filtrarNotasEntre60e100() {
    setState(() {
      alunosFiltrados = alunos
          .where((aluno) => aluno['nota'] >= 60 && aluno['nota'] < 100)
          .toList();
    });
  }

  void filtrarNotasIgual100() {
    setState(() {
      alunosFiltrados = alunos.where((aluno) => aluno['nota'] == 100).toList();
    });
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
                onPressed: filtrarNotasMenorQue60,
                child: Text('Notas baixas'),
              ),
              ElevatedButton(
                onPressed: filtrarNotasEntre60e100,
                child: Text('Notas na média'),
              ),
              ElevatedButton(
                onPressed: filtrarNotasIgual100,
                child: Text('Notas perfeitas'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: alunosFiltrados.length,
              itemBuilder: (context, index) {
                final aluno = alunosFiltrados[index];
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
