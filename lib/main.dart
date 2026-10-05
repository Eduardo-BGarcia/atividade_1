import 'package:flutter/material.dart';
import 'package:atividade_1/pomodoro_app.dart';
import 'package:atividade_1/services/prefs_service.dart';
import 'package:atividade_1/services/crypto_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await PrefsService.init();
  await CryptoService.instance.init();

  runApp(const PomodoroApp());
}