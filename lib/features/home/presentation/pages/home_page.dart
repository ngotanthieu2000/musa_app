// features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../domain/entities/feature.dart';
import '../bloc/home_bloc.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Learning App'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess && state.isAuthenticated) {
                return IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                );
              }
              return IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AuthDialog(isLogin: true),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (authState is AuthSuccess && !authState.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chào mừng đến với AI Learning App',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 24),
                  AuthButtons(),
                ],
              ),
            );
          }

          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is HomeError) {
                return Center(child: Text(state.message));
              }

              if (state is HomeLoaded) {
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.features.length,
                  itemBuilder: (context, index) {
                    final feature = state.features[index];
                    return FeatureCard(feature: feature);
                  },
                );
              }

              return Center(child: Text('Vui lòng đăng nhập để tiếp tục'));
            },
          );
        },
      ),
    );
  }
}