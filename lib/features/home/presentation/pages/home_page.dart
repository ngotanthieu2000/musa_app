// features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/feature_card.dart';
import '../../../auth/presentation/widgets/auth_dialog.dart';
import '../../domain/entities/feature.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musa App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AuthDialog(isLogin: true),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AuthDialog(isLogin: false),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          if (state is HomeLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.features.length,
              itemBuilder: (context, index) {
                final homeFeature = state.features[index];
                final feature = Feature(
                  title: homeFeature.title,
                  icon: homeFeature.icon,
                  route:
                      '/${homeFeature.title.toLowerCase().replaceAll(' ', '_')}',
                );
                return FeatureCard(feature: feature);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
