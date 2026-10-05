import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_ticker_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categorias = ['Estudar', 'Trabalhar', 'Leitura', 'Exercícios'];
    final cryptoService = CryptoService.instance;

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
      body: Column(
        children: [
          // Lista de Categorias
          Expanded(
            child: ListView.builder(
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
          ),

          // Seção Inferior: Cards das Criptomoedas em Loop Infinito
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.currency_bitcoin, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Criptomoedas em Reais (BRL) - SQLite DB',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      ListenableBuilder(
                        listenable: cryptoService,
                        builder: (context, _) {
                          if (cryptoService.isLoading) {
                            return const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return Text(
                            'Atualiza a cada 10s',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const SizedBox(
                  height: 115,
                  child: CryptoTickerWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}