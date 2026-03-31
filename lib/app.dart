import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/core/di/injection_container.dart';
import 'package:report_expences_app/features/expenses/presentation/pages/expenses_page.dart';
import 'package:report_expences_app/features/expenses/presentation/view_models/expenses_view_model.dart';

class ReportExpencesApp extends StatelessWidget {
  const ReportExpencesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ExpensesViewModel>(),
      child: MaterialApp(
        title: 'Expense reports',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const ExpensesPage(),
      ),
    );
  }
}
