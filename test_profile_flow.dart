import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musa_app/features/profile/domain/entities/profile.dart';
import 'package:musa_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:musa_app/core/di/injection_container.dart' as di;

// Este script simula el flujo completo de actualización de perfil
// para verificar si los datos se actualizan correctamente

void main() async {
  // Inicializar dependencias
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  
  // Obtener instancia del ProfileBloc
  final profileBloc = di.sl<ProfileBloc>();
  
  // Suscribirse a los cambios de estado
  profileBloc.stream.listen((state) {
    print('Estado actual: $state');
    
    if (state is ProfileLoaded) {
      print('Perfil cargado:');
      print('ID: ${state.profile.id}');
      print('Nombre: ${state.profile.name}');
      print('Email: ${state.profile.email}');
      print('Teléfono: ${state.profile.phoneNumber}');
      print('Bio: ${state.profile.bio}');
      print('Avatar: ${state.profile.avatar}');
    } else if (state is ProfileError) {
      print('Error: ${state.message}');
    } else if (state is ProfileActionSuccess) {
      print('Acción exitosa: ${state.message}');
    }
  });
  
  // Paso 1: Obtener perfil actual
  print('\n=== PASO 1: Obtener perfil actual ===');
  profileBloc.add(const GetProfileEvent());
  
  // Esperar a que se cargue el perfil
  await Future.delayed(const Duration(seconds: 2));
  
  // Paso 2: Actualizar perfil
  print('\n=== PASO 2: Actualizar perfil ===');
  final updatedProfile = Profile(
    id: '1', // Asegúrate de usar el ID correcto
    name: 'Nombre Actualizado',
    email: 'email@example.com', // Mantener el mismo email
    phoneNumber: '0987654321',
    bio: 'Esta es una biografía actualizada para probar el flujo',
    // Otros campos según sea necesario
  );
  
  profileBloc.add(UpdateProfileEvent(updatedProfile));
  
  // Esperar a que se actualice el perfil
  await Future.delayed(const Duration(seconds: 3));
  
  // Paso 3: Verificar si el perfil se actualizó correctamente
  print('\n=== PASO 3: Verificar perfil actualizado ===');
  profileBloc.add(const GetProfileEvent());
  
  // Esperar a que se cargue el perfil actualizado
  await Future.delayed(const Duration(seconds: 2));
  
  // Finalizar
  print('\n=== Prueba completada ===');
  exit(0);
}
