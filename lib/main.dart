// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:myapp/features/navigation/presentation/widgets/app_navigation.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Khởi tạo dependencies
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<HomeBloc>()..add(FetchHomeFeatures())),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => di.sl<TasksBloc>()..add(FetchTasks()),
        ),
      ],
      child: MaterialApp(
        title: 'AI Learning App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AppNavigation(),
      ),
    );
  }
}
