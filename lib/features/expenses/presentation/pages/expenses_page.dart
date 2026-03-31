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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Consumer<ExpensesViewModel>(
        builder: (context, vm, _) {
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
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (vm.expenses.isEmpty) {
            return const Center(child: Text('No expenses yet.'));
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
        },
      ),
    );
  }
}
