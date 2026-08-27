import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categorias = ['Estudar', 'Trabalhar', 'Leitura', 'Exercícios'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Simples'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          
          return Card(
            child: ListTile(
              title: Text(categoria),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push('/timer/$categoria');
              },
            ),
          );
        },
      ),
    );
  }
}