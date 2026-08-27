import 'package:flutter/material.dart';
import 'package:atividade_1/pomodoro_app.dart';
import 'package:atividade_1/services/prefs_service.dart'; // Importe o seu serviço aqui

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await PrefsService.init();

  runApp(const PomodoroApp());
}