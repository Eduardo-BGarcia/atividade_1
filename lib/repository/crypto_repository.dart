import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/crypto_model.dart';

class CryptoRepository {
  Future<void> saveOrUpdateCryptos(List<CryptoModel> cryptos) async {
    final db = await AppDatabase.instance;
    final batch = db.batch();

    for (final crypto in cryptos) {
      batch.insert(
        'cryptos',
        crypto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<CryptoModel>> getCryptos() async {
    final db = await AppDatabase.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'cryptos',
      orderBy: 'name ASC',
    );
    return maps.map((map) => CryptoModel.fromMap(map)).toList();
  }
}

