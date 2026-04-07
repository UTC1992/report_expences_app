import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/features/settings/domain/entities/llm_provider.dart';
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
  LlmProvider _selectedLlm = LlmProvider.openai;

  /// Same outline, padding and density for URL, proveedor y token.
  InputDecoration _outlineField(
    BuildContext context, {
    required String label,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final outline = OutlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.outline),
    );
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: outline,
      enabledBorder: outline,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
      suffixIcon: suffixIcon,
    );
  }

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
      setState(() {
        _selectedLlm = vm.llmProvider;
      });
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
      llmProvider: _selectedLlm,
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
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: _outlineField(
                  context,
                  label: 'URL del servidor',
                  hintText: 'https://api.tudominio.com',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'LLM',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: _outlineField(
                  context,
                  label: 'Proveedor',
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<LlmProvider>(
                    value: _selectedLlm,
                    isDense: true,
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyLarge,
                    padding: EdgeInsets.zero,
                    items: [
                      for (final p in LlmProvider.values)
                        DropdownMenuItem(
                          value: p,
                          child: Text(p.displayLabel),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedLlm = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
               Text(
                'Token del LLM',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _llmTokenController,
                obscureText: _obscureToken,
                autocorrect: false,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: _outlineField(
                  context,
                  label: 'Token para el LLM',
                  suffixIcon: IconButton(
                    tooltip: _obscureToken ? 'Mostrar' : 'Ocultar',
                    visualDensity: VisualDensity.compact,
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
