import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:report_expences_app/core/di/injection_container.dart';
import 'package:report_expences_app/core/presentation/pages/home_page.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:report_expences_app/features/expenses/presentation/view_models/expenses_view_model.dart';
import 'package:report_expences_app/features/settings/presentation/view_models/settings_view_model.dart';

class ReportExpencesApp extends StatelessWidget {
  const ReportExpencesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<ExpensesViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<ChatViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<SettingsViewModel>()),
      ],
      child: MaterialApp(
        title: 'Reportes de gastos',
        locale: const Locale('es'),
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

