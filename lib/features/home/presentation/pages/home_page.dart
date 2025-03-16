// features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart'; // Import HomeBloc
import '../../domain/usecases/get_home_features.dart'; // Import GetHomeFeatures
import '../../data/repositories/home_repository_impl.dart'; // Import HomeRepositoryImpl
import '../../data/datasources/home_remote_data_source.dart'; // Import HomeRemoteDataSourceImpl
import '../widgets/home_feature_list.dart'; // Import HomeFeatureList

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        getHomeFeatures: GetHomeFeatures(
          repository: HomeRepositoryImpl(
            remoteDataSource: HomeRemoteDataSourceImpl(),
          ),
        ),
      )..add(FetchHomeFeatures()),
      child: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            } else if (state is HomeLoaded) {
              return HomeFeatureList(features: state.features);
            }
            return Container();
          },
        ),
      ),
    );
  }
}