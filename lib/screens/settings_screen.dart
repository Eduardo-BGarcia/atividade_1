import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _focusTime = 25;
  int _breakTime = 5;
  int _completedCycles = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _focusTime = PrefsService.focusTime;
      _breakTime = PrefsService.breakTime;
      _completedCycles = PrefsService.completedCycles;
      _isDarkMode = PrefsService.isDarkMode;
    });
  }

  void _updateFocus(int newValue) {
    // if (newValue < 1 || newValue > 60) return;
    PrefsService.setFocusTime(newValue);
    setState(() => _focusTime = newValue);
  }

  void _updateBreak(int newValue) {
    // if (newValue < 1 || newValue > 60) return;
    PrefsService.setBreakTime(newValue);
    setState(() => _breakTime = newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Tema Escuro'),
            subtitle: const Text('Alternar visual do aplicativo'),
            secondary: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              PrefsService.setDarkMode(value);
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Tempo de Foco (minutos)'),
            subtitle: Text('Atualmente: $_focusTime min'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _updateFocus(_focusTime - 5),
                ),
                Text('$_focusTime', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _updateFocus(_focusTime + 5),
                ),
              ],
            ),
          ),
          const Divider(),

          ListTile(
            title: const Text('Tempo de Pausa (minutos)'),
            subtitle: Text('Atualmente: $_breakTime min'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _updateBreak(_breakTime - 1),
                ),
                Text('$_breakTime', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _updateBreak(_breakTime + 1),
                ),
              ],
            ),
          ),
          const Divider(),

          ListTile(
            title: const Text('Estatísticas'),
            subtitle: Text('Ciclos concluídos: $_completedCycles'),
            leading: const Icon(Icons.emoji_events, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}