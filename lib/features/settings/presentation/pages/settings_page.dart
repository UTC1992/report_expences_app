import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/features/settings/presentation/view_models/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _llmTokenController = TextEditingController();
  bool _obscureToken = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final vm = context.read<SettingsViewModel>();
      await vm.load();
      if (!mounted) return;
      _serverUrlController.text = vm.serverBaseUrl;
      _llmTokenController.text = vm.llmApiKey;
    });
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _llmTokenController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final vm = context.read<SettingsViewModel>();
    await vm.save(
      serverBaseUrl: _serverUrlController.text,
      llmApiKey: _llmTokenController.text,
    );
    if (!mounted) return;
    if (vm.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajustes guardados.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Consumer<SettingsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && _serverUrlController.text.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Conexión',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _serverUrlController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'URL del servidor',
                  hintText: 'https://api.tudominio.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'LLM',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _llmTokenController,
                obscureText: _obscureToken,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Token para el LLM',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: _obscureToken ? 'Mostrar' : 'Ocultar',
                    onPressed: () {
                      setState(() {
                        _obscureToken = !_obscureToken;
                      });
                    },
                    icon: Icon(
                      _obscureToken ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (vm.isSaving)
                const Center(child: CircularProgressIndicator())
              else
                FilledButton(
                  onPressed: vm.isLoading ? null : _onSave,
                  child: const Text('Guardar'),
                ),
              const SizedBox(height: 12),
              Text(
                'La URL y el token se guardan de forma cifrada en el dispositivo.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
