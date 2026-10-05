import 'dart:async';
import 'package:flutter/material.dart';
import '../services/crypto_service.dart';

class CryptoTickerWidget extends StatefulWidget {
  const CryptoTickerWidget({super.key});

  @override
  State<CryptoTickerWidget> createState() => _CryptoTickerWidgetState();
}

class _CryptoTickerWidgetState extends State<CryptoTickerWidget> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  Timer? _resumeTimer;
  bool _userInteracting = false;
  final cryptoService = CryptoService.instance;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted || !_scrollController.hasClients || _userInteracting) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (currentScroll >= maxScroll - 10) {
        final cryptosCount = cryptoService.cryptos.length;
        if (cryptosCount > 0) {
          const itemWidth = 187.0;
          final middleIndex = (10000 ~/ 2) - ((10000 ~/ 2) % cryptosCount);
          _scrollController.jumpTo(middleIndex * itemWidth);
        }
      } else {
        _scrollController.jumpTo(currentScroll + 1.0);
      }
    });
  }

  void _onUserInteraction() {
    _userInteracting = true;
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _userInteracting = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _resumeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cryptoService,
      builder: (context, _) {
        final cryptos = cryptoService.cryptos;

        if (cryptos.isEmpty) {
          return Center(
            child: cryptoService.isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Carregando moedas em BRL do banco SQLite...',
                    style: TextStyle(fontSize: 12),
                  ),
          );
        }

        const virtualItemCount = 10000;

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification || notification is UserScrollNotification) {
              _onUserInteraction();
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: virtualItemCount,
            itemBuilder: (context, index) {
              final crypto = cryptos[index % cryptos.length];
              final isPositive = crypto.change24h >= 0;

              return Container(
                width: 175,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (crypto.image.isNotEmpty)
                              Image.network(
                                crypto.image,
                                width: 24,
                                height: 24,
                                errorBuilder: (ctx, err, stack) =>
                                    const Icon(Icons.monetization_on, size: 24),
                              )
                            else
                              const Icon(Icons.monetization_on, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    crypto.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    crypto.symbol,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cryptoService.formatPrice(crypto.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isPositive
                                    ? Colors.green.withAlpha(40)
                                    : Colors.red.withAlpha(40),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                cryptoService.formatChange24h(crypto.change24h),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isPositive
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

