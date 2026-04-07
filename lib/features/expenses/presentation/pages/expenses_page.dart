import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/features/expenses/presentation/view_models/expenses_view_model.dart';
import 'package:report_expences_app/features/expenses/presentation/widgets/expense_list_tile.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpensesViewModel>().load();
    });
  }

  Future<void> _pickDateRange(BuildContext context, ExpensesViewModel vm) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: vm.dateRange.startInclusive,
        end: vm.dateRange.endInclusive,
      ),
      helpText: 'Rango de fechas',
      cancelText: 'Cancelar',
      // Modo calendario a pantalla completa usa [saveText], no [confirmText].
      saveText: 'Confirmar',
      confirmText: 'Confirmar',
    );
    if (range != null && context.mounted) {
      vm.setDateRange(range.start, range.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: Consumer<ExpensesViewModel>(
        builder: (context, vm, _) {
          final loc = MaterialLocalizations.of(context);
          final startLabel = loc.formatMediumDate(vm.dateRange.startInclusive);
          final endLabel = loc.formatMediumDate(vm.dateRange.endInclusive);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.35),
                child: InkWell(
                  onTap: () => _pickDateRange(context, vm),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Periodo',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$startLabel — $endLabel',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildListBody(vm),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListBody(ExpensesViewModel vm) {
    if (vm.isLoading && vm.expenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: vm.load,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (vm.expenses.isEmpty) {
      return const Center(child: Text('No hay gastos registrados.'));
    }
    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: vm.expenses.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ExpenseListTile(expense: vm.expenses[index]);
        },
      ),
    );
  }
}
