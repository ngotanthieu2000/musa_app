import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

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
    try {
      emit(TasksLoading());
      final tasks = await repository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      emit(TasksLoading());
      await repository.createTask(
        title: event.title,
        description: event.description,
      );
      final tasks = await repository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      emit(TasksLoading());
      await repository.updateTask(event.task);
      final tasks = await repository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      emit(TasksLoading());
      await repository.deleteTask(event.taskId);
      final tasks = await repository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    try {
      emit(TasksLoading());
      await repository.toggleTaskCompletion(event.taskId);
      final tasks = await repository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
} 