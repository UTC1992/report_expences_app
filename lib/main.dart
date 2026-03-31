import 'package:flutter/material.dart';
import 'package:report_expences_app/app.dart';
import 'package:report_expences_app/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ReportExpencesApp());
}
