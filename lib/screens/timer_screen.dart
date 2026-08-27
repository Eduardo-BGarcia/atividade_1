import 'dart:async';
import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class TimerScreen extends StatefulWidget {
  final String categoria;
  
  const TimerScreen({super.key, required this.categoria});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _timeLeft = 0;
  bool _isRunning = false;
  bool _isFocusMode = true;

  late int _focusTimeInSeconds;
  late int _breakTimeInSeconds;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _focusTimeInSeconds = PrefsService.focusTime * 60;
    _breakTimeInSeconds = PrefsService.breakTime * 60;
    _timeLeft = _focusTimeInSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _onTimerComplete();
          }
        });
      });
    }
  }

  void _onTimerComplete() async {
    _timer?.cancel();
    _isRunning = false;

    if (_isFocusMode) {
      await PrefsService.incrementCycle();
      
      _timeLeft = _breakTimeInSeconds;
      _isFocusMode = false;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foco concluído! Hora da pausa.')),
        );
      }
    } else {
      _timeLeft = _focusTimeInSeconds;
      _isFocusMode = true;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pausa concluída! De volta ao foco.')),
        );
      }
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isFocusMode = true;
      _timeLeft = _focusTimeInSeconds;
    });
  }

  String get _formattedTime {
    final minutes = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronômetro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isFocusMode ? 'Focando em:' : 'Pausando de:',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            Text(
              widget.categoria, 
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              _formattedTime,
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _resetTimer,
                  child: const Icon(Icons.stop),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.extended(
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}