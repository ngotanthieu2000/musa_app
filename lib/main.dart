// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'features/navigation/presentation/widgets/app_navigation.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<HomeBloc>()..add(FetchHomeFeatures()),
        ),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => di.sl<TasksBloc>()..add(FetchTasks()),
        ),
      ],
      child: MaterialApp(
        title: 'Musa App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: AppNavigation(),
      ),
    );
  }
}
