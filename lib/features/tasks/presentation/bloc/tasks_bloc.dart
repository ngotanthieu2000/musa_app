import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

// Events
abstract class TasksEvent {}

class FetchTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final Task task;
  AddTask(this.task);
}

class UpdateTask extends TasksEvent {
  final Task task;
  UpdateTask(this.task);
}

class DeleteTask extends TasksEvent {
  final String id;
  DeleteTask(this.id);
}

class ToggleTaskCompletion extends TasksEvent {
  final String id;
  ToggleTaskCompletion(this.id);
}

// States
abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;
  TasksLoaded(this.tasks);
}

class TasksError extends TasksState {
  final String message;
  TasksError(this.message);
}

// Bloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository repository;

  TasksBloc({required this.repository}) : super(TasksInitial()) {
    on<FetchTasks>((event, emit) async {
      emit(TasksLoading());
      try {
        final tasks = await repository.getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await repository.createTask(event.task);
        final tasks = await repository.getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        await repository.updateTask(event.task);
        final tasks = await repository.getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await repository.deleteTask(event.id);
        final tasks = await repository.getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<ToggleTaskCompletion>((event, emit) async {
      try {
        await repository.toggleTaskCompletion(event.id);
        final tasks = await repository.getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });
  }
} 