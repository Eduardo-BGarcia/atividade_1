import 'dart:async';
import 'package:flutter/foundation.dart';
import '../api/crypto_api.dart';
import '../models/crypto_model.dart';
import '../repository/crypto_repository.dart';

class CryptoService extends ChangeNotifier {
  static final CryptoService instance = CryptoService._internal();

  factory CryptoService() {
    return instance;
  }

  CryptoService._internal();

  final CryptoApi _api = CryptoApi();
  final CryptoRepository _repository = CryptoRepository();

  Timer? _timer;
  bool _isLoading = false;
  String? _lastError;
  List<CryptoModel> _cryptos = [];

  List<CryptoModel> get cryptos => List.unmodifiable(_cryptos);
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  static const List<String> meustNombresDesejados = [
    'Bitcoin', 'Ethereum', 'XRP', 'Solana', 'Cardano', 'Stellar', 'Chainlink',
    'Hedera', 'Bitcoin Cash', 'Avalanche', 'Litecoin', 'Polkadot', 'Uniswap',
    'Aave', 'NEAR Protocol', 'Ethereum Classic', 'Algorand', 'Cosmos', 'Polygon',
    'Arbitrum', 'Quant', 'Celestia', 'Optimism', 'Immutable X', 'The Graph',
    'Lido DAO Token', 'Tezos', 'Maker'
  ];


  Future<void> init() async {
    await fetchFromDatabase();

    await updateCryptoPrices();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await updateCryptoPrices();
    });
  }

  Future<void> updateCryptoPrices() async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final allCryptos = await _api.fetchMarketCryptos();

      final filteredCryptos = allCryptos.where((crypto) {
        return meustNombresDesejados.any(
          (name) => name.toLowerCase() == crypto.name.toLowerCase(),
        );
      }).toList();

      if (filteredCryptos.isNotEmpty) {
        await _repository.saveOrUpdateCryptos(filteredCryptos);
      }

      await fetchFromDatabase();
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Erro na atualização de criptomoedas: $e');
      await fetchFromDatabase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchFromDatabase() async {
    _cryptos = await _repository.getCryptos();
    notifyListeners();
  }

  String formatPrice(double price) {
    final isNegative = price < 0;
    final absPrice = price.abs();

    String formattedNumber;
    if (absPrice >= 1.0) {
      formattedNumber = _formatWithSeparators(absPrice, 2);
    } else if (absPrice >= 0.0001) {
      formattedNumber = _formatWithSeparators(absPrice, 4);
    } else {
      formattedNumber = _formatWithSeparators(absPrice, 6);
    }

    return '${isNegative ? '-' : ''}R\$ $formattedNumber';
  }

  String _formatWithSeparators(double value, int decimals) {
    final parts = value.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final decimalPart = parts[1];
    return '$integerPart,$decimalPart';
  }

  String formatChange24h(double change) {
    final prefix = change >= 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(2)}%';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

