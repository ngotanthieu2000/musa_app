import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/persona_injection_container.dart' as di;
import '../presentation/bloc/persona_bloc.dart';
import '../routes/persona_routes.dart';
import '../data/datasources/persona_mock_data_source.dart';
import '../data/repositories/persona_repository_impl.dart';
import '../../../core/network/network_info.dart';

class PersonaDemoApp extends StatefulWidget {
  const PersonaDemoApp({Key? key}) : super(key: key);

  @override
  State<PersonaDemoApp> createState() => _PersonaDemoAppState();
}

class _PersonaDemoAppState extends State<PersonaDemoApp> {
  late final GoRouter _router;
  late final PersonaBloc _personaBloc;

  @override
  void initState() {
    super.initState();
    _initDependencies();
    _initRouter();
  }

  void _initDependencies() async {
    await di.initPersonaFeature();
    
    // For demo purposes, we'll use the mock data source directly
    final mockDataSource = di.sl<PersonaMockDataSource>();
    final networkInfo = di.sl<NetworkInfo>();
    
    // Create a repository that uses the mock data source
    final repository = PersonaRepositoryImpl(
      remoteDataSource: mockDataSource,
      networkInfo: networkInfo,
    );
    
    // Create the bloc with the repository
    _personaBloc = PersonaBloc(
      getPersona: di.sl(),
      updatePersona: di.sl(),
      recordEmotionalState: di.sl(),
      addGoal: di.sl(),
      updateGoal: di.sl(),
      deleteGoal: di.sl(),
      updatePersonality: di.sl(),
      updateInteractionPreference: di.sl(),
      updateMotivationFactors: di.sl(),
      generateInsights: di.sl(),
      analyzeWithAIAdvisor: di.sl(),
    );
  }

  void _initRouter() {
    _router = GoRouter(
      initialLocation: '/persona',
      routes: getPersonaRoutes(),
    );
  }

  @override
  void dispose() {
    _personaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _personaBloc,
      child: MaterialApp.router(
        title: 'AI Persona Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
