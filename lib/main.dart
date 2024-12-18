import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:task_dio_v2/src/provider/task_provider.dart';
import 'src/app.dart';


void main() async {
  await dotenv.load();
 runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider()..getAllTasks(),
      child: MyApp(),
    ),
  );
}
