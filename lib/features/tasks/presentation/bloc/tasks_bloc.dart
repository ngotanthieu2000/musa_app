import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';

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
  final GetTasks getTasks;

  TasksBloc({required this.getTasks}) : super(TasksInitial()) {
    on<FetchTasks>((event, emit) async {
      emit(TasksLoading());
      try {
        final tasks = await getTasks();
        emit(TasksLoaded(tasks));
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final updatedTasks = List<Task>.from(currentState.tasks)..add(event.task);
        emit(TasksLoaded(updatedTasks));
      }
    });

    on<UpdateTask>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TasksLoaded(updatedTasks));
      }
    });

    on<DeleteTask>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final updatedTasks = currentState.tasks.where((task) => task.id != event.id).toList();
        emit(TasksLoaded(updatedTasks));
      }
    });

    on<ToggleTaskCompletion>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.id) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();
        emit(TasksLoaded(updatedTasks));
      }
    });
  }
} 