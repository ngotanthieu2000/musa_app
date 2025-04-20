import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart' hide Task;
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../../core/error/failures.dart';

// Events
abstract class TasksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final String title;
  final String description;

  AddTask({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateTask extends TasksEvent {
  final Task task;

  UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TasksEvent {
  final String taskId;

  DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TasksEvent {
  final String taskId;

  ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// States
abstract class TasksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TasksError extends TasksState {
  final String message;

  TasksError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository repository;

  TasksBloc({required this.repository}) : super(TasksInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
  }

  Future<void> _onFetchTasks(
    FetchTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    final result = await repository.getTasks();
    
    emit(result.fold(
      (failure) => TasksError(failure.message),
      (tasks) => TasksLoaded(tasks),
    ));
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    
    final createResult = await repository.createTask(
      title: event.title,
      description: event.description,
    );
    
    await createResult.fold(
      (failure) async => emit(TasksError(failure.message)),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(failure.message),
          (tasks) => TasksLoaded(tasks),
        ));
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    
    final updateResult = await repository.updateTask(event.task);
    
    await updateResult.fold(
      (failure) async => emit(TasksError(failure.message)),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(failure.message),
          (tasks) => TasksLoaded(tasks),
        ));
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    
    final deleteResult = await repository.deleteTask(event.taskId);
    
    await deleteResult.fold(
      (failure) async => emit(TasksError(failure.message)),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(failure.message),
          (tasks) => TasksLoaded(tasks),
        ));
      },
    );
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    
    final toggleResult = await repository.toggleTaskCompletion(event.taskId);
    
    await toggleResult.fold(
      (failure) async => emit(TasksError(failure.message)),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(failure.message),
          (tasks) => TasksLoaded(tasks),
        ));
      },
    );
  }
} 